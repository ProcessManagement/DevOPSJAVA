package com.meread.buildenv.test;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import redis.clients.jedis.HostAndPort;
import redis.clients.jedis.JedisCluster;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;

import java.io.IOException;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * Created by yangxg on 15/12/17.
 */
public class RedisTest {

    private JedisCluster jedisCluster;

    @Before
    public void assertCluster() {
        Set<HostAndPort> clusterNodes = new HashSet<HostAndPort>();
        clusterNodes.add(new HostAndPort("11.11.11.101", 6379));
        clusterNodes.add(new HostAndPort("11.11.11.101", 6380));
        clusterNodes.add(new HostAndPort("11.11.11.102", 6379));
        clusterNodes.add(new HostAndPort("11.11.11.102", 6380));
        clusterNodes.add(new HostAndPort("11.11.11.103", 6379));
        clusterNodes.add(new HostAndPort("11.11.11.103", 6380));
        JedisPoolConfig config = new JedisPoolConfig();
        config.setMaxTotal(1000);
        config.setMaxIdle(100);
        config.setTestOnBorrow(true);
        jedisCluster = new JedisCluster(clusterNodes, 5000, config);
    }

    @Test
    public void set() {
        for (int i = 0; i < 100; i++) {
            jedisCluster.set("key" + i, "value" + i);
        }
    }

    @Test
    public void getClusterNodes() {
        Map<String, JedisPool> clusterNodes = jedisCluster.getClusterNodes();
        for (String key : clusterNodes.keySet()) {
            System.out.println(key);
        }
    }

    @Test
    public void getKey() {
        String key1 = jedisCluster.get("key2");
        System.out.println(key1);
    }

    @After
    public void closePool() {
        try {
            jedisCluster.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

}
