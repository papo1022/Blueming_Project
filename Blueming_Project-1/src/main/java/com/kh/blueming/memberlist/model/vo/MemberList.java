package com.kh.blueming.memberlist.model.vo;

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
public class MemberList {

	
		private int memberId;		//	MEMBER_ID
		private int deptId;			//	DEPARTMENT_ID
		private int positionId;		//	POSITION_ID
		private String name;		//	NAME
		private Date hireDate;		//	HIRE_DATE
							
		private String loginId;		//	LOGIN_ID
		private String email;		//	EMAIL
		private String phone;		//	PHONE
		private String address;		//	ADDRESS
		private Date retireDate;	//	RETIRE_DATE
		private String status;		//	STATUS
		private String role;		//	ROLE
		
		
		
}
