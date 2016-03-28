package com.meread.buildenv.test.downsong;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.http.client.fluent.Request;
import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.IOException;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by yangxg on 16/2/4.
 */
public class Test {

    private static final Logger logger = LoggerFactory.getLogger(Test.class);

    public static void main(String[] args) {
        final ObjectMapper om = new ObjectMapper();
        File dir = new File("/Users/yangxg/经典老歌500");
        File dirNew = new File("/Users/yangxg/经典老歌500_高音质");
        File preDown = new File("/Users/yangxg/经典老歌500_高音质/preDown.sh");
        if (!dirNew.exists()) {
            dirNew.mkdir();
        }
        Collection<File> mp3s = FileUtils.listFiles(dir, null, false);
        Pattern p = Pattern.compile("(.*)\\((.*?)\\)\\.[mM][pP]3");
        String apiTpl = "http://api.musicuu.com/music/search/kw/%s/1?format=json";
        int success = 0;
        for (File mp3 : mp3s) {
            String fileName = mp3.getName();
            Matcher m = p.matcher(fileName);
            if (m.find()) {
                String song = m.group(1).trim();
                String singer = m.group(2).trim();
                String api = String.format(apiTpl, song);
                String response = null;
                String saveFileName = song + "(" + singer + ").mp3";
                String parent = mp3.getParent() + File.separator;
                String newFileName = parent + saveFileName;
                mp3.renameTo(new File(newFileName));
                try {
                    response = Request.Get(api).execute().returnContent().asString();
                    List<Map<String, String>> listMap = om.readValue(response, List.class);
                    for (Map<String, String> songInfo : listMap) {
                        String hqUrl = songInfo.get("HqUrl");
                        String artist = songInfo.get("Artist");
                        if (artist.equals(singer) && StringUtils.isNotEmpty(hqUrl)) {
                            success++;
                            File file = new File(dirNew.getAbsolutePath() + File.separator + saveFileName);
                            String wgetCommand = "wget -O '" + saveFileName + "' " + hqUrl + "\r\n";
                            FileUtils.write(preDown, wgetCommand, true);
//                            if (!file.exists()) {
//                                logger.info(song + "(" + singer + ") : " + hqUrl);
//                                byte[] songBin = Request.Get(hqUrl).execute().returnContent().asBytes();
//                                FileUtils.writeByteArrayToFile(file, songBin);
//                            }
                            break;
                        }
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                    logger.error(song + "(" + singer + ") : " + api);
                }
            }
        }
        System.out.println(success);
    }
}
