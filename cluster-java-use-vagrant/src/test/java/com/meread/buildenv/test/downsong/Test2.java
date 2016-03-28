package com.meread.buildenv.test.downsong;

import org.apache.commons.io.FileUtils;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by yangxg on 16/2/4.
 */
public class Test2 {
    public static void main(String[] args) throws IOException {
        File file = new File("/Users/yangxg/cluster-java-use-vagrant/src/test/resources/preDown.sh");
        List<String> strings = FileUtils.readLines(file);
        List<String> lines = new ArrayList<>();
        for (String line : strings) {
            String newLine = line + ";";
            lines.add(newLine);
        }
        FileUtils.writeLines(file,lines,false);
    }
}
