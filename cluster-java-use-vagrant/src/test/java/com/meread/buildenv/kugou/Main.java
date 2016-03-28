package com.meread.buildenv.kugou;

/**
 * Created by yangxg on 16/2/15.
 */
public class Main {
    public static void main(String[] args) {
        KuGouApi instance = KuGouApi.getInstance();
        instance.fetchSingers();
    }
}
