package com.kh.blueming.memberlist.model.vo;

import java.sql.Date;

import org.springframework.format.annotation.DateTimeFormat;

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

    private int memberId;        // MEMBER_ID (숫자 PK형식 유지)
    

    private String deptId;       // DEPARTMENT_ID
    private String positionId;   // POSITION_ID
    
    private String name;         // NAME
    private Date hireDate;       // HIRE_DATE
                        
    private String loginId;      // LOGIN_ID
    private String email;        // EMAIL
    private String phone;        // PHONE
    private String address;      // ADDRESS
    private Date retireDate;     // RETIRE_DATE
    
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private String status;       // STATUS
    
    private String role;         // ROLE
    
    private String deptName;	// DEPARTMENT_NAME
    private String positionName; // POSITION_NAME
    
 
    private Long leaveStartDate; //LEAVE_START_DATE
    private Long leaveEndDate; // LEAVE_END_DATE

    private String loginPwd;
    
}