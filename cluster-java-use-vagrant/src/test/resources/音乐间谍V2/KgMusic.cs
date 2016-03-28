using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Web.Security;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace XmDown
{
    public class KgMusic
    {
        public static List<SongResult> GetResultsByKey(string key, int page)
        {
            var url =
                "http://mobilecdn.kugou.com/api/v3/search/song?format=jsonp&keyword="+key+"&page="+page+"&pagesize=20&showtype=1";
            var html = CommonHelper.GetHtmlContent(url);
            if (string.IsNullOrEmpty(html))
            {
                return null;
            }
            var json = (JObject)JsonConvert.DeserializeObject(html.Trim('(', ')'));
            if (Convert.ToInt32(json["data"]["total"]) <= 0)
            {
                return null;
            }
            var list = new List<SongResult>();
            var songs = json["data"]["info"];
            foreach (JToken song in songs)
            {
                var single = new SongResult {Artist = song["singername"].ToString(), Name = song["filename"].ToString(),Type = "KG"};
                if (string.IsNullOrEmpty(single.Artist))
                {
                    if (single.Name.Contains("-"))
                    {
                        single.Artist = single.Name.Substring(0, single.Name.IndexOf('-')).Trim();
                        single.Name = single.Name.Substring(single.Name.IndexOf('-')+1).Trim();
                    }
                }
                else
                {
                    var name = single.Name.Substring(0, single.Name.IndexOf('-')).Trim();
                    if (single.Artist.Trim() == name)
                    {
                        single.Name = single.Name.Substring(single.Name.IndexOf('-')+1).Trim();
                    }
                }
                single.AlbumArtist = single.Artist;
                single.AlbumId = "19930119";

                if (!string.IsNullOrEmpty(song["hash"].ToString()))
                {
                    single.LqUrl = song["hash"].ToString();
                    single.BitRate = song["bitrate"] + "K";
                }

                if (!string.IsNullOrEmpty(song["mvhash"].ToString()))
                {
                    single.MvUrl = song["mvhash"].ToString();
                }

                if (!string.IsNullOrEmpty(song["320hash"].ToString()))
                {
                    single.HqUrl = song["320hash"].ToString();
                    single.BitRate = "320K";
                }

                if (!string.IsNullOrEmpty(song["sqhash"].ToString()))
                {
                    single.ExtHqUrl = song["sqhash"].ToString();
                    single.BitRate = "无损";
                }
                single.CopyUrl = "http://www.musicuu.com/songurl/kg^320^" + single.SongId + ".mp3";
                list.Add(single);
            }


            return list;
        }

        public static string GetUrlByHash(string hash)
        {
            if (string.IsNullOrEmpty(hash))
            {
                return "";
            }
            var key = FormsAuthentication.HashPasswordForStoringInConfigFile((hash + "kgcloud"), "MD5");
            var url = "http://trackercdn.kugou.com/i/?key=" + key + "&cmd=4&acceptMp3=1&hash=" + hash + "&pid=1";
            var html = CommonHelper.GetHtmlContent(url);
            var json = (JObject)JsonConvert.DeserializeObject(html);
            if (json["status"].ToString() == "0")
            {
                return "";
            }
            var songUrl = json["url"].ToString();
            return songUrl;
        }
    }
}