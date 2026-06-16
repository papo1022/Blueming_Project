package com.kh.blueming.admindashboard.model.vo;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class AdminDashboardCourse {
	
	private int noticeId;					//	NOTICE_ID	NUMBER
	private String noticeTitle;			//	NOTICE_TITLE	VARCHAR2(50 BYTE)
	private String content;				//	CONTENT	VARCHAR2(2000 BYTE)
	private int memberId;				//	MEMBER_ID	NUMBER
	private int count;					//	COUNT	NUMBER
	private Date createdDate;			//	CREATED_DATE	DATE
	private Date updatedDate;			//	UPDATED_DATE	DATE
	private int fileIdNumber;			//	FILE_ID	NUMBER
	private String Status; 				//	STATUS	VARCHAR2(1 BYTE)

	private String courseStatus;
	private int DDay;
	
	private int courseId;
    private String courseTitle;

    private Date startDate;
    private Date endDate;
	
}

