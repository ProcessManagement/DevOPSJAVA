package com.meread.buildenv;

import com.meread.buildenv.test.LeftMoneyPackage;
import org.junit.Test;

import java.util.Random;

/**
 * Created by yangxg on 16/1/27.
 */
public class GenBao_my {

    public static double getRandomMoney(LeftMoneyPackage _leftMoneyPackage) {
        // remainSize 剩余的红包数量
        // remainMoney 剩余的钱
        if (_leftMoneyPackage.remainSize == 1) {
            _leftMoneyPackage.remainSize--;
            return (double) Math.round(_leftMoneyPackage.remainMoney * 100) / 100;
        }
        Random r = new Random();
        double min = 0.01; //
        double max = _leftMoneyPackage.remainMoney / _leftMoneyPackage.remainSize * 2;
        double money = r.nextDouble() * max;
        money = money <= min ? 0.01 : money;
        money = Math.floor(money * 100) / 100;
        _leftMoneyPackage.remainSize--;
        _leftMoneyPackage.remainMoney -= money;
        return money;
    }

    @Test
    public void testBao() {
        LeftMoneyPackage leftMoneyPackage = new LeftMoneyPackage();
        for (int i = 0; i < 100; i++) {
            double randomMoney = getRandomMoney(leftMoneyPackage);
            System.out.println(randomMoney);
        }
    }

}
