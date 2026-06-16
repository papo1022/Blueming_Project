package com.kh.blueming.common.template;

import com.kh.blueming.common.model.vo.PageInfo;

//페이징 수를 계산하는 파일입니다.
public class Pageination {
	public static PageInfo getPageInfo(int listCount, int currentPage
			, int pageLimit, int boardLimit) {
		
		int maxPage = (int)(Math.ceil((double)listCount / boardLimit));
				
		int startPage = (currentPage -1) / pageLimit * pageLimit +1;
		
		int endPage = startPage + (pageLimit -1);
		
		if (endPage > maxPage) {
			endPage = maxPage;
		}
		
		int startRow = (currentPage - 1) * boardLimit + 1;
		int endRow = startRow + boardLimit - 1;
		
		return new PageInfo(listCount, currentPage, pageLimit, boardLimit,
							maxPage, startPage, endPage, startRow, endRow);
	}
}
