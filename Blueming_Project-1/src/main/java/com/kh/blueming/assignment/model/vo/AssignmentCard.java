package com.kh.blueming.assignment.model.vo;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

// 사원 대시보드에서 카드에 띄울 용도로 사용할 VO 클래스
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class AssignmentCard {
    private int assignmentId;
    private String assignmentTitle;
    private Date dueDate;
    private String courseTitle;
    private String submitStatus; // SUBMITTED(제출) / NOT_SUBMITTED(미제출)
}
