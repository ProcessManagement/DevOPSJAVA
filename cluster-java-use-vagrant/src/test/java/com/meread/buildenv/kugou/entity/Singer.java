package com.meread.buildenv.kugou.entity;

import org.mongodb.morphia.annotations.Entity;
import org.mongodb.morphia.annotations.Field;
import org.mongodb.morphia.annotations.Index;
import org.mongodb.morphia.annotations.Indexes;

import java.util.Date;

@Entity(value = "singer", noClassnameStored = true)
@Indexes({@Index(value = "name", fields = @Field("name")), @Index(value = "kugouSingerId", fields = @Field("kugouSingerId"))})
public class Singer extends BaseEntity {

    private String name;

    private Integer kugouSingerId;

    private Integer songCount;

    private Integer albumCount;


    private Integer mvCount;


    private String imgUrl;


    private String intro;


    private String type;

    /**
     * 记录添加时间
     */
    private Date addTime;

    /**
     * 记录最近更新时间
     */
    private Date updateTime;

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

    public Integer getKugouSingerId() {
        return kugouSingerId;
    }

    public void setKugouSingerId(Integer kugouSingerId) {
        this.kugouSingerId = kugouSingerId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getSongCount() {
        return songCount;
    }

    public void setSongCount(Integer songCount) {
        this.songCount = songCount;
    }

    public Integer getAlbumCount() {
        return albumCount;
    }

    public void setAlbumCount(Integer albumCount) {
        this.albumCount = albumCount;
    }

    public Integer getMvCount() {
        return mvCount;
    }

    public void setMvCount(Integer mvCount) {
        this.mvCount = mvCount;
    }

    public String getImgUrl() {
        return imgUrl;
    }

    public void setImgUrl(String imgUrl) {
        this.imgUrl = imgUrl;
    }

    public String getIntro() {
        return intro;
    }

    public void setIntro(String intro) {
        this.intro = intro;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }
}