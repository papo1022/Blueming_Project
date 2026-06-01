package com.kh.blueming.member.model.vo;

import java.sql.Date;

public class Member {

	// 필드부
	private int memberId;			//	MEMBER_ID		NUMBER
	private String loginId;			//	LOGIN_ID		VARCHAR2(20)
	private String loginPwd;		//	LOGIN_PWD		VARCHAR2(20)
	private String name;			//	NAME			VARCHAR2(100)
	private String email;			//	EMAIL			VARCHAR2(100)
	private String phone;			//	PHONE			VARCHAR2(13)
	private String address;			//	ADDRESS			VARCHAR2(255)
	private Date hireDate;			//	HIRE_DATE		DATE
	private Date retireDate;		//	RETIRE_DATE		DATE
	private String status;			//	STATUS			VARCHAR2(1)
	private String departmentId;	//	DEPARTMENT_ID	VARCHAR2(3)
	private String positionId;		//	POSITION_ID		VARCHAR2(3)
	private String role;			//	ROLE			VARCHAR2(1)
	private Date pwdResetDate;		//	PWD_RESET_DATE	DATE
	
	// 메소드부
	// getter, setter 메소드
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
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
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
	public Date getPwdResetDate() {
		return pwdResetDate;
	}
	public void setPwdResetDate(Date pwdResetDate) {
		this.pwdResetDate = pwdResetDate;
	}
	
	@Override
	public String toString() {
		return "Member [memberId=" + memberId + ", loginId=" + loginId + ", loginPwd=" + loginPwd + ", name=" + name
				+ ", email=" + email + ", phone=" + phone + ", address=" + address + ", hireDate=" + hireDate
				+ ", retireDate=" + retireDate + ", status=" + status + ", departmentId=" + departmentId
				+ ", positionId=" + positionId + ", role=" + role + ", pwdResetDate=" + pwdResetDate + "]";
	}
	
}
