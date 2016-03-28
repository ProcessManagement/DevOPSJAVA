using System;
using System.Collections.Generic;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace XmDown
{
    public class TxMusic
    {
        //       ★获取歌词
        //http://music.qq.com/miniportal/static/lyric/歌曲id求余100/歌曲id.xml
        //        ★获取专辑插图
        //http://imgcache.qq.com/music/photo/album/专辑id求余100/albumpic_专辑id_0.jpg
        //http://vsrcmusic.tc.qq.com/5036372.mp3
        //http://vsrc.music.tc.qq.com/A00***.ape
        //http://vsrc.music.tc.qq.com/F00***.flac
        //http://vsrc.music.tc.qq.com/M80***.mp3
        //http://tsmusic128.tc.qq.com/{$SongId+30000000}.mp3
        public static List<SongResult> GetSearchResult(string key, int page)
        {
            var url =
                "http://soso.music.qq.com/fcgi-bin/music_search_new_platform?t=0&n=20&g_tk=157256710&loginUin=584586119&hostUin=0&format=jsonp&inCharset=GB2312&outCharset=utf-8&notice=0&platform=newframe&jsonpCallback=jsnp_callback&needNewCode=0&w=" + key + "&p=" + page + "&catZhida=1&remoteplace=sizer.newclient.song_all&searchid=11040987310239770213&clallback=jsnp_callback&lossless=0";
            var html = CommonHelper.GetHtmlContent(url).Replace("jsnp_callback", "").Trim('(', ')');
            if (string.IsNullOrEmpty(html))
            {
                return null;
            }

            var jobject = (JObject) JsonConvert.DeserializeObject(html.Replace("&amp;", "&"));
            if (!jobject.HasValues) return null;
            if (jobject["data"]["song"]["totalnum"].ToString() == "0") return null;
            var songs = jobject["data"]["song"]["list"];
            var list = new List<SongResult>();
            foreach (var song in songs)
            {
                if (song["isweiyun"].ToString()=="1")
                {
                    continue;
                }
                var f = song["f"].ToString();
                var single = new SongResult();
                if (f.Contains("@@"))
                {
                    var contents = f.Split(new []{"@@"}, StringSplitOptions.RemoveEmptyEntries);
                    single.SongId = System.Web.HttpUtility.HtmlDecode(contents[0].Trim());
                    single.Name = System.Web.HttpUtility.HtmlDecode(contents[1].Trim());
                    single.Album = System.Web.HttpUtility.HtmlDecode(contents[2].Trim());
                    single.AlbumArtist = single.Artist = System.Web.HttpUtility.HtmlDecode(single.Artist = contents[3].Trim());
                    single.HqUrl = single.LqUrl = single.ExtHqUrl = contents[contents.Length - 4].Trim();
                    single.BitRate = "128K";
                }
                else
                {
                    var contents = f.Split(new []{'|'}, StringSplitOptions.RemoveEmptyEntries);
                    single.SongId = contents[0];
                    single.Name = System.Web.HttpUtility.HtmlDecode(contents[1]);
                    single.Album = System.Web.HttpUtility.HtmlDecode(contents[5]);
                    single.AlbumArtist = single.Artist = System.Web.HttpUtility.HtmlDecode( contents[3]);
                    single.LqUrl = "http://tsmusic128.tc.qq.com/"+(Convert.ToInt32(single.SongId)+ 30000000) +".mp3";
                    var mid = contents[contents.Length-5];
                    if (f.Contains("320000|0|"))
                    {
                        single.BitRate = "320K";
                        single.HqUrl = "http://vsrc.music.tc.qq.com/M800" + mid + ".mp3";
                        if (!f.Contains("320000|0|0|"))
                        {
                            single.BitRate = "无损";
                            single.ExtHqUrl = "http://vsrc.music.tc.qq.com/F000" + mid + ".flac";
                        }
                    }
                    else
                    {
                        single.BitRate = "128K";
                        single.HqUrl = single.ExtHqUrl = single.LqUrl;
                    }
                    var aid = Convert.ToInt32(contents[4]);
                    single.AlbumId = aid.ToString();
                    single.PicUrl = "http://imgcache.qq.com/music/photo/album/" + aid % 100 + "/albumpic_" + aid + "_0.jpg";
                }
                single.CopyUrl = single.HqUrl;
                single.Type = "qq";
                list.Add(single);
            }
            return list;
        }
    }
}