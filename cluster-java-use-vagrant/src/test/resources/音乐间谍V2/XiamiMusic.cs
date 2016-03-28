using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Net;
using System.Text;
using System.Text.RegularExpressions;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace XmDown
{
    public class XiamiMusic
    {
        private static string _cookieContainer;
        #region 虾米账户初始化---已移除
        /// <summary>
        /// 初始化虾米Vip
        /// </summary>
        public static void InitXiamiVip()
        {
            try
            {
                var vip = "_xiamitoken=" + Guid.NewGuid().ToString("N").ToLower() + "done=http%253A%252F%252Fwww.xiami.com%252F&type=&email=*************&password=*************&autologin=1&submit=%E7%99%BB+%E5%BD%95";
                _cookieContainer = CommonHelper.GetCooKie("https://login.xiami.com/member/login", vip);
            }
            catch (Exception)
            {
                Console.WriteLine("");
            }
        }

        #endregion


        /// <summary>
        /// 根据关键词以及页码初始化第一次搜索结果
        /// </summary>
        /// <param name="key">关键词</param>
        /// <param name="page">页码</param>
        /// <returns>歌曲结果</returns>
        public static List<SongResult> GetSearchResult(string key, int page)
        {
            var html =
                CommonHelper.GetHtmlContent(
                    "http://www.xiami.com/web/search-songs/page/" + page + "?spm=0.0.0.0.82mhoN&key=" + key + "&_xiamitoken=abchdjah6264817");
            if (string.IsNullOrEmpty(html) || html == "null")
            {
                return null;
            }
            var jsonId = (JArray)JsonConvert.DeserializeObject(html.Replace("&amp;", "&"));
            if (!jsonId.HasValues) return null;
            var ids = "";
            foreach (var j in jsonId)
            {
                if (!j.HasValues) continue;
                ids += (j["id"] + ",");
            }
            return GetResultsByIds(ids, 0);
        }

        /// <summary>
        /// 通过Ids获取搜索结果
        /// </summary>
        /// <param name="ids">歌曲Id的组合</param>
        /// <param name="type">类型 0-song 1-album 2-artist 3-collect</param>
        /// <returns>歌曲结果</returns>
        private static List<SongResult> GetResultsByIds(string ids, int type)
        {
            var albumUrl = "http://www.xiami.com/song/playlist/id/" + ids + "/type/"+type+"/cat/json";
            var html = CommonHelper.GetHtmlContent(albumUrl);
            if (string.IsNullOrEmpty(html))
            {
                return null;
            }
            var jobject = new JObject();
            try
            {
                jobject = (JObject)JsonConvert.DeserializeObject(html);
            }
            catch (Exception ex)
            {
                Console.Write(ex.ToString());
            }
            
            var dataList = jobject["data"]["trackList"];

            if (string.IsNullOrEmpty(dataList.ToString()))
            {
                return null;
            }

            var match = Regex.Match("","");
            var pageHtml = "";
            if (type == 1)
            {
                var albumPage = "http://www.xiami.com/album/" + ids.Trim();
                pageHtml = CommonHelper.GetHtmlContent(albumPage);
                match = Regex.Match(pageHtml, @"(?<=艺人[\s\S]+?artist/\d+[^>]+>)([^<]+)(?:<[\s\S]+?语种[\s\S]+?valign=""top"">)([^<]+)(?:[\s\S]+?唱片公司[\s\S]+?target=""_blank"">)([^<]+)(?:[\s\S]+?发行时间：[\s\S]+?valign=""top"">)([^<]+)");
            }
            InitXiamiVip();
            var list = new List<SongResult>();
            foreach (JToken data in dataList)
            {
                var sr = new SongResult
                {
                    Album = CheckIsInValidate(System.Web.HttpUtility.HtmlDecode(data["album_name"].ToString())),
                    AlbumId = data["album_id"].ToString(),
                    Artist = CheckIsInValidate(System.Web.HttpUtility.HtmlDecode(data["artist"].ToString())),
                    SongId = data["song_id"].ToString(),
                    Name = CheckIsInValidate(System.Web.HttpUtility.HtmlDecode(data["title"].ToString())),
                    LqUrl = Jurl(data["location"].ToString()),
                    LrcUrl = data["lyric_url"].ToString(),
                    PicUrl = data["album_pic"].ToString(),
                    Time = CommonHelper.NumToTime(data["length"].ToString()),
                    Type = "Xiami"
                };
                if (type != 1)
                {
                    var albumPage = "http://www.xiami.com/album/" + sr.AlbumId.Trim();
                    pageHtml = CommonHelper.GetHtmlContent(albumPage);
                    match = Regex.Match(pageHtml, @"(?<=艺人[\s\S]+?artist/\d+[^>]+>)([^<]+)(?:<[\s\S]+?语种[\s\S]+?valign=""top"">)([^<]+)(?:[\s\S]+?唱片公司[\s\S]+?target=""_blank"">)([^<]+)(?:[\s\S]+?发行时间：[\s\S]+?valign=""top"">)([^<]+)");
                }
                var trackM = Regex.Match(pageHtml, @"(?<=trackid"">)(\d+)(?=</td>\s*<td class=""song_name"">\s*<a\s*href=""/song/"+sr.SongId+ ")");

                sr.AlbumArtist = CheckIsInValidate(match.Groups[1].Value);
                sr.Language = match.Groups[2].Value;
                sr.Company = match.Groups[3].Value;
                sr.Year = match.Groups[4].Value;
                sr.TrackNum = trackM.Groups[1].Value.Trim().PadLeft(2, '0');
                if (string.IsNullOrEmpty(sr.AlbumArtist))
                {
                    sr.AlbumArtist = sr.Artist.Contains(";") ? sr.Artist.Split(';')[0].Trim() : sr.Artist;
                }

                sr.HqUrl = GetHqUrl(sr.SongId);
                if (string.IsNullOrEmpty(sr.HqUrl))
                {
                    sr.BitRate = "128K";
                    sr.ExtHqUrl = sr.HqUrl = sr.LqUrl;
                }
                else
                {
                    sr.BitRate = !sr.HqUrl.Contains("m5") ? "320K" : "128K";
                    sr.ExtHqUrl = sr.HqUrl;
                }
                sr.CopyUrl = "http://www.musicuu.com/songurl/xm^320^" + sr.SongId + ".mp3";
                if (sr.BitRate == "128K")
                {
                    sr.ExtHqUrl = sr.HqUrl = sr.LqUrl = sr.CopyUrl;
                }
                sr.Artist = System.Web.HttpUtility.HtmlDecode(sr.Artist);
                sr.Name = System.Web.HttpUtility.HtmlDecode(sr.Name);
                sr.AlbumArtist = System.Web.HttpUtility.HtmlDecode(sr.AlbumArtist);
                sr.Album = System.Web.HttpUtility.HtmlDecode(sr.Album);
                list.Add(sr);
            }

            return list;
        }

        public static string GetHqUrl(string id)
        {
            var str = GetHtml("http://www.xiami.com/song/gethqsong/sid/" + id + "/", _cookieContainer);
            var value = Regex.Match(str, @"location"":""([\s\S]+?)""").Groups[1].Value;
            if (value.Length < 10)
            {
                return "";
            }
            return Jurl(value);
        }

        /// <summary>
        /// 解密虾米地址
        /// </summary>
        /// <param name="url">被加密的字符串</param>
        /// <returns>解析后的歌曲链接</returns>
        private static string Jurl(string url)
        {
            if (string.IsNullOrEmpty(url))
            {
                return "";
            }
            var num = Convert.ToInt32(url.Substring(0, 1));
            var newurl = url.Substring(1);
            var yushu = newurl.Length % num;
            var colunms = (int)Math.Ceiling((double)newurl.Length / num);
            var arrList = new string[num];
            var a = 0;
            for (var i = 0; i < num; i++)
            {
                if (i < yushu)
                {
                    arrList[i] = newurl.Substring(a, colunms);
                    a += colunms;
                }
                else
                {
                    if (yushu == 0)
                    {
                        arrList[i] = newurl.Substring(a, colunms);
                        a += colunms;
                    }
                    else
                    {
                        arrList[i] = newurl.Substring(a, colunms - 1);
                        a += (colunms - 1);
                    }
                }
            }
            var sb = new StringBuilder();
            if (yushu == 0)
            {
                for (var i = 0; i < colunms; i++)
                {
                    for (var j = 0; j < num; j++)
                    {
                        sb.Append(arrList[j].Substring(i, 1));
                    }
                }
            }
            else
            {
                for (var i = 0; i < colunms; i++)
                {
                    if (i == colunms - 1)
                    {
                        for (var j = 0; j < yushu; j++)
                        {
                            sb.Append(arrList[j].Substring(i, 1));
                        }
                    }
                    else
                    {
                        for (var j = 0; j < num; j++)
                        {
                            sb.Append(arrList[j].Substring(i, 1));
                        }
                    }
                }
            }
            var str = System.Web.HttpUtility.UrlDecode(sb.ToString());
            return str == null ? "" : Regex.Replace(Regex.Replace(Regex.Replace(str, @"\^", "0"), @"\+", " "), ".mp$", ".mp3");
        }

        public static List<SongResult> GetAlbumResult(string albumId)
        {
            return GetResultsByIds(albumId, 1);
        }

        public static List<SongResult> GetSingeResult(string songId)
        {
            return GetResultsByIds(songId, 0);
        }

        public static List<SongResult> GetCollectResult(string collectId)
        {
            return GetResultsByIds(collectId, 3);
        }

        public static List<SongResult> GetArtistResult(string artistId)
        {
            return GetResultsByIds(artistId, 2);
        }

        public static List<SongResult> GetLoveResult(string uId, string page)
        {
            var html = CommonHelper.GetHtmlContent("http://www.xiami.com/space/lib-song/u/" + uId + "/page/" + page);
            var matches = Regex.Matches(html, @"(?<=song_name[\s\S]+?xiami.com/song/)\d+(?="")");
            var ids = "";
            foreach (Match match in matches)
            {
                ids += (match.Value + ",");
            }
            ids = ids.TrimEnd(',');
            return GetResultsByIds(ids, 0);
        }

        public static string CheckIsInValidate(string name)
        {
            var matches = Regex.Matches(name, "[\\/|:*?\"<>]");
            if (matches.Count <= 0) return name;
            foreach (Match match in matches)
            {
                name = name.Replace(match.Value, "");
            }
            return name.Replace(";","&").Replace("；","&");
        }

        public static string GetAlbumInfo(SongResult srResult)
        {
            var albumPage = "http://www.xiami.com/web/album/id/" + srResult.AlbumId.Trim();
            var pageHtml = System.Web.HttpUtility.HtmlDecode(CommonHelper.GetHtml(albumPage, _cookieContainer));
            if (string.IsNullOrEmpty(pageHtml))
            {
                return "";
            }
            var match = Regex.Match(pageHtml, @"(?<=演唱者[\s\S]+?>)([\s\S]+?)(?:</a></li>\s*<li>语种：)(.+)(?:</li>\s*<li>唱片公司：)([\s\S]+?)(?:</li>\s*<li>发行时间：)(.+)(?=</li>)");
            var sb = new StringBuilder();
            sb.AppendLine(string.Format("==={0}===", srResult.Album));
            sb.AppendLine("");
            sb.AppendLine(string.Format("演唱者：{0}", match.Groups[1].Value));
            sb.AppendLine(string.Format("语种：{0}", match.Groups[2].Value));
            sb.AppendLine(string.Format("唱片公司：{0}", match.Groups[3].Value));
            sb.AppendLine(string.Format("发行时间：{0}", string.IsNullOrEmpty(srResult.Year) ? match.Groups[4].Value : srResult.Year));
            sb.AppendLine("");
            sb.AppendLine("专辑介绍");
            sb.AppendLine("");
            sb.AppendLine("===歌曲列表===");
            sb.AppendLine("");

            var cds = Regex.Matches(pageHtml, @"(?<=strong>)CD[\S\s]+?(?=</strong>)");

            var a = 0;

            foreach (Match cd in cds)
            {
                a++;
                sb.AppendLine(string.Format("==={0}===", cd.Value));

                if (cds.Count > 1)
                {
                    string regStr;
                    if (a == cds.Count)
                    {
                        regStr = "CD" + a + @"[\s\S]+";
                    }
                    else
                    {
                        regStr = "CD" + a + @"[\s\S]+?" + "CD" + (a+1);
                    }
                    var myText = Regex.Match(pageHtml, regStr).Value;
                    var matches = Regex.Matches(myText, @"(?<=web/song/id/\d+"">)[\S\s]+?(?=</a></li>)");
                    foreach (Match match1 in matches)
                    {
                        sb.AppendLine(match1.Value);
                    }
                }
                else
                {
                    var matches = Regex.Matches(pageHtml, @"(?<=web/song/id/\d+"">)[\S\s]+?(?=</a></li>)");
                    foreach (Match match1 in matches)
                    {
                        sb.AppendLine(match1.Value);
                    }
                }

                sb.AppendLine("");
            }

            return sb.ToString();
        }

        public static string GetHtml(string getUrl, string cookieContainer)
        {
            HttpWebResponse httpWebResponse = null;
            try
            {
                var xmRequest = (HttpWebRequest)WebRequest.Create(getUrl);
                xmRequest.Headers.Add("Cookie",cookieContainer);
                xmRequest.Referer = "http://img.xiami.net/static/swf/seiya/1.5/player.swf?v=" + (DateTime.Now.Ticks - TimeZone.CurrentTimeZone.ToLocalTime(new DateTime(1970, 1, 1, 0, 0, 0, 0)).Ticks) / 10000;
                xmRequest.Accept = @"*/*";
                xmRequest.UserAgent = @"Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.101 Safari/537.36";
                xmRequest.Method = "GET";
                xmRequest.Headers.Add("Accept-Encoding", "gzip,deflate,sdch,");
                xmRequest.Headers.Add("Accept-Language", "zh-CN,zh;q=0.8");
                xmRequest.KeepAlive = true;
                xmRequest.ContentType = "text/html; charset=utf-8";
                httpWebResponse = (HttpWebResponse)xmRequest.GetResponse();
                var responseStream = httpWebResponse.GetResponseStream();
                if (responseStream == null) return "";
                Stream st = new GZipStream(responseStream, CompressionMode.Decompress);
                var sr = new StreamReader(st, Encoding.UTF8);
                var html = sr.ReadToEnd();
                sr.Close();
                responseStream.Close();
                httpWebResponse.Close();
                return html;
            }
            catch (Exception)
            {
                if (httpWebResponse != null) httpWebResponse.Close();
                return string.Empty;
            }
        }

        public static double DateTimeToUnixTimestamp(DateTime dateTime)
        {
            return (dateTime - new DateTime(1970, 1, 1).ToLocalTime()).TotalSeconds;
        }
    }
}