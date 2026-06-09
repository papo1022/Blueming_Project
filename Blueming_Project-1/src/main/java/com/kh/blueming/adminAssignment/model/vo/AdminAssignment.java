package com.kh.blueming.adminAssignment.model.vo;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;


@NoArgsConstructor // 기본생성자를 자동완성 해주는 어노테이션
@AllArgsConstructor // 모든 필드에 대한 매개변수 생성자를 자동완성 해주는 어노테이션
@Setter // setter 메소드들을 자동완성 해주는 어노테이션
@Getter // getter 메소드들을 자동완성 해주는 어노테이션
@ToString // toString 메소드를 오버라이딩 해주는 어노테이션
public class AdminAssignment {
	
    private int assignmentId;
    private int courseId;
    private String assignmentTitle;
    private String description;
    private Date startDate;
    private Date dueDate;
    private int maxScore;

    private Integer submissionId;
    private Integer score;
    private String submittedContent;
    private Integer submittedFileId;
    private String submittedFileName;

    private int memberId;
    private String loginId;
    private String name;
    private String departmentId;
    private String positionId;
    
    private String fileId;
    private String originalName;
    private String changedName;
    private String filePath;

}
