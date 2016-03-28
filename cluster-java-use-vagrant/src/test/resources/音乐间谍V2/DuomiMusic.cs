using System;
using System.Collections.Generic;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace XmDown
{
    public class DuomiMusic
    {
        public static List<SongResult> GetResultsByKey(string key, int page)
        {
            var url = "http://v5.pc.duomi.com/search-ajaxsearch-searchall?kw=" + key + "&pi=" + page +"&pz=20";
            var html = CommonHelper.GetHtmlContent(url);
            if (string.IsNullOrEmpty(html))
            {
                return null;
            }
            var json = (JObject)JsonConvert.DeserializeObject(html.Trim('(', ')'));
            if (Convert.ToInt32(json["total_tracks"]) <= 0)
            {
                return null;
            }
            var list = new List<SongResult>();
            var songs = json["tracks"];
            foreach (JToken song in songs)
            {
                var single = new SongResult()
                {
                    SongId = song["id"].ToString(),
                    Name = song["title"].ToString(),
                    Artist = song["artists"][0]["name"].ToString(),
                    AlbumArtist = song["artists"][0]["name"].ToString(),
                    Album = song["album"]["name"].ToString(),
                    AlbumId = song["album"]["id"].ToString(),
                    PicUrl = "http://photo.cdn.duomi.com/imageproxy2/dimgm/scaleImage?url=http://img.kxting.cn/" + song["album"]["cover"] + "&w=1500&h=1500&s=100&c=0&o=0&m=",
                    BitRate = song["medias"][0]["bitrate"] +"K"
                };
                single.Type = "Duomi";
                single.CopyUrl = "http://www.musicuu.com/songurl/dm^320^" + single.SongId + ".mp3";
                list.Add(single);
            }
            return list;
        }
    }
}