package com.kh.blueming.course.model.vo;

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
public class CourseCard {
    private int courseId;
    private String courseTitle;
    private Date endDate;
    private int dday;
    private int progressRate;
    private String courseStatus; // IN_PROGRESS(수강중) / DONE(수강완료) / CLOSED(마감)
}
