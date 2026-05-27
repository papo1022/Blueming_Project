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
private int noticeId;					//	NOTICE_ID	NUMBER
private String noticeTitle;				//	NOTICE_TITLE	VARCHAR2(50 BYTE)
private String content;					//	CONTENT	VARCHAR2(2000 BYTE)
private int memberId;					//	MEMBER_ID	NUMBER
private int count; 						//	COUNT	NUMBER
private Date createDate;				//	CREATED_DATE	DATE
private Date updateDate;				//	UPDATED_DATE	DATE
private int fileId;						//	FILE_ID	NUMBER
private String status;					//	STATUS	VARCHAR2(1 BYTE)

}
