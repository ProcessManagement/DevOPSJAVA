using System;
using System.Collections.Generic;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace XmDown
{
    public class KwMusic
    {
        public static List<SongResult> GetResultsByKey(string key, int page)
        {
            var url = "http://search.kuwo.cn/r.s?all=" + key + "&ft=music&itemset=web_2013&client=kt&pn=" + (page - 1) + "&rn=20&rformat=json&encoding=utf8";
            var html = CommonHelper.GetHtmlContent(url);
            if (string.IsNullOrEmpty(html))
            {
                return null;
            }
            var json = (JObject)JsonConvert.DeserializeObject(html.Trim('(', ')'));
            if (Convert.ToInt32(json["TOTAL"]) <= 0)
            {
                return null;
            }
            var list = new List<SongResult>();
            var songs = json["abslist"];
            foreach (JToken song in songs)
            {
                var single = new SongResult
                {
                    SongId = song["MUSICRID"].ToString(),
                    Name = song["SONGNAME"].ToString(),
                    Artist = song["ARTIST"].ToString(),
                    AlbumArtist = song["ARTIST"].ToString(),
                    Album = song["ALBUM"].ToString(),
                    AlbumId = song["ALBUMID"].ToString()
                };

                if (string.IsNullOrEmpty(single.AlbumId))
                {
                    single.AlbumId = "5211314";
                }
                var format = song["FORMATS"].ToString();
                if (format.Contains("MP3128"))
                {
                    single.LqUrl = "http://antiserver.kuwo.cn/anti.s?response=url&type=convert_url&br=128kmp3&format=mp3&rid=" + single.SongId;
                    single.BitRate = "128K";
                }
                if (format.Contains("MP3192"))
                {
                    single.HqUrl = "http://antiserver.kuwo.cn/anti.s?response=url&type=convert_url&br=192kmp3&format=mp3&rid=" + single.SongId;
                    single.BitRate = "192K";
                }
                if (format.Contains("MP3H"))
                {
                    single.HqUrl = "http://antiserver.kuwo.cn/anti.s?response=url&type=convert_url&br=320kmp3&format=mp3&rid=" + single.SongId;
                    single.LqUrl = "http://antiserver.kuwo.cn/anti.s?response=url&type=convert_url&br=192kmp3&format=mp3&rid=" + single.SongId;
                    single.BitRate = "320K";
                }
                if (format.Contains("AL"))
                {
                    single.ExtHqUrl = "http://antiserver.kuwo.cn/anti.s?response=url&type=convert_url&br=2000kflac&format=ape&rid=" + single.SongId;
                    single.BitRate = "无损";
                }

                

                if (format.Contains("MP4"))
                {
                    single.MvUrl = "http://antiserver.kuwo.cn/anti.s?response=url&type=convert_url&format=mp4&rid=" + single.SongId;
                }
                if (format.Contains("MV"))
                {
                    single.MvUrl = "http://antiserver.kuwo.cn/anti.s?response=url&type=convert_url&format=mkv&rid=" + single.SongId;
                }
                single.CopyUrl = "http://www.musicuu.com/songurl/kw^320^" + single.SongId + ".mp3";
                single.Type = "KW";
                list.Add(single);
            }
            return list;
        }

        public static string GetSongUrl(string url)
        {
            var html = CommonHelper.GetHtmlContent(url);
            return html;
        }
    }
}