using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace XmDown
{
    public class BaiduMusic
    {
        /// <summary>
        ///  根据关键词以及页码来获取百度搜索结果
        /// </summary>
        /// <param name="key">关键词</param>
        /// <param name="page">页码</param>
        /// <param name="type"></param>
        /// <returns>歌曲结果</returns>
        public static List<SongResult> GetSearchResult(string key, int page, int type)
        {
            page = (page-1)*20;
            var url = "http://music.baidu.com/search/song?s=1&key=" + key + "&start=" + page + "&size=20";
            switch (type)
            {
                case 5:
                    url = "http://music.baidu.com/album/"+ key;
                    break;
                case 6:
                    url = "http://music.baidu.com/songlist/" + key;
                    break;
                case 7:
                    url = "http://music.baidu.com/data/user/getsongs?start=" + (page - 1)*25 + "&ting_uid=" + key +
                          "&order=hot&hotmax=0";
                    break;
                case 8:
                    return GetResultsByIds(key);
            }
            var html = CommonHelper.GetHtmlContent(url);
            html = html.Replace("&quot;", "\"");
            return string.IsNullOrEmpty(html) ? null : GetListByHtml(html);
        }

        private static List<SongResult> GetListByHtml(string html)
        {
            var ids1 = "";
            var ids2 = "";
            var matches = Regex.Matches(html, @"(?<=data-\w+='{\s*""id"":\s*"")\d+");  //获取SongId
            try
            {
                if (matches.Count == 0)
                {
                    matches = Regex.Matches(html, @"(?<=title=""播放[^""]*""\s*target=""_blank""\s*href=""[^""]+/song/)(\d+)");
                }
                if (matches.Count > 10)
                {
                    for (var i = 0; i < 10; i++)
                    {
                        ids1 += (matches[i].Value + ",");
                    }
                    ids1 = ids1.TrimEnd(',');
                    for (var i = 10; i < matches.Count; i++)
                    {
                        ids2 += (matches[i].Value + ",");
                    }
                    ids2 = ids2.TrimEnd(',');
                    var list1 = GetResultsByIds(ids1);
                    var list2 = GetResultsByIds(ids2);
                    var list = new List<SongResult>();
                    list.AddRange(list1);
                    list.AddRange(list2);
                    return list;
                }
                for (var i = 0; i < matches.Count; i++)
                {
                    ids2 += (matches[i].Value + ",");
                }
                ids2 = ids2.TrimEnd(',');
            }
            catch (Exception)
            {
                return null;
            }
            return GetResultsByIds(ids2);
        }
        /// <summary>
        /// 根据SongIds获取歌曲信息
        /// 因为百度FM的解析一次只允许解析10个结果
        /// 当解析20个结果时要分批次
        /// </summary>
        /// <param name="ids">歌曲Id连接成的字符串，使用逗号隔开</param>
        /// <returns></returns>
        private static List<SongResult> GetResultsByIds(string ids)
        {
            var first = CommonHelper.GetHtmlContent("http://music.baidu.com/data/music/fmlink?songIds=" + ids + "&type=mp3&rate=320");
            if (string.IsNullOrEmpty(first))
            {
                return null;
            }
            var jobject = (JObject)JsonConvert.DeserializeObject(first);
            if (jobject.Count != 2)
            {
                return null;
            }
            if ((int)jobject["errorCode"] != 22000) return null;
            var results = jobject["data"]["songList"];
            if (!results.HasValues) return null;
            var list = new List<SongResult>();
            foreach (var result in results)
            {
                try
                {
                    var song = new SongResult
                    {
                        SongId =result["songId"].ToString(),
                        Name = result["songName"].ToString(),
                        Album = result["albumName"].ToString(),
                        AlbumId = result["albumId"].ToString(),
                        AlbumArtist = result["artistName"].ToString(),
                        Artist = result["artistName"].ToString(),
                        PicUrl = result["songPicRadio"].ToString(),
                        LrcUrl = "http://fm.baidu.com" + result["lrcLink"],
                        Time = CommonHelper.NumToTime(result["time"].ToString()),
                        BitRate = result["rate"] + "kbps",
                        HqUrl = result["songLink"].ToString(),
                        LqUrl = result["songLink"].ToString(),
                        Size = Math.Round((Convert.ToDouble(result["size"]) / 1024 / 1024), 2) + "MB",
                        Type = "Baidu"
                    };
                    song.CopyUrl = "http://www.musicuu.com/songurl/bd^320^" + song.SongId + ".mp3";
                    list.Add(song);
                }
                catch (Exception)
                {
                    Console.Write("");
                }
            }
            var html = CommonHelper.GetHtmlContent("http://music.baidu.com/data/music/fmlink?songIds=" + ids + "&type=flac");
            if (string.IsNullOrEmpty(html))
            {
                return list;
            }
            var flac = (JObject)JsonConvert.DeserializeObject(html);
            if (flac.Count != 2)
            {
                return list;
            }
            if ((int)flac["errorCode"] != 22000) return null;
            var wusuns = flac["data"]["songList"];
            if (!results.HasValues) return list;
            var i = 0;
            foreach (var wusun in wusuns)
            {
                if (string.IsNullOrEmpty(wusun["songLink"].ToString()))
                {
                    i++;
                    continue;
                }
                list[i].ExtHqUrl = wusun["songLink"].ToString();
                list[i].BitRate = wusun["rate"] + "kbps";
                i++;
            }
            return list;
        }

        #region 获取无损地址--已移除

        ///// <summary>
        ///// 根据歌曲Id获取无损音质下载地址
        ///// </summary>
        ///// <param name="songId">歌曲Id</param>
        ///// <returns>无损音质地址</returns>
        //public static string GetExtUrlById(string songId)
        //{
        //    var html =
        //        CommonHelper.GetHtmlContent("http://music.baidu.com/data/music/fmlink?songIds=" + songId + "&type=flac");
        //    var match = Regex.Match(html, @"(?<=songLink"":"")[\s\S]+?(?="",)");
        //    return match.Value.Replace(@"\","");
        //}

        #endregion
    }
}