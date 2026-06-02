package com.kh.blueming.common.model.vo;

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
public class PageInfo {

	// 필드부 (7개의 변수를 필드로 구성)
	private int listCount;
	private int currentPage;
	private int pageLimit;
	private int boardLimit;
	private int maxPage;
	private int startPage;
	private int endPage;
	
	

}
