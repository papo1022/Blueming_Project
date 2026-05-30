package com.kh.blueming.chapter.model.vo;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
@ToString
public class Chapter {
	private int chapterId;
	private int courseId;
	private String chapterTitle;
	private int chapterOrder;
	private int videoFileId;
	private Date createDate;
	private Date updatedDate;
}
