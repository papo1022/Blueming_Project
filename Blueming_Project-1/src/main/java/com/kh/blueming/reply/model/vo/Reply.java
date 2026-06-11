package com.kh.blueming.reply.model.vo;

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
public class Reply {

	private int replyId;          // REPLY_ID (PK)
    private int chapterId;        // CHAPTER_ID (FK)
    private int memberId;         // MEMBER_ID (FK)
    private Integer parentReplyId; // PARENT_REPLY_ID (Null 허용이므로 기본형 int 대신 참조형 Integer 사용)
    private Integer fileId;        // FILE_ID (Null 허용)
    private String content;       // CONTENT
    private String isPrivate;     // IS_PRIVATE ('Y' or 'N')
    private String createdDate;   // CREATED_DATE (포맷팅 편의상 String 추천)
    private String updatedDate;   // UPDATED_DATE
    private String status;        // STATUS ('Y' or 'N')
    
    // 🌟 [화면 출력용 추가 필드] SQL 조인(JOIN)으로 가져올 작성자 정보
    private String name;          // 작성자 이름 (MEMBER 테이블 조인)
    private String deptName;      // 작성자 부서명 (DEPARTMENT 테이블 조인)
    private String originalName;    // 첨부파일 원본명 (ATTACHMENT 테이블 조인 시 사용)
   
    private String positionName;

    
    
}
