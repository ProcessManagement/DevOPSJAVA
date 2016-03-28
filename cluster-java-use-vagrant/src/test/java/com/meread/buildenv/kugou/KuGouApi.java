package com.meread.buildenv.kugou;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.meread.buildenv.kugou.entity.Singer;
import com.mongodb.MongoClient;
import com.mongodb.MongoClientOptions;
import com.mongodb.ReadPreference;
import com.mongodb.ServerAddress;
import org.apache.http.client.fluent.Request;
import org.mongodb.morphia.Datastore;
import org.mongodb.morphia.Morphia;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.*;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Created by yangxg on 16/2/15.
 */
public final class KuGouApi {

    private static final Logger LOGGER = LoggerFactory.getLogger(KuGouApi.class);

    private static class LazyHolder {
        private static final KuGouApi INSTANCE = new KuGouApi();
    }

    private MongoClient mongoClient;

    private Datastore datastore;

    final Morphia morphia = new Morphia();

    private KuGouApi() {
        morphia.mapPackage("com.meread.buildenv.kugou.entity");
        mongoClient = new MongoClient(mongoServerAddresses, mcops);
        mongoClient.setReadPreference(ReadPreference.secondaryPreferred());
        datastore = morphia.createDatastore(mongoClient, "music");
        datastore.ensureIndexes();
    }

    public static KuGouApi getInstance() {
        return LazyHolder.INSTANCE;
    }

    private static final ObjectMapper om = new ObjectMapper();

    private static final Map<String, String> SINGER_CATEGORY = new HashMap<String, String>() {
        {
            put("华语男歌手", "http://mobilecdn.kugou.com/api/v3/singer/list?type=1&showtype=2&sextype=1&with_res_tag=0");
            put("华语女歌手", "http://mobilecdn.kugou.com/api/v3/singer/list?type=1&showtype=2&sextype=2&with_res_tag=0");
            put("华语组合", "http://mobilecdn.kugou.com/api/v3/singer/list?type=1&showtype=2&sextype=3&with_res_tag=0");
            put("欧美男歌手", "http://mobilecdn.kugou.com/api/v3/singer/list?type=2&showtype=2&sextype=1&with_res_tag=0");
            put("欧美女歌手", "http://mobilecdn.kugou.com/api/v3/singer/list?type=2&showtype=2&sextype=2&with_res_tag=0");
            put("欧美组合", "http://mobilecdn.kugou.com/api/v3/singer/list?type=2&showtype=2&sextype=3&with_res_tag=0");
            put("日韩男歌手", "http://mobilecdn.kugou.com/api/v3/singer/list?type=3&showtype=2&sextype=1&with_res_tag=0");
            put("日韩女歌手", "http://mobilecdn.kugou.com/api/v3/singer/list?type=3&showtype=2&sextype=2&with_res_tag=0");
            put("日韩组合", "http://mobilecdn.kugou.com/api/v3/singer/list?type=3&showtype=2&sextype=3&with_res_tag=0");
        }
    };

    private static final List<ServerAddress> mongoServerAddresses = new ArrayList<ServerAddress>() {
        {
            add(new ServerAddress("11.11.11.101", 30000));
            add(new ServerAddress("11.11.11.102", 30000));
            add(new ServerAddress("11.11.11.103", 30000));
        }
    };

    private static final MongoClientOptions mcops = new MongoClientOptions.Builder().connectionsPerHost(50).build();

    int total = 0;
    int complete = 0;

    public void fetchSingers() {

        ExecutorService executor = Executors.newFixedThreadPool(30);
        for (final String key : SINGER_CATEGORY.keySet()) {
            try {
                String url = SINGER_CATEGORY.get(key);
                String response = Request.Get(url).execute().returnContent().asString();
                final Map<String, Object> singerListData = om.readValue(response, Map.class);
                if (singerListData.get("status").equals(1)) {
                    Map<String, Object> stemp = (Map<String, Object>) singerListData.get("data");
                    List<Map<String, Object>> singerListMap = (List<Map<String, Object>>) stemp.get("info");
                    for (int i = 1; i < singerListMap.size(); i++) {
                        Map<String, Object> catSingers = singerListMap.get(i);
                        final List<Map<String, Object>> singers = (List<Map<String, Object>>) catSingers.get("singer");
                        executor.execute(new Runnable() {
                            @Override
                            public void run() {
                                try {
                                    total += singers.size();
                                    LOGGER.info("total {}", total);
                                    processSubData(singers, key);
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            }
                        });
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private void processSubData(List<Map<String, Object>> subData, String type) throws Exception {
        for (Map<String, Object> singer : subData) {
            Integer singerid = (Integer) singer.get("singerid");
            Integer songcount = (Integer) singer.get("songcount");
            String singerDetailData = Request.Get("http://mobileservice.kugou.com/api/v3/singer/info?singerid=" + singerid + "&with_res_tag=0").execute().returnContent().asString();
            Map<String, Object> singerDetailMap = om.readValue(singerDetailData, Map.class);
            Map<String, Object> sitemp = (Map<String, Object>) singerDetailMap.get("data");
            Singer si = new Singer();
            si.setType(type);
            si.setAddTime(new Date());
            si.setAlbumCount((Integer) sitemp.get("albumcount"));
            si.setImgUrl((String) sitemp.get("imgurl"));
            si.setIntro((String) sitemp.get("intro"));
            Integer kugouSingerId = (Integer) sitemp.get("singerid");
            si.setKugouSingerId(kugouSingerId);
            si.setMvCount((Integer) sitemp.get("mvcount"));
            String singerName = (String) sitemp.get("singername");
            si.setName(singerName);
            si.setSongCount(songcount);
            si.setUpdateTime(new Date());
            saveOrUpdateSinger(si);
            LOGGER.info("总数: {} , 已完成: {}", total, ++complete);
        }
    }

    private void saveOrUpdateSinger(Singer si) {
        datastore.save(si);
    }


    public void testSave() {
        Singer singer = new Singer();
        singer.setAddTime(new Date());
        singer.setAlbumCount(1);
        singer.setUpdateTime(new Date());
        singer.setImgUrl("dddd");
        singer.setIntro("aabbcc");
        singer.setKugouSingerId(111);
        singer.setMvCount(10);
        singer.setName("eeee");
        singer.setType("大陆dsafsa");
        datastore.save(singer);
    }
}
