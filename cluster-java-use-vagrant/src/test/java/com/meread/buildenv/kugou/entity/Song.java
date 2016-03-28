package com.meread.buildenv.kugou.entity;

import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.Min;
import java.util.Date;
import java.util.List;

public class Song extends BaseEntity {

    /**    */
    @Length(max = 255)
    private String fileName;

    private String highLightName;

    /**
     * 记录添加时间
     */
    private Date addTime;

    /**
     * 记录最近更新时间
     */
    private Date updateTime;

    private String lrc;

    private List<Lrc> lrcs;

    /**    */
    @Min(1)
    private Integer fileSize;


    /**    */
    @Min(1)
    private Integer highSize;


    /**    */
    @Min(1)
    private Integer hqSize;


    /**    */
    @Length(max = 10)
    private Integer processed;


    /**    */
    @Length(max = 255)
    private String hash;


    /**    */
    @Length(max = 255)
    private String hashHigh;


    /**    */
    @Length(max = 20)
    private String hashSuper;


    /**    */
    @Min(1)
    private Integer bitRate;


    /**    */
    @Length(max = 10)
    private String extName;


    /**    */
    @Min(1)
    private Integer duration;


    /**    */
    private Long singerId;

    /**    */
    private Integer kugouSingerId;

    /**    */
    @Length(max = 255)
    private String singerName;

    /**    */
    private Integer kugouAlbumId;

    /**    */
    private Long albumId;


    /**    */
    @Length(max = 255)
    private String downUrl;

    @Length(max = 255)
    private String imgUrl;

    public Date getAddTime() {
        return addTime;
    }

    public void setAddTime(Date addTime) {
        this.addTime = addTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    public String getImgUrl() {
        return imgUrl;
    }

    public void setImgUrl(String imgUrl) {
        this.imgUrl = imgUrl;
    }

    private String albumName;

    public String getAlbumName() {
        return albumName;
    }

    public void setAlbumName(String albumName) {
        this.albumName = albumName;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public Integer getFileSize() {
        return fileSize;
    }

    public void setFileSize(Integer fileSize) {
        this.fileSize = fileSize;
    }

    public Integer getHighSize() {
        return highSize;
    }

    public void setHighSize(Integer highSize) {
        this.highSize = highSize;
    }

    public Integer getHqSize() {
        return hqSize;
    }

    public void setHqSize(Integer hqSize) {
        this.hqSize = hqSize;
    }

    public Integer getProcessed() {
        return processed;
    }

    public void setProcessed(Integer processed) {
        this.processed = processed;
    }

    public String getHash() {
        return hash;
    }

    public void setHash(String hash) {
        this.hash = hash;
    }

    public String getHashHigh() {
        return hashHigh;
    }

    public void setHashHigh(String hashHigh) {
        this.hashHigh = hashHigh;
    }

    public String getHashSuper() {
        return hashSuper;
    }

    public void setHashSuper(String hashSuper) {
        this.hashSuper = hashSuper;
    }

    public Integer getBitRate() {
        return bitRate;
    }

    public void setBitRate(Integer bitRate) {
        this.bitRate = bitRate;
    }

    public String getExtName() {
        return extName;
    }

    public void setExtName(String extName) {
        this.extName = extName;
    }

    public Integer getDuration() {
        return duration;
    }

    public void setDuration(Integer duration) {
        this.duration = duration;
    }

    public Long getSingerId() {
        return singerId;
    }

    public void setSingerId(Long singerId) {
        this.singerId = singerId;
    }

    public String getSingerName() {
        return singerName;
    }

    public void setSingerName(String singerName) {
        this.singerName = singerName;
    }

    public Long getAlbumId() {
        return albumId;
    }

    public void setAlbumId(Long albumId) {
        this.albumId = albumId;
    }

    public String getLrc() {
        return lrc;
    }

    public void setLrc(String lrc) {
        this.lrc = lrc;
    }

    public String getDownUrl() {
        return downUrl;
    }

    public void setDownUrl(String downUrl) {
        this.downUrl = downUrl;
    }

    public Integer getKugouSingerId() {
        return kugouSingerId;
    }

    public void setKugouSingerId(Integer kugouSingerId) {
        this.kugouSingerId = kugouSingerId;
    }

    public Integer getKugouAlbumId() {
        return kugouAlbumId;
    }

    public void setKugouAlbumId(Integer kugouAlbumId) {
        this.kugouAlbumId = kugouAlbumId;
    }

    public List<Lrc> getLrcs() {
        return lrcs;
    }

    public void setLrcs(List<Lrc> lrcs) {
        this.lrcs = lrcs;
    }

    public String getHighLightName() {
        return highLightName;
    }

    public void setHighLightName(String highLightName) {
        this.highLightName = highLightName;
    }
}