using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace XmDown
{
    public class Mp3PmMusic
    {
        public static List<SongResult> GetResultsByKey(string key, int page)
        {
            key = Regex.Replace(key, @"[\W]+", "+");
            var url = "http://mp3pm.com/s/f/" + key + "/page/" + page + "/";
            var html = CommonHelper.GetHtmlContent(url);
            if (string.IsNullOrEmpty(html))
            {
                return null;
            }
            var matches = Regex.Matches(html,
                @"(?<=data-sound-author"">)([^<]+?)(?:<[\s\S]+?data-sound-title"">)([^<]+?)(?:<[\s\S]+?data-sound-id="")(\d+)(?:""\s*data-sound-url="")([^""]+?)(?="")");
            var list = new List<SongResult>();
            foreach (Match match in matches)
            {
                var song = new SongResult()
                {
                    SongId = match.Groups[3].Value,
                    Name = match.Groups[2].Value,
                    Artist = match.Groups[1].Value,
                    AlbumArtist = match.Groups[1].Value,
                    LqUrl = match.Groups[4].Value,
                    ExtHqUrl = match.Groups[4].Value,
                    HqUrl = match.Groups[4].Value,
                    Type = "MP3PM",
                    AlbumId = "5211314"
                };
                list.Add(song);
            }
            return list;
        }
    }
}