package com.meread.buildenv.kugou.entity;

import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.Min;
import java.util.Date;
import java.util.List;

public class Album extends BaseEntity {

    /**    */
    @Length(max = 255)
    private String name;


    /**    */
    @Min(1)
    private Long singerId;


    /**    */
    private String intro;


    /**    */
    private Date publishTime;

    /**
     * 记录添加时间
     */
    private Date addTime;

    /**
     * 记录最近更新时间
     */
    private Date updateTime;

    @Length(max = 255)
    private String imgUrl;

    @Min(1)
    private Integer songCount;

    @Min(1)
    private Integer privilege;

    private List<Song> songs;

    private Integer processed;

    private Integer kugouAlbumId;

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

    public Integer getKugouAlbumId() {
        return kugouAlbumId;
    }

    public void setKugouAlbumId(Integer kugouAlbumId) {
        this.kugouAlbumId = kugouAlbumId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Long getSingerId() {
        return singerId;
    }

    public void setSingerId(Long singerId) {
        this.singerId = singerId;
    }

    public String getIntro() {
        return intro;
    }

    public void setIntro(String intro) {
        this.intro = intro;
    }

    public Date getPublishTime() {
        return publishTime;
    }

    public void setPublishTime(Date publishTime) {
        this.publishTime = publishTime;
    }

    public String getImgUrl() {
        return imgUrl;
    }

    public void setImgUrl(String imgUrl) {
        this.imgUrl = imgUrl;
    }

    public Integer getSongCount() {
        return songCount;
    }

    public void setSongCount(Integer songCount) {
        this.songCount = songCount;
    }

    public Integer getPrivilege() {
        return privilege;
    }

    public void setPrivilege(Integer privilege) {
        this.privilege = privilege;
    }

    public Integer getProcessed() {
        return processed;
    }

    public void setProcessed(Integer processed) {
        this.processed = processed;
    }

    public List<Song> getSongs() {
        return songs;
    }

    public void setSongs(List<Song> songs) {
        this.songs = songs;
    }
}