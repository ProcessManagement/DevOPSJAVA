using System.Collections.Generic;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace XmDown
{
    public class FiveSing
    {
        public static List<SongResult> GetSearchResult(string key,int page)
        {
            var url = "http://search.5sing.kugou.com/home/json?keyword=" + key + "&type=0&filter=0&sort=0&page=" + page + "&callback=succes";
            var html = CommonHelper.GetHtmlContent(url);
            if (string.IsNullOrEmpty(html))
            {
                return null;
            }
            var json = (JObject) JsonConvert.DeserializeObject(html);
            if (json["pageInfo"]["totalCount"].ToString() == "0")
            {
                return null;
            }
            var js = json["list"];
            var list = new List<SongResult>();
            foreach (JToken jToken in js)
            {
                var song = new SongResult
                {
                    SongId = jToken["songId"].ToString(),
                    Name = jToken["originalName"].ToString(),
                    AlbumArtist = jToken["originSinger"].ToString(),
                    Artist = jToken["originSinger"].ToString(),
                    Type = "fs"
                };
                song.CopyUrl = song.HqUrl = song.LqUrl = song.ExtHqUrl = "http://musicuu.com/songurl/fs^"+jToken["typeEname"] +"^"+song.SongId+".mp3";
                song.PicUrl = "http://musicuu.com/songurl/fs^" + jToken["typeEname"] + "^" + song.SongId + ".jpg";
                list.Add(song);
            }
            return list;
        }

    }
}