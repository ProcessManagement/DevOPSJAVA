using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace XmDown
{
    public class AudioJungle
    {
        //http://audiojungle.net/search?term=Tears&page=2
        public static List<SongResult> GetResultsByKey(string key,int page)
        {
            var url = "http://audiojungle.net/search?term=" + key + "&page=" + page;
            var html = CommonHelper.GetHtmlContent(url);
            if (string.IsNullOrEmpty(html))
            {
                return null;
            }
            var matches = Regex.Matches(html,
                @"(?<=<li\s*data-item-id="")(\d+)(?:[\s\S]+?<img[\s\S]+?src="")([^""]+)(?:""[\s\S]+?tsunami-item__title"">\s*<a href=""[^""]+"">)([^<]+)(?:</a>\s* </h3>[\s\S]+?author-link"">)([^<]+)(?:</a>[\s\S]+?data-file="")([^""]+)(?="")");
            var list = new List<SongResult>();
            foreach (Match match in matches)
            {
                var song = new SongResult()
                {
                    SongId = match.Groups[1].Value,
                    PicUrl = match.Groups[2].Value,
                    Name = match.Groups[3].Value,
                    Artist = match.Groups[4].Value,
                    AlbumArtist = match.Groups[4].Value,
                    LqUrl = match.Groups[5].Value,
                    ExtHqUrl = match.Groups[5].Value,
                    HqUrl = match.Groups[5].Value,
                    Type = "AJ",
                    AlbumId = "5211314"
                };
                list.Add(song);
            }
            return list;
        } 
    }
}