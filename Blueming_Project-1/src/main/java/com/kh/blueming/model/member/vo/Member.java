package com.kh.blueming.model.member.vo;

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
public class Member {
	
		private int memberId; 					//	MEMBER_ID	NUMBER
		private String loginId; 				//	LOGIN_ID	VARCHAR2(20 BYTE)
		private String loginPwd;				//	LOGIN_PWD	VARCHAR2(20 BYTE)
		private String name;					//	NAME	VARCHAR2(100 BYTE)
		private String email;					//	EMAIL	VARCHAR2(100 BYTE)
		private String phone;					//	PHONE	VARCHAR2(13 BYTE)
		private String address;					//	ADDRESS	VARCHAR2(255 BYTE)
		private Date hireDate;					//	HIRE_DATE	DATE
		private Date retireDate;				//	RETIRE_DATE	DATE
		private String status;					//	STATUS	VARCHAR2(1 BYTE)
		private String departmentId;			//	DEPARTMENT_ID	VARCHAR2(3 BYTE)
		private String postionId;				//	POSITION_ID	VARCHAR2(3 BYTE)
		private String role;					//	ROLE	VARCHAR2(1 BYTE)
		private String passwordResetDate;		//	PWD_RESET_DATE	DATE

}
