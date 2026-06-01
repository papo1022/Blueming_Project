package com.kh.blueming.notice.model.vo;

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
public class Notice {
	private int noticeId;
	private String noticeTitle;
	private String content;
	private int memberId;
	private int count;
	private Date createdDate;
	private Date updatedDate;
	private int fileId;
	private String status;
	
	private String name;
}
