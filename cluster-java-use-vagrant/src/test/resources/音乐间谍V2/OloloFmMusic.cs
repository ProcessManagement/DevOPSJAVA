using System;
using System.Collections.Generic;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace XmDown
{
    public class OloloFmMusic
    {
        public static List<SongResult> GetResultsByKey(string key,int page)
        {
            var url = "https://api.vk.com/method/audio.search?q="+key+"&count=30&page"+page+"&https=0&access_token=6c2905fdc2c76b3c42e7a39951efcd1e7b00d54d834c1fa8580e9aae8e9f613cf61ce41ba8e2c47c752d3";
            var html = CommonHelper.GetHtmlContent(url);
            if (string.IsNullOrEmpty(html))
            {
                return null;
            }
            var json = (JObject)JsonConvert.DeserializeObject(html.Trim('(', ')'));
            if (Convert.ToInt32(json["response"][0]) <= 0)
            {
                return null;
            }
            var list = new List<SongResult>();
            var songs = json["response"];
            var index = 0;
            foreach (JToken song in songs)
            {
                if (index == 0)
                {
                    index++;
                    continue;
                }
                var single = new SongResult()
                {
                    SongId = song["aid"].ToString(),
                    Name = song["title"].ToString(),
                    Artist = song["artist"].ToString(),
                    AlbumArtist = song["artist"].ToString(),
                    AlbumId = "1990",
                    Type = "VK",
                    LqUrl = song["url"].ToString(),
                    HqUrl = song["url"].ToString(),
                    ExtHqUrl = song["url"].ToString()
                };

                list.Add(single);
            }
            return list;
        } 
    }
}