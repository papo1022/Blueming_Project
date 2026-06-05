package com.kh.blueming.notice.model.vo;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;



@NoArgsConstructor // 기본생성자를 자동완성 해주는 어노테이션
@AllArgsConstructor // 모든 필드에 대한 매개변수 생성자를 자동완성 해주는 어노테이션
@Setter // setter 메소드들을 자동완성 해주는 어노테이션
@Getter // getter 메소드들을 자동완성 해주는 어노테이션
@ToString // toString 메소드를 오버라이딩 해주는 어노테이션
public class Notice {
	
	private int noticeId;					//	NOTICE_ID	NUMBER
	private String noticeTitle;			//	NOTICE_TITLE	VARCHAR2(50 BYTE)
	private String content;				//	CONTENT	VARCHAR2(2000 BYTE)
	private int memberId;				//	MEMBER_ID	NUMBER
	private int count;					//	COUNT	NUMBER
	private Date createdDate;			//	CREATED_DATE	DATE
	private Date updatedDate;			//	UPDATED_DATE	DATE
	private int fileIdNumber;			//	FILE_ID	NUMBER
	private String Status; 				//	STATUS	VARCHAR2(1 BYTE)
	

}