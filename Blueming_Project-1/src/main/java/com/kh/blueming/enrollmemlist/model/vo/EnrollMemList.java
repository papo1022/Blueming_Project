package com.kh.blueming.enrollmemlist.model.vo;

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
public class EnrollMemList {
	
				private int enrollmentId;		//	ENROLLMENT_ID
				private int memberId;		//	MEMBER_ID
				private int courseId;		//	COURSE_ID
				private String status;		//	STATUS
				private Date startDate;		//	START_DATE
				private Date completedDate;		//	COMPLETED_DATE
	
				
	

}
