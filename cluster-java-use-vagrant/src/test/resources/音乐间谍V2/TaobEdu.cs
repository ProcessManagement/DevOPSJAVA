using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace XmDown
{
    public class TaobEdu
    {
        public static List<SongResult> GetBResultById(string id)
        {
            var url = "http://v.xue.taobao.com/learn.htm?courseId=" + id;
            var html = CommonHelper.GetGbkHtml(url);
            if (string.IsNullOrEmpty(html))
            {
                return null;
            }
            var jsonStr = Regex.Match(html, @"(?<=tx_learn_config\s*=\s*)({[\s\S]+?}})(?=;)").Value;
            if (string.IsNullOrEmpty(jsonStr))
            {
                return null;
            }
            var json = (JObject) JsonConvert.DeserializeObject(jsonStr);
            var lessons = json["outline"]["chapters"].First["sections"];
            var album = json["course"]["title"].ToString();
            var artist = json["course"]["shopName"].ToString();
            var list = new List<SongResult>();
            var index = 1;
            foreach (JToken lesson in lessons)
            {
                var song = new SongResult
                {
                    SongId = lesson["resources"].First["link"].ToString(),
                    Name = lesson["resources"].First["title"].ToString(),
                    AlbumId = lesson["courseId"].ToString(),
                    Time = lesson["lessonLengthStr"].ToString(),
                    Album = album,
                    AlbumArtist = artist,
                    Artist = artist,
                    TrackNum = index.ToString(),
                    Type = "TB"
                };
                index++;
                var video =
                    CommonHelper.GetHtmlContent("http://cloud.video.taobao.com/videoapi/info.php?vid=" + song.SongId);
                var matches = Regex.Matches(video,
                    @"(?<=video_url>)([^<]+)(?:</video_url><type>)(\w+)(?:</type>[\s\S]+?<bitrate>)(\d+)(?:</bitrate><length>)(\d+)");
                foreach (Match match in matches)
                {
                    switch (match.Groups[2].Value)
                    {
                        case "hd":
                            song.ExtHqUrl = match.Groups[1].Value + "$" + match.Groups[4].Value;
                            if (string.IsNullOrEmpty(song.BitRate))
                            {
                                song.BitRate = match.Groups[3].Value + "K";
                            }
                            else
                            {
                                if (Convert.ToInt32(song.BitRate.Replace("K", "")) < Convert.ToInt32(match.Groups[3].Value))
                                {
                                    song.BitRate = match.Groups[3].Value + "K";
                                }
                            }
                            break;
                        case "ud":
                            song.CopyUrl = match.Groups[1].Value + "$" + match.Groups[4].Value;
                            if (string.IsNullOrEmpty(song.BitRate))
                            {
                                song.BitRate = match.Groups[3].Value + "K";
                            }
                            break;
                        case "sd":
                            song.HqUrl = match.Groups[1].Value + "$" + match.Groups[4].Value;
                            if (string.IsNullOrEmpty(song.BitRate))
                            {
                                song.BitRate = match.Groups[3].Value + "K";
                            }
                            else
                            {
                                if (Convert.ToInt32(song.BitRate.Replace("K","")) < Convert.ToInt32(match.Groups[3].Value))
                                {
                                    song.BitRate = match.Groups[3].Value + "K";
                                }
                            }
                            break;
                        case "ld":
                            song.LqUrl = match.Groups[1].Value + "$" + match.Groups[4].Value;
                            if (string.IsNullOrEmpty(song.BitRate))
                            {
                                song.BitRate = match.Groups[3].Value + "K";
                            }
                            break;
                    }
                }
                list.Add(song);
            }
            return list;
        }
    }
}