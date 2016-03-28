package com.meread.buildenv;

import org.apache.commons.lang3.StringUtils;

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
public class BuildEnv_bak {

    public static final List<HostInfo> ALL_HOST = new ArrayList<HostInfo>() {
        {
            add(new HostInfo("11.11.11.101", "node1"));
            add(new HostInfo("11.11.11.102", "node2"));
            add(new HostInfo("11.11.11.103", "node3"));
        }
    };

    private static String executeCommand(String command) {
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
        executeCommand("cd  /Users/yangxg/easou/vagrant");
        for (HostInfo hi : ALL_HOST) {
            executeCommand("vagrant snapshot take " + hi.getHostName() + " " + hi.getHostName() + "-origin");
        }
    }

    private static void restoreSnapShots() throws IOException {
        executeCommand("cd  /Users/yangxg/easou/vagrant");
        for (HostInfo hi : ALL_HOST) {
            executeCommand("vagrant snapshot go " + hi.getHostName() + " " + hi.getHostName() + "-origin");
        }
    }

    private static void restartAll() throws IOException {
        executeCommand("cd  /Users/yangxg/easou/vagrant");
        for (HostInfo hi : ALL_HOST) {
            String command = "vagrant ssh " + hi.getHostName() + " -c 'sudo reboot'";
            executeCommand(command);
        }
        int count = 0;
        while (count != ALL_HOST.size()) {
            String command = "vagrant status ";
            String result = executeCommand(command);
            count = StringUtils.countMatches(result, "running");
        }
    }

    public static void main(String[] args) throws Exception {
//        配置hostname
        executeCommand("cd  /Users/yangxg/easou/vagrant");
        List<BuildThread> threadList = new ArrayList<>();
        for (HostInfo hi : ALL_HOST) {
            BuildThread bt = new BuildThread(hi);
            threadList.add(bt);
        }
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

        //config ssh
        for (final BuildThread bt : threadList) {
            bt.clearSSH("root");
        }
        for (final BuildThread bt : threadList) {
            bt.configSSH("root");
        }
        System.out.println("已配置ssh无密码登录");
        for (final BuildThread bt : threadList) {
            bt.stopMysql();
        }
        saveSnapShots();
//
//        for (final BuildThread bt : threadList) {
//            bt.configJava();
//        }
//        System.out.println("安装jdk完成");
//
//        executor = Executors.newFixedThreadPool(4);
//        for (final BuildThread bt : threadList) {
//            executor.execute(new Runnable() {
//                @Override
//                public void run() {
//                    try {
//                        bt.configRedis();
//                    } catch (IOException e) {
//                        e.printStackTrace();
//                    }
//                }
//            });
//        }
//        executor.shutdown();
//        executor.awaitTermination(Long.MAX_VALUE, TimeUnit.DAYS);
//        System.out.println("安装redis完成");
//
//        for (final BuildThread bt : threadList) {
//            bt.configMongodb();
//        }
//        System.out.println("安装mongodb完成");

//        for (int i = threadList.size() - 1; i >= 0; i--) {
//            BuildThread bt = threadList.get(i);
//            bt.copyConfig(i == 0);
//        }
//        System.out.println("安装MariaDB完成");

        for (final BuildThread bt : threadList) {
            bt.destroy();
        }
    }

}

