package com.meread.buildenv.test.entity;


import org.mongodb.morphia.annotations.Embedded;

import java.io.*;

/**
 * Created with IntelliJ IDEA.
 * Date: 14-5-15
 * Time: 下午5:03
 */
@Embedded
public class Book  implements Serializable {
    private int gid;
    private int nid;
    private int lastSort;//最后一章
    private int sequence;//书签
    private int chapterCount;//章节总数
    private long timestamp;//每书的最后更新时间
    //内部存储使用，非数据存储 0:已存储 ;1:新增 ;2:修改;3:删除
    private int status = 0;

    public int getGid() {
        return gid;
    }

    public void setGid(int gid) {
        this.gid = gid;
    }

    public int getNid() {
        return nid;
    }

    public void setNid(int nid) {
        this.nid = nid;
    }

    public int getSequence() {
        return sequence;
    }

    public void setSequence(int sequence) {
        this.sequence = sequence;
    }

    public long getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(long timestamp) {
        this.timestamp = timestamp;
    }

    public int getLastSort() {
        return lastSort;
    }

    public void setLastSort(int lastSort) {
        this.lastSort = lastSort;
    }

    public int getChapterCount() {
        return chapterCount;
    }

    public void setChapterCount(int chapterCount) {
        this.chapterCount = chapterCount;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Book{" +
                "gid=" + gid +
                ", nid=" + nid +
                ", lastSort=" + lastSort +
                ", sequence=" + sequence +
                ", chapterCount=" + chapterCount +
                ", timestamp=" + timestamp +
                ", status=" + status +
                '}';
    }
    
    public Object deepClone() throws Exception
    {
        // 序列化
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        ObjectOutputStream oos = new ObjectOutputStream(bos);

        oos.writeObject(this);

        // 反序列化
        ByteArrayInputStream bis = new ByteArrayInputStream(bos.toByteArray());
        ObjectInputStream ois = new ObjectInputStream(bis);

        return ois.readObject();
    }

    @Override
    public boolean equals(Object obj) {
        return ((Integer)gid).equals(obj);
    }

    @Override
    public int hashCode() {
        return gid;
    }
}
