using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace XmDown
{
    public class AiMusic
    {
        public static List<SongResult> GetResultsByKey(string key, int page)
        {
            var url = "http://www.118100.cn/v5/action/secweborder/v3/searchall.do?keywords="+key+"&tpye=1&pageCount="+page;
            var html = CommonHelper.GetHtmlContent(url);
            if (string.IsNullOrEmpty(html))
            {
                return null;
            }
            var list = new List<SongResult>();
            var ids = Regex.Matches(html, @"(?<=type=""checkbox"" value="")\d+(?="")");
            foreach (Match id in ids)
            {
                html = CommonHelper.GetHtmlContent("http://www.118100.cn/v5/action/secweborder/v3/songsdata.do?songId="+id.Value+"&it=1");
                var json = (JObject) JsonConvert.DeserializeObject(html);
                try
                {
                    var single = new SongResult
                    {
                        SongId = id.Value,
                        Name = json["songName"].ToString(),
                        Artist = json["singerName"].ToString(),
                        AlbumArtist = json["singerName"].ToString(),
                        Album = json["album"].ToString(),
                        AlbumId = json["singerId"].ToString(),
                        Type = "IMusic",
                        BitRate = "320K",
                        PicUrl = json["singerPic"].ToString().Replace("95x95", "500x500"),
                        LqUrl = Encoding.Default.GetString(Convert.FromBase64String(json["zhengAddr"].ToString().Replace("imusic://",""))).Trim('A','Z'),
                        HqUrl = Encoding.Default.GetString(Convert.FromBase64String(json["ququAddr"].ToString().Replace("imusic://", ""))).Trim('A', 'Z'),
                        ExtHqUrl = Encoding.Default.GetString(Convert.FromBase64String(json["ququAddr"].ToString().Replace("imusic://", ""))).Trim('A', 'Z')
                    };
                    
                    single.LrcUrl = "http://www.118100.cn/v5/action/common/lrcOutput.do?songName=" + single.Name +
                                    "&singerName=" + single.Artist + "&type=lrc";
                    single.CopyUrl = "http://www.musicuu.com/songurl/dx^320^" + single.SongId + ".mp3";
                    list.Add(single);
                }
                catch (Exception exception)
                {
                    Console.Write(exception.ToString());
                }
            }
            return list;
        } 
    }
}