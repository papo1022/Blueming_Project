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
	
	private int courseId;
	private String courseTitle;
	private Date startDate;
	private Date endDate;
	private int dDay;
	private String courseStatus;
	
}
