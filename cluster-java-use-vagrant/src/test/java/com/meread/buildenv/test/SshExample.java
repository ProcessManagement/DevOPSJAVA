package com.meread.buildenv.test;

import com.jcraft.jsch.Channel;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;
import net.sf.expectit.Expect;
import net.sf.expectit.ExpectBuilder;

import java.io.IOException;
import java.util.concurrent.TimeUnit;

import static net.sf.expectit.filter.Filters.removeColors;
import static net.sf.expectit.filter.Filters.removeNonPrintable;
import static net.sf.expectit.matcher.Matchers.contains;

/**
 * An example of interacting with SSH server
 */
public class SshExample {
    public static void main(String[] args) throws JSchException, IOException {
        JSch jsch = new JSch();
        String user = "yangxg";
        String host = "10.14.16.132";
        int port = 20755;
        String privateKey = "/Users/yangxg/easou/Identity";
        jsch.addIdentity(privateKey, "yangxg18f7db6".getBytes());

        Session session = jsch.getSession(user, host, port);

        java.util.Properties config = new java.util.Properties();
        config.put("StrictHostKeyChecking", "no");
        session.setConfig(config);
        session.connect(5000);
        System.out.println(host + "已连接...");

        Channel channel = session.openChannel("shell");
        channel.connect();

        Expect expect = new ExpectBuilder()
                .withOutput(channel.getOutputStream())
                .withInputs(channel.getInputStream(), channel.getExtInputStream())
                .withEchoInput(System.out)
                .withEchoOutput(System.err)
                .withInputFilters(removeColors(), removeNonPrintable())
                .withExceptionOnFailure()
                .withTimeout(200, TimeUnit.SECONDS)
                .withBufferSize(4096 * 2)
                .build();

        try {
            expect.expect(contains("$"));
            expect.sendLine("su - vidxrd");
            expect.expect(contains("assword:"));
            expect.sendLine("vidxrd49cda17e");
            expect.expect(contains("$"));
            expect.sendLine("ssh 10.13.25.56");
            expect.expect(contains("$"));
            expect.sendLine("su - book");
            expect.expect(contains("assword:"));
            expect.sendLine("easou_book");
            expect.expect(contains("$"));
            System.out.println("56登录成功!");
            expect.sendLine("exit");
            expect.expect(contains("$"));
            expect.sendLine("exit");
            expect.expect(contains("$"));

            expect.sendLine("ssh 10.13.25.57");
            expect.expect(contains("$"));
            expect.sendLine("su - book");
            expect.expect(contains("assword:"));
            expect.sendLine("easou_book");
            expect.expect(contains("$"));
            System.out.println("57登录成功!");
            expect.sendLine("exit");
            expect.expect(contains("$"));
            expect.sendLine("exit");
            expect.expect(contains("$"));

            expect.sendLine("ssh 10.13.27.223");
            expect.expect(contains("$"));
            expect.sendLine("su - datard");
            expect.expect(contains("assword:"));
            expect.sendLine("easou_datard");
            expect.expect(contains("$"));
            System.out.println("223登录成功!");
            expect.sendLine("exit");
            expect.expect(contains("$"));
            expect.sendLine("exit");
            expect.expect(contains("$"));

        } finally {
            expect.close();
            channel.disconnect();
            session.disconnect();
        }
    }
}