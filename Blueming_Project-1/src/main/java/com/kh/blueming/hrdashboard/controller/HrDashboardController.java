package com.kh.blueming.hrdashboard.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.blueming.hrdashboard.model.service.HrDashboardService;
import com.kh.blueming.hrdashboard.model.vo.HrDashboardMember;
import com.kh.blueming.member.model.service.MemberDashboardService;
import com.kh.blueming.member.model.vo.Member;
import com.kh.blueming.member.model.vo.MemberProfile;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/hrDashboard")
public class HrDashboardController {
	
	@Autowired
	private HrDashboardService hrDashboardService;
	
	@Autowired
	private MemberDashboardService memberDashboardService;
	// 프로필 조회 재사용
	
	@GetMapping("main")
	public String hrDashboard(HttpSession session, Model model) {
		
		// 1. 세션에서 로그인 정보 꺼내기
		Member loginUser = (Member)session.getAttribute("loginUser");
		
		// 2. 로그인 안 했으면 로그인 페이지로
		if(loginUser == null) {
			
			return "redirect:/member/login";
		}
		
		// 3. 인사팀 직원(ROLE = 'R')이 아니면 접근 차단
		// N(사원) / S(관리자) / R(인사팀)
		if(!loginUser.getRole().equals("R")) {
			
			return "redirect:/dashboard/main";
		}
		
		int memberId = loginUser.getMemberId();
		
		// 4. 데이터 조회
		// 프로필은 기존 MemberDashboardService 재사용
		MemberProfile profile = memberDashboardService.selectMemberProfile(memberId);
		
		// 전체 사원 이수율 목록
		List<HrDashboardMember> hrMemberList = hrDashboardService.selectHrMemberList();
		
		// 5. Model에 담기
		model.addAttribute("profile", profile);
		model.addAttribute("hrMemberList", hrMemberList);
		
		// 6. JSP로 이동
		return "hrDashboard/hrDashboard";
		// "/WEB-INF/views/hrDashboard/hrDashboard.jsp"
	}

}
