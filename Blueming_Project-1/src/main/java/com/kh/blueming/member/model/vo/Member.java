package com.kh.blueming.member.model.vo;

import java.sql.Date;



public class Member {

	private int memberId;				//	MEMBER_ID	NUMBER
	private String loginId;				//	LOGIN_ID	VARCHAR2(20 BYTE)
	private String loginPwd;			//	LOGIN_PWD	VARCHAR2(20 BYTE)
	private String name;				//	NAME	VARCHAR2(100 BYTE)
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
	
	public Member() { }

	@Override
	public String toString() {
		return "Member [memberId=" + memberId + ", loginId=" + loginId + ", loginPwd=" + loginPwd + ", name=" + name
				+ ", phone=" + phone + ", address=" + address + ", email=" + email + ", hireDate=" + hireDate
				+ ", retireDate=" + retireDate + ", status=" + status + ", departmentId=" + departmentId
				+ ", positionId=" + positionId + ", role=" + role + ", leaveStartDate=" + leaveStartDate
				+ ", leaveEndDate=" + leaveEndDate + "]";
	}

	public Member(int memberId, String loginId, String loginPwd, String name, String phone, String address,
			String email, Date hireDate, Date retireDate, String status, String departmentId, String positionId,
			String role, Integer leaveStartDate, Integer leaveEndDate) {
		super();
		this.memberId = memberId;
		this.loginId = loginId;
		this.loginPwd = loginPwd;
		this.name = name;
		this.phone = phone;
		this.address = address;
		this.email = email;
		this.hireDate = hireDate;
		this.retireDate = retireDate;
		this.status = status;
		this.departmentId = departmentId;
		this.positionId = positionId;
		this.role = role;
		this.leaveStartDate = leaveStartDate;
		this.leaveEndDate = leaveEndDate;
	}

	public int getMemberId() {
		return memberId;
	}

	public void setMemberId(int memberId) {
		this.memberId = memberId;
	}

	public String getLoginId() {
		return loginId;
	}

	public void setLoginId(String loginId) {
		this.loginId = loginId;
	}

	public String getLoginPwd() {
		return loginPwd;
	}

	public void setLoginPwd(String loginPwd) {
		this.loginPwd = loginPwd;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public Date getHireDate() {
		return hireDate;
	}

	public void setHireDate(Date hireDate) {
		this.hireDate = hireDate;
	}

	public Date getRetireDate() {
		return retireDate;
	}

	public void setRetireDate(Date retireDate) {
		this.retireDate = retireDate;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getDepartmentId() {
		return departmentId;
	}

	public void setDepartmentId(String departmentId) {
		this.departmentId = departmentId;
	}

	public String getPositionId() {
		return positionId;
	}

	public void setPositionId(String positionId) {
		this.positionId = positionId;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public Integer getLeaveStartDate() {
		return leaveStartDate;
	}

	public void setLeaveStartDate(Integer leaveStartDate) {
		this.leaveStartDate = leaveStartDate;
	}

	public Integer getLeaveEndDate() {
		return leaveEndDate;
	}

	public void setLeaveEndDate(Integer leaveEndDate) {
		this.leaveEndDate = leaveEndDate;
	}
	
	
}
