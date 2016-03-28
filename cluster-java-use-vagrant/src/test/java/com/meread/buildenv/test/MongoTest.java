package com.meread.buildenv.test;

import com.mongodb.MongoClient;
import com.mongodb.MongoClientOptions;
import com.mongodb.ServerAddress;
import com.mongodb.client.MongoIterable;
import org.junit.Test;

import java.sql.SQLException;
import java.util.Arrays;

/**
 * Created by yangxg on 16/1/26.
 */
public class MongoTest {

    @Test
    public void test() throws SQLException {
        MongoClientOptions mcops = new MongoClientOptions.Builder().connectionsPerHost(50).build();
        MongoClient mongoClient = new MongoClient(Arrays.asList(new ServerAddress("11.11.11.101", 30000),
                new ServerAddress("11.11.11.102", 30000), new ServerAddress("11.11.11.103", 30000)), mcops);
        MongoIterable<String> dbNames = mongoClient.listDatabaseNames();
        String host = mongoClient.getAddress().getHost();
        System.out.println(host);
        for (String dbName : dbNames) {
            System.out.println(dbName);
        }
    }
}
