package com.kh.blueming.course.model.vo;

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
public class Course {
    private int courseId; // 강의 ID
    private String courseTitle; // 강의 제목
    private String description; // 강의 설명
    private int memberId; // 강의 관리자(멤버 ID)
    private String status; // 강의 상태(예정W, 진행중Y, 종료N)
    private Date startDate; // 강의 시작일
    private Date endDate; // 강의 종료일
    private int totalHours; // 총 강의 시간
    private Date createDate; // 강의 생성일
    private Date updatedDate; // 강의 수정일
}
