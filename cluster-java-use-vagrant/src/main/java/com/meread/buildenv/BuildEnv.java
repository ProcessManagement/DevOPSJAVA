package com.meread.buildenv;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

/**
 * Created by yangxg on 16/1/14.
 */
public class BuildEnv {

    public static final List<HostInfo> ALL_HOST = new ArrayList<HostInfo>() {
        {
            add(new HostInfo("11.11.11.101", "node1"));
            add(new HostInfo("11.11.11.102", "node2"));
            add(new HostInfo("11.11.11.103", "node3"));
            add(new HostInfo("11.11.11.104", "haproxy"));
        }
    };

    private static final List<BuildThread> threadList = new ArrayList<BuildThread>() {
        {
            for (HostInfo hi : ALL_HOST) {
                BuildThread bt = new BuildThread(hi);
                add(bt);
            }
        }
    };

    public static String executeCommand(String command) {
        StringBuilder output = new StringBuilder();
        Process p;
        try {
            p = Runtime.getRuntime().exec(command);
            BufferedReader reader =
                    new BufferedReader(new InputStreamReader(p.getInputStream()));
            String line = "";
            while ((line = reader.readLine()) != null) {
                output.append(line).append("\n");
                System.out.println(line);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return output.toString();
    }

    private static void saveSnapShots() throws IOException {
        for (HostInfo hi : BuildEnv.ALL_HOST) {
            String command = "vagrant snapshot take " + hi.getHostName() + " " + hi.getHostName() + "-origin";
            System.out.println(command);
            executeCommand(command);
        }
    }

    private static void restoreSnapShots() throws IOException {
        for (HostInfo hi : BuildEnv.ALL_HOST) {
            executeCommand("vagrant snapshot go " + hi.getHostName() + " " + hi.getHostName() + "-origin");
        }
    }

    public static void main(String[] args) throws Exception {
        ExecutorService executor = Executors.newFixedThreadPool(4);

        for (BuildThread bt : threadList) {
            bt.configHostName();
        }
        System.out.println("配置网络完毕");

        for (final BuildThread bt : threadList) {
            executor.execute(new Runnable() {
                @Override
                public void run() {
                    try {
                        bt.installRequired();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            });
        }
        executor.shutdown();
        executor.awaitTermination(Long.MAX_VALUE, TimeUnit.DAYS);
        System.out.println("已安装必要的组件");

        for (BuildThread bt : threadList) {
            bt.installLocalRpm();
        }
        System.out.println("安装jdk和mariadb完毕");
        for (BuildThread bt : threadList) {
            bt.configJava();
        }
        System.out.println("配置jdk环境变量");
        for (final BuildThread bt : threadList) {
            bt.clearSSH("root");
        }
        for (final BuildThread bt : threadList) {
            bt.configSSH("root");
        }
        System.out.println("已配置ssh无密码登录");
        for (int i = threadList.size() - 2; i >= 0; i--) {
            BuildThread bt = threadList.get(i);
            bt.copyConfig(i == 0);
        }
        for (int i = threadList.size() - 2; i >= 1; i--) {
            BuildThread bt = threadList.get(i);
            bt.startMysql();
        }
        System.out.println("安装MariaDB完成");
        for (int i = threadList.size() - 2; i >= 0; i--) {
            BuildThread bt = threadList.get(i);
            bt.configMysqlRootLogin();
        }
        System.out.println("配置mysql root用户远程登录");
        threadList.get(threadList.size() - 1).configHaproxy();

        executor = Executors.newFixedThreadPool(3);
        for (int i = threadList.size() - 2; i >= 0; i--) {
            final BuildThread bt = threadList.get(i);
            executor.execute(new Runnable() {
                @Override
                public void run() {
                    try {
                        bt.installRedis();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            });
        }
        executor.shutdown();
        executor.awaitTermination(Long.MAX_VALUE, TimeUnit.DAYS);

        for (int i = threadList.size() - 2; i >= 0; i--) {
            BuildThread bt = threadList.get(i);
            bt.configRedisCluster();
        }
        threadList.get(0).createRedisCluster();
        System.out.println("redis集群配置完毕");
        for (int i = threadList.size() - 2; i >= 0; i--) {
            BuildThread bt = threadList.get(i);
            bt.installMongo();
        }
        for (int i = threadList.size() - 2; i >= 0; i--) {
            BuildThread bt = threadList.get(i);
            bt.copyMongodbConfig();
        }
        for (int i = threadList.size() - 2; i >= 0; i--) {
            BuildThread bt = threadList.get(i);
            bt.startShardServer();
        }

        for (int i = threadList.size() - 2; i >= 0; i--) {
            BuildThread bt = threadList.get(i);
            bt.startConfigServer();
        }
        for (int i = threadList.size() - 2; i >= 0; i--) {
            BuildThread bt = threadList.get(i);
            bt.startQueryRouters();
        }
        threadList.get(0).configMongoShard();
        for (int i = threadList.size() - 2; i >= 0; i--) {
            BuildThread bt = threadList.get(i);
            bt.configMongoAutorun();
        }

//        restoreSnapShots();

        for (int i = threadList.size() - 2; i >= 0; i--) {
            final BuildThread bt = threadList.get(i);
            bt.createHadoopUser();
        }
        for (int i = threadList.size() - 2; i >= 0; i--) {
            final BuildThread bt = threadList.get(i);
            bt.copyHadoopConfig();
        }
        for (int i = threadList.size() - 2; i >= 0; i--) {
            final BuildThread bt = threadList.get(i);
            bt.configSpark();
        }
        threadList.get(0).configHadoop();
        threadList.get(0).startHadoop();

        for (final BuildThread bt : threadList) {
            Thread.sleep(2000);
            bt.destroy();
        }

    }

}

