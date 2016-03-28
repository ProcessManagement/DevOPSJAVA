package com.meread.buildenv.test.entity;


import org.mongodb.morphia.annotations.Embedded;
import org.mongodb.morphia.annotations.Entity;
import org.mongodb.morphia.annotations.Id;

import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * Date: 14-5-15
 * Time: 下午2:11
 */
@Entity(noClassnameStored=true)
public class BookShelf{
    @Id
    private String id;
    private int size;
    private long timestamp;//对比用时间戳 
    @Embedded
    List<Book> books;
    
    private String info = "";
    
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public int getSize() {
        return size;
    }

    public void setSize(int size) {
        this.size = size;
    }

    public List<Book> getBooks() {
        return books;
    }

    public void setBooks(List<Book> books) {
        this.books = books;
    }

    public long getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(long timestamp) {
		this.timestamp = timestamp;
	}
	
	public String getInfo() {
		return info;
	}

	public void setInfo(String info) {
		this.info = info;
	}

	@Override
	public String toString() {
		return "BookShelf [id=" + id + ", size=" + size + ", timestamp="
				+ timestamp + ", books=" + books + ", info=" + info + "]";
	}

	
	

}
