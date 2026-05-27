package com.kh.blueming.memberlist.controller;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.kh.blueming.memberlist.model.service.MemberListService;
import com.kh.blueming.memberlist.model.vo.MemberList;
import com.kh.blueming.common.model.vo.PageInfo;
import com.kh.blueming.common.template.Pageination;

@Controller
@RequestMapping("/memberlist")
public class MemberListController {
	
	@Autowired
	private MemberListService memlistService;
	
	// 기본 목록 조회 - /blueming/memberlist
	@GetMapping
	public ModelAndView memberList(@RequestParam(value="cpage", defaultValue="1") int currentPage,
	                                ModelAndView mv) {
		int listCount = memlistService.selectListCount();
		int pageLimit = 10;
		int boardLimit = 10;
		
		PageInfo pi = Pageination.getPageInfo(listCount, currentPage, pageLimit, boardLimit);
		ArrayList<MemberList> list = memlistService.selectMemberList(pi);
		
		mv.addObject("list", list)
		  .addObject("pi", pi)
		  .setViewName("member/memberListView");
		
		return mv;
	}
	
	// 검색 - /blueming/memberlist/search
	@GetMapping("/search")
	public ModelAndView searchMemberList(@RequestParam(value="condition", required=false) String condition,
	                                      @RequestParam(value="keyword", required=false) String keyword,
	                                      @RequestParam(value="cpage", defaultValue="1") int currentPage,
	                                      ModelAndView mv) {
		
		HashMap<String, String> map = new HashMap<>();
		map.put("condition", condition);
		map.put("keyword", keyword);
		
		int searchCount = memlistService.selectSearchCount(map);
		int pageLimit = 10;
		int boardLimit = 10;
		
		PageInfo pi = Pageination.getPageInfo(searchCount, currentPage, pageLimit, boardLimit);
		ArrayList<MemberList> list = memlistService.searchMemberList(map, pi);
		
		mv.addObject("list", list)
		  .addObject("pi", pi)
		  .addObject("condition", condition)
		  .addObject("keyword", keyword)
		  .setViewName("member/memberListView");
		
		return mv;
	}
	
	@GetMapping("/detail")
	public ModelAndView memberDetail(@RequestParam("memberId") int memberId,
	                                  ModelAndView mv) {
		
		MemberList member = memlistService.selectMemberDetail(memberId);
		
		mv.addObject("member", member)
		  .setViewName("member/memberListDetail");  // 변경
		
		return mv;
	}
	
}