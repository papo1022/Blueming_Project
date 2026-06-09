package com.kh.blueming.assignment.model.vo;

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
public class AssignmentSubmission {
	private int submissionId;
	private int assignmentId;
	private int memberId;
	private String content;
	private int fileId;
	private int score;
	private Date submitted_Date;
}
