package com.kh.blueming.admindashboard.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.blueming.admindashboard.model.service.AdminDashboardService;
import com.kh.blueming.admindashboard.model.vo.AdminDashboardCourse;
import com.kh.blueming.member.model.service.MemberDashboardService;
import com.kh.blueming.member.model.vo.Member;
import com.kh.blueming.member.model.vo.MemberProfile;
import com.kh.blueming.notice.model.vo.Notice;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/adminDashboard")
public class AdminDashboardController {

	@Autowired
	private AdminDashboardService adminDashboardService;
	
	@Autowired
	private MemberDashboardService memberDashboardService; // 프로필은 재사용
	
	@GetMapping("main")
	public String adminDashboard(HttpSession session, Model model) {
		
		// 1. 세션에서 로그인 정보 꺼내기
		Member loginUser = (Member)session.getAttribute("loginUser");
		
		// 2. 로그인 안 했으면 로그인 페이지로
		if(loginUser == null) {
			
			return "redirect:/member/login";
		}
		
		// 3. 관리자(ROLE = 'S')가 아니면 접근 차단
		if(!loginUser.getRole().equals("S")) {
			
			return "redirect:/dashboard/main";
		}
		
		int memberId = loginUser.getMemberId();
		
		// 4. 데이터 조회
		MemberProfile profile = memberDashboardService.selectMemberProfile(memberId);
		List<AdminDashboardCourse> courseList = adminDashboardService.selectAdminCourseList();
		List<Notice> noticeList = adminDashboardService.selectRecentNoticeList();
		
		// 5. Model에 담기
		model.addAttribute("profile", profile);
		model.addAttribute("courseList", courseList);
		model.addAttribute("noticeList", noticeList);
		
		// 6. JSP로 이동
		return "adminDashboard/adminDashboard";
		// "WEB-INF/views/adminDashboard/adminDashboard.jsp"
	}
}
