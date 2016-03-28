package com.meread;

import com.google.common.collect.Lists;
import org.apache.commons.io.FileUtils;
import org.apache.http.client.fluent.Request;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by yangxg on 16/2/18.
 */
public class DomainTest {
    static int processed = 0;

    private static final Logger logger = LoggerFactory.getLogger(DomainTest.class);

    public static void main(String[] args) throws IOException, InterruptedException {
        System.out.println("start..");
        File domain_result = new File(DomainTest.class.getClassLoader().getResource("tmp/domain_result.txt").getFile());
        final File result = new File(DomainTest.class.getClassLoader().getResource("tmp/result.txt").getFile());
        final File log = new File(DomainTest.class.getClassLoader().getResource("tmp/log.txt").getFile());
//        String s = FileUtils.readFileToString(cn);
//
//        for (char c : s.toCharArray()) {
//            if (!Character.valueOf(c).toString().trim().equals("")) {
//                FileUtils.write(cn_result, c + System.getProperty("line.separator"), true);
//            }
//        }
//        List<String> lines = FileUtils.readLines(cn_result);
//        for (String line : lines) {
//            String pinyin = PinyinHelper.convertToPinyinString(line.trim(), ",", PinyinFormat.WITHOUT_TONE);
//            FileUtils.write(pinyin_result, pinyin + System.getProperty("line.separator"), true);
//        }

//        List<String> lines = FileUtils.readLines(pinyin_result);
//        CombinationIterator<String> ci = new CombinationIterator<String>(lines, 2);
//
//        while (ci.hasNext()) {
//            List<String> next = ci.next();
//            FileUtils.write(domain_result, next.get(0) + next.get(1) + ".com" + System.getProperty("line.separator"), true);
//        }
        final List<String> lines = FileUtils.readLines(domain_result);
        final int total = lines.size();
        List<List<String>> subProcesses = Lists.partition(lines, 100);

        for (List<String> subProcess : subProcesses) {
            StringBuilder sb = new StringBuilder(200);
            for (String s : subProcess) {
                sb.append(s).append(",");
            }
            String url = "http://panda.www.net.cn/cgi-bin/check.cgi?area_domain=" + sb;
            try {
                String response = Request.Get(url).execute().returnContent().asString();
                if (!response.contains("216")) {
                    FileUtils.write(result, response + System.getProperty("line.separator"), true);
                    processed += 100;
                    logger.info(total + ":" + processed + " : " + response);
                    FileUtils.write(log, total + ":" + processed + " : " + response + System.getProperty("line.separator"), true);
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
            if (processed % 4000 == 0) {
                List<String> copy = new ArrayList<String>(lines);
                for (String s : subProcess) {
                    copy.remove(s);
                    FileUtils.writeLines(domain_result, copy, false);
                }
            }
        }
    }
}
