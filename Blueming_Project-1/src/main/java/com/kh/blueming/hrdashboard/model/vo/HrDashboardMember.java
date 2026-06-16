package com.kh.blueming.hrdashboard.model.vo;

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
public class HrDashboardMember {

    private int memberId;
    private String name;
    private String departmentName;
    private String positionName;
    private String email;
    private double progressRate;
    
	private int noticeId;					//	NOTICE_ID	NUMBER
	private String noticeTitle;			//	NOTICE_TITLE	VARCHAR2(50 BYTE)
	private String content;				//	CONTENT	VARCHAR2(2000 BYTE)
	
	private int count;					//	COUNT	NUMBER
	private Date createdDate;			//	CREATED_DATE	DATE
	private Date updatedDate;			//	UPDATED_DATE	DATE
	private int fileIdNumber;			//	FILE_ID	NUMBER
	private String Status; 				//	STATUS	VARCHAR2(1 BYTE)

}