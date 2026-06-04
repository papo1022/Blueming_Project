package com.kh.blueming.member.model.vo;

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
public class Member {

	private int memberId;								//	MEMBER_ID	NUMBER
	private String loginId;								//	LOGIN_ID	VARCHAR2(20 BYTE)
	private String loginPwd;							//	LOGIN_PWD	VARCHAR2(20 BYTE)
	private String name;								//	NAME	VARCHAR2(100 BYTE)
	private String phone;								//	EMAIL	VARCHAR2(100 BYTE)
	private String address;								//	PHONE	VARCHAR2(13 BYTE)
	private String email;								//	ADDRESS	VARCHAR2(255 BYTE)
	private Date hireDate;								//	HIRE_DATE	DATE
	private Date retireDate;							//	RETIRE_DATE	DATE
	private String status;								//	STATUS	VARCHAR2(1 BYTE)
	private String departmentId;						//	DEPARTMENT_ID	VARCHAR2(3 BYTE)
	private String positionId;							//	POSITION_ID	VARCHAR2(3 BYTE)
	private String role;								//	ROLE	VARCHAR2(1 BYTE)
	private Integer leaveStartDate;				//	LEAVE_START_DATE	NUMBER
	private Integer leaveEndDate;					//	LEAVE_END_DATE	NUMBER
	
}
