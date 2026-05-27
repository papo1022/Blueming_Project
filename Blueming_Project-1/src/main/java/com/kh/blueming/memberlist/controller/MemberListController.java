package com.kh.blueming.memberlist.controller;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.kh.blueming.memberlist.model.service.MemberListService;
import com.kh.blueming.memberlist.model.vo.MemberList;
import com.kh.blueming.model.vo.PageInfo;

@Controller
@RequestMapping("memberlist")
public class MemberListController {
	
	@Autowired
	private MemberListService memlistService;
	
	
	
	public ModelAndView searchMemberList(String condition, String keyword,
										 @RequestParam(value="cpage",defaultValue="1")int currentPage,
										 ModelAndView mv) {
		
		
		HashMap<String,String> map = new HashMap<>();
		map.put("condition", condition);
		map.put("keyword", keyword);
		
		int searchCount = memlistService.selectSearchCount(map);
		
		int pageLimit = 10;
		int boardLimit = 10;
		
		PageInfo pi = Pagination.getPageInfo(searchCount,currentPage,
											 pageLimit,boardLimit);
		
		ArrayList<MemberList> list = memlistService.searchMemberList(map,pi);
		
		mv.addObject("list",list)
		  .addObject("pi",pi)
		  .addObject("condition",condition)
		  .addObject("keyword",keyword)
		  .setViewName("member/memberListView");
		
		return mv;
		
		
		
		
	}
	
	
	
	
	
	
	
	
	
	
	
}
