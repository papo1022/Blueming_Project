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
    private String chapterTitle;    // CHAPTER.CHAPTER_TITLE representative (JOIN)
    private Integer submissionId;   // ASSIGNMENT_SUBMISSION.SUBMISSION_ID (JOIN)
    private Integer score;          // ASSIGNMENT_SUBMISSION.SCORE (JOIN)
    private String submittedContent; // ASSIGNMENT_SUBMISSION.CONTENT (JOIN)
    private Integer submittedFileId; // ASSIGNMENT_SUBMISSION.FILE_ID (JOIN)
    private String submittedFileName; // ATTACHMENT.ORIGINAL_NAME (JOIN)
    
}
