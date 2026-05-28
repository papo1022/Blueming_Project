package com.kh.blueming.memberlist.controller;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping; // 💡 추가
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
	
	// 기본 목록 조회 (메뉴바 클릭 시 첫 진입은 GET 유지) - /blueming/memberlist
	@GetMapping
	public ModelAndView memberList(@RequestParam(value="cpage", defaultValue="1") int currentPage,
	                                ModelAndView mv) {
		int listCount = memlistService.selectListCount();
		int pageLimit = 10;
		int boardLimit = 10;
		
		PageInfo pi = Pageination.getPageInfo(listCount, currentPage, pageLimit, boardLimit);
		ArrayList<MemberList> list = memlistService.selectMemberList(pi);
		
		// 💡 POST 방식 페이징/정렬 연동을 위해 기본값 정렬 전달
		mv.addObject("list", list)
		  .addObject("pi", pi)
		  .addObject("sortColumn", "MEMBER_ID")
		  .addObject("sortOrder", "ASC")
		  .setViewName("member/memberListView");
		
		return mv;
	}
	
	// 💡 [변경] 검색 및 페이징, 정렬 처리 - POST 방식으로 전환
	@PostMapping("/search")
	public ModelAndView searchMemberList(@RequestParam(value="condition", required=false) String condition,
	                                      @RequestParam(value="keyword", required=false) String keyword,
	                                      @RequestParam(value="cpage", defaultValue="1") int currentPage,
	                                      @RequestParam(value="sortColumn", defaultValue="MEMBER_ID") String sortColumn, // 💡 추가
	                                      @RequestParam(value="sortOrder", defaultValue="ASC") String sortOrder,       // 💡 추가
	                                      ModelAndView mv) {
		
		HashMap<String, String> map = new HashMap<>();
		map.put("condition", condition);
		map.put("keyword", keyword);
		map.put("sortColumn", sortColumn); // 💡 추가
		map.put("sortOrder", sortOrder);   // 💡 추가
		
		// 검색 조건 유무에 따른 카운트 조회
		int searchCount = memlistService.selectSearchCount(map);
		int pageLimit = 10;
		int boardLimit = 10;
		
		PageInfo pi = Pageination.getPageInfo(searchCount, currentPage, pageLimit, boardLimit);
		ArrayList<MemberList> list = memlistService.searchMemberList(map, pi);
		
		mv.addObject("list", list)
		  .addObject("pi", pi)
		  .addObject("condition", condition)
		  .addObject("keyword", keyword)
		  .addObject("sortColumn", sortColumn) // 💡 추가
		  .addObject("sortOrder", sortOrder)   // 💡 추가
		  .setViewName("member/memberListView");
		
		return mv;
	}
	

		@PostMapping("/detail")
		public ModelAndView memberDetail(@RequestParam("memberId") int memberId,
		                                  ModelAndView mv) {
			
			MemberList member = memlistService.selectMemberDetail(memberId);
			
			mv.addObject("member", member)
			  .setViewName("member/memberListDetail");
			
			return mv;
	}
		
		// 💡 [추가] 사원 수정 화면 진입 (POST 방식으로 memberId를 받음)
		@PostMapping("/updateForm")
		public ModelAndView memberUpdateForm(@RequestParam("memberId") int memberId,
		                                      ModelAndView mv) {
		    // 기존에 만들어둔 상세조회 서비스 재활용
		    MemberList member = memlistService.selectMemberDetail(memberId);
		    
		    mv.addObject("member", member)
		      .setViewName("member/memberListUpdateForm"); // 수정 폼 JSP로 이동
		    
		    return mv;
		}

		// 💡 [추가] 사원 수정 실행 (POST)
		@PostMapping("/update")
		public String updateMemberList(MemberList member, 
		                               org.springframework.web.servlet.mvc.support.RedirectAttributes rttr) {
		    
		    int result = memlistService.updateMember(member);
		    
		    if(result > 0) {
		        rttr.addFlashAttribute("alertMsg", "사원 정보가 성공적으로 수정되었습니다.");
		    } else {
		        rttr.addFlashAttribute("alertMsg", "사원 정보 수정에 실패했습니다.");
		    }
		    
		    // 수정 완료 후 보안을 유지하며 리스트 뷰를 부르기 위해 redirect 처리
		    // (만약 기존 가상조회 방식을 쓴다면 상세창으로 튕겨도 좋습니다. 여기선 안전하게 리스트로 리다이렉트합니다.)
		    return "redirect:/memberlist";
		}
}