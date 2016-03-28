package com.meread.buildenv.test.hadoop;

import com.meread.hadoop.IntSumReducer;
import com.meread.hadoop.TokenizerMapper;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileStatus;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;

/**
 * Created by yangxg on 16/2/1.
 */
public class HadoopTest {

    private static final String hdfsUrl = "hdfs://node1:9000";

    private FileSystem fs;
    private Configuration conf;

    @Before
    public void getConf() throws URISyntaxException, IOException {
        conf = new Configuration();
        conf.set("fs.defaultFS", hdfsUrl);
        conf.setInt("dfs.blocksize", 1048576);
        URI uri = new URI(hdfsUrl);
        fs = FileSystem.get(uri, conf);
    }

    @After
    public void closeClient() throws IOException {
        fs.close();
    }

    @Test
    public void del() throws URISyntaxException, IOException {
        fs.delete(new Path("/test/spark_output"), true);
        fs.delete(new Path("/test/hadoop_output"), true);
    }

    @Test
    public void mkdir() throws URISyntaxException, IOException {
        Path destFile = new Path("/test");
        fs.mkdirs(destFile);
    }

    @Test
    public void uploadFromLocal() throws URISyntaxException, IOException {
        String file = getClass().getClassLoader().getResource("4300.txt").getFile();
        Path localFile = new Path(file);
        Path destFile = new Path("/test/4300.txt");
        fs.copyFromLocalFile(false, true, localFile, destFile);
    }

    @Test
    public void ls() throws URISyntaxException, IOException {
        Path dir = new Path("/test");

        FileStatus[] list = fs.listStatus(dir);
        System.out.println("ls: /");
        System.out.println("==========================================================");
        for (FileStatus f : list) {
            System.out.printf("name: %s, folder: %s, size: %d\n", f.getPath(), f.isDirectory(), f.getLen());
        }
        System.out.println("==========================================================");
    }

    @Test
    public void wordCount() throws URISyntaxException, IOException, ClassNotFoundException, InterruptedException {
        Job job = Job.getInstance(conf, "wordcount");
        job.setMapperClass(TokenizerMapper.class);
        job.setCombinerClass(IntSumReducer.class);
        job.setReducerClass(IntSumReducer.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(IntWritable.class);
        Path destFile = new Path("/test/hadoop_output");
        fs.delete(destFile, true);
        FileInputFormat.addInputPath(job, new Path("/test/4300.txt"));
        FileOutputFormat.setOutputPath(job, new Path("/test/hadoop_output"));
        job.waitForCompletion(true);
    }


}
