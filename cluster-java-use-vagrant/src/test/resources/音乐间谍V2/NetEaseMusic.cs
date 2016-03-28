using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using Newtonsoft.Json.Linq;

namespace XmDown
{
    public class NetEaseMusic
    {
        public static List<SongResult> GetResultsByKey(string key,int page)
        {
            key = key.Replace("-", "");
            page = (page - 1)*50;
            var html = GetSearchHtml(key, page);
            if (string.IsNullOrEmpty(html))
            {
                return null;
            }
            var json = JObject.Parse(html)["result"]["songs"];
            return json == null ? null : GetListByJson(json);
        }

        private static List<SongResult> GetListByJson(IEnumerable<JToken> jsons)
        {
            var list = new List<SongResult>();
            foreach (var json in jsons)
            {
                try
                {
                    var song = new SongResult
                    {
                        Name = XiamiMusic.CheckIsInValidate(json["name"].ToString()),
                        SongId = json["id"].ToString(),
                        Artist = XiamiMusic.CheckIsInValidate(json["artists"][0]["name"].ToString()),
                        Album = XiamiMusic.CheckIsInValidate(json["album"]["name"].ToString()),
                        AlbumId = json["album"]["id"].ToString(),
                        AlbumArtist = XiamiMusic.CheckIsInValidate(json["album"]["artists"][0]["name"].ToString()),
                        Company = XiamiMusic.CheckIsInValidate(json["album"]["company"].ToString()),
                        Year = ConvertIntDateTime(Convert.ToDouble(json["album"]["publishTime"])).ToString("yyyy年MM月dd日"),
                        PicUrl = json["album"]["picUrl"].ToString(),
                        LqUrl = json["mp3Url"].ToString(),
                        Time = json["duration"].ToString(),
                        Type = "NetEase"
                    };
                    try
                    {
                        song.TrackNum = json["position"].ToString().PadLeft(2, '0');
                    }
                    catch (Exception ex)
                    {
                        Console.Write(ex.ToString());
                    }

                    var hqUrl = GetHqUrl(json);
                    if (string.IsNullOrEmpty(hqUrl))
                    {
                        song.HqUrl = song.LqUrl;
                        song.BitRate = "160K";
                    }
                    else
                    {
                        song.HqUrl = hqUrl;
                        song.BitRate = "320K";
                    }
                    song.HqUrl = hqUrl;
                    song.CopyUrl = "http://www.musicuu.com/songurl/wy^320^" + song.SongId + ".mp3";
                    list.Add(song);
                }
                catch (Exception ex)
                {
                    Console.Write(ex.ToString());
                }
            }
            return list;
        }

        public static List<SongResult> GetAlbumList(string id)
        {
            var url = "http://music.163.com/api/album/" + id + "/";
            var html = CommonHelper.GetHtmlContent(url);
            if (string.IsNullOrEmpty(html))
            {
                return null;
            }
            var json = JObject.Parse(html)["album"]["songs"];
            return json == null ? null : GetListByJson(json);
        }

        public static List<SongResult> GetCollectList(string id)
        {
            var url = "http://music.163.com/api/playlist/detail?id=" + id +"&";
            var wc = new WebClient {Encoding = Encoding.UTF8};
            var html = wc.DownloadString(url);
            if (string.IsNullOrEmpty(html))
            {
                return null;
            }
            var json = JObject.Parse(html)["result"]["tracks"];
            return json == null ? null : GetListByJson(json);
        }

        public static List<SongResult> GetSingleList(string id)
        {
            var url = "http://music.163.com/api/song/detail/?ids=%5B" + id + "%5D";
            var html = CommonHelper.GetHtmlContent(url);
            if (string.IsNullOrEmpty(html))
            {
                return null;
            }
            var json = JObject.Parse(html)["songs"];
            return json == null ? null : GetListByJson(json);
        }

        public static List<SongResult> GetArtistList(string id)
        {
            var url = "http://music.163.com/api/artist/" + id + "/";
            var html = CommonHelper.GetHtmlContent(url);
            if (string.IsNullOrEmpty(html))
            {
                return null;
            }
            var json = JObject.Parse(html)["hotSongs"];
            return json == null ? null : GetListByJson(json);
        }

        private static DateTime ConvertIntDateTime(double d)
        {
            var startTime = TimeZone.CurrentTimeZone.ToLocalTime(new DateTime(1970, 1, 1));
            var time = startTime.AddMilliseconds(d);
            return time;
        }

        private static string GetHqUrl(JToken json)
        {
            var hToken = json["hMusic"];
            if (hToken.Type == JTokenType.Null)
            {
                hToken = json["bMusic"];
                if (hToken.Type == JTokenType.Null)
                {
                    return null;
                }
            }
            var dfsId = (string)hToken["dfsId"];
            var extension = (string)hToken["extension"];
            var encryptPath = EncryptId(dfsId);
            var url = string.Format("http://m2.music.126.net/{0}/{1}.{2}", encryptPath, dfsId, extension);
            return url;
        }

        private static string EncryptId(string dfsId)
        {
            var encoding = new ASCIIEncoding();
            var bytes1 = encoding.GetBytes("3go8&$8*3*3h0k(2)2");
            var bytes2 = encoding.GetBytes(dfsId);
            for (var i = 0; i < bytes2.Length; i++)
                bytes2[i] = (byte)(bytes2[i] ^ bytes1[i % bytes1.Length]);
            using (var md5Hash = MD5.Create())
            {
                var res = Convert.ToBase64String(md5Hash.ComputeHash(bytes2));
                res = res.Replace('/', '_').Replace('+', '-');
                return res;
            }
        }

        private static string GetSearchHtml(string key,int offset)
        {
            try
            {
                var url = new Uri("http://music.163.com/api/search/pc");
                var req = (HttpWebRequest)WebRequest.Create(url);
                req.Method = "POST";
                req.CookieContainer = new CookieContainer();
                req.CookieContainer.Add(url, new Cookie("os", "pc"));
                req.CookieContainer.Add(url, new Cookie("MUSIC_U", "5339640232"));
                req.ContentType = "application/x-www-form-urlencoded";
                using (var postStream = req.GetRequestStream())
                {
                    var postBytes = new ASCIIEncoding().GetBytes("offset=" + offset + "&total=true&limit=50&type=1&s=" + HttpUtility.UrlEncode((key + " " + "").Trim()));
                    postStream.Write(postBytes, 0, postBytes.Length);
                }
                var resp = req.GetResponse().GetResponseStream();
                if (resp == null)
                {
                    return null;
                }
                using (var reader = new StreamReader(resp))
                {
                    return reader.ReadToEnd();
                }
            }
            catch (Exception)
            {
                return "";
            }
        }
    }
}