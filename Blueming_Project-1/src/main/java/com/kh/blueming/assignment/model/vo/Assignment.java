package com.kh.blueming.assignment.model.vo;

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
public class Assignment {

    private int assignmentId;       // ASSIGNMENT_ID
    private int courseId;           // COURSE_ID
    private String assignmentTitle; // ASSIGNMENT_TITLE
    private String description;     // DESCRIPTION
    private Date startDate;         // START_DATE
    private Date dueDate;           // DUE_DATE
    private int maxScore;           // MAX_SCORE

    private String courseTitle;     // COURSE.COURSE_TITLE (JOIN)
    private Integer score;          // ASSIGNMENT_SUBMISSION.SCORE (JOIN)
    
}
