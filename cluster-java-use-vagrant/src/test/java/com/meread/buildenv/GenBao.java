package com.meread.buildenv;

import org.junit.Assert;
import org.junit.Test;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

/**
 * Created by yangxg on 16/1/27.
 */
public class GenBao {

    private static final Random RANDOM = new Random();

    public static int nextInt(int startInclusive, int endExclusive) {
        if (startInclusive == endExclusive) {
            return startInclusive;
        }
        return startInclusive + RANDOM.nextInt(endExclusive - startInclusive);
    }

    @Test
    public void test() {
        for (int testCount = 0; testCount < 20; testCount++) {
            gen();
        }
    }

    @Test
    public void gen() {
        //单位:分
        final int m = 450;
        final int min = 1;
        final int n = 10;

        //第一次随机最大钱数  总金额    -   (n-1)个人都分了9分钱  其余那个人分剩下所有
        int initMax = m - (n - 1) * min;
        int initTotal = m;
        List<Integer> result = new ArrayList<>();

        int validTotal = 0;

        for (int i = 1; i <= n; i++) {
            if (i == n) {
                int lastOne = m - validTotal;
                result.add(lastOne);
                validTotal += lastOne;
                break;
            }
            int v = nextInt(min, initMax);
            int avg = initTotal / (n - i);
            while (Math.abs(v - avg) > avg) {
                v = nextInt(min, initMax);
            }
            result.add(v);
            validTotal += v;
            initTotal = initTotal - v;
            initMax = initTotal - (n - i - 1) * min;
        }

        System.out.println(result);
        Assert.assertTrue(validTotal == m);

    }

}
