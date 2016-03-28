package com.meread.buildenv.test;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.sql.*;

public class MariaDBTest {

    Connection connection;

    @Test
    public void test() throws SQLException {
        String queryNovel = "select host,user from user";
        Statement stmt = connection.createStatement();
        ResultSet result = stmt.executeQuery(queryNovel);
        while (result.next()) {
            String host = result.getString("host");
            String user = result.getString("user");
            System.out.println("host : " + host + ",user : " + user);
        }
        stmt.close();
    }


    @Before
    public void loadDriver() {
        try {
            connection = DriverManager
                    .getConnection("jdbc:mysql://11.11.11.104:3307/mysql?useUnicode=true&characterEncoding=UTF-8", "root", "vagrant");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @After
    public void close() {
        try {
            if (connection != null) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

}
