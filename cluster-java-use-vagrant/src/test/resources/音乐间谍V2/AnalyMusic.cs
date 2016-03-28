using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace XmDown
{
    public static class AnalyMusic
    {
        public static SongResult GetEchoUrl(string id)
        {
            var url = "http://echosystem.kibey.com/sound/info?android_v=66&app_channel=qvideo&sound_id=" + id;
            var html = CommonHelper.GetHtmlContent(url);
            if (string.IsNullOrEmpty(html))
            {
               return null; 
            }
            var json = (JObject) JsonConvert.DeserializeObject(html);
            if (json["message"].ToString() != "success")
            {
                return null;
            }
            var song = new SongResult()
            {
                SongId = json["result"]["id"].ToString(),
                Name = json["result"]["name"].ToString(),
                CopyUrl = json["result"]["source"].ToString(),
                LqUrl = json["result"]["source"].ToString(),
                HqUrl = json["result"]["source"].ToString(),
                ExtHqUrl = json["result"]["source"].ToString(),
                PicUrl = json["result"]["pic"].ToString(),
                Type = "echo"
            };
            return song;
        }
    }
}