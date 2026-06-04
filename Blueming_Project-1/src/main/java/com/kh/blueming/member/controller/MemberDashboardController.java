package com.kh.blueming.member.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.blueming.assignment.model.vo.AssignmentCard;
import com.kh.blueming.course.model.vo.CourseCard;
import com.kh.blueming.member.model.service.MemberDashboardService;
import com.kh.blueming.member.model.vo.Member;
import com.kh.blueming.member.model.vo.MemberProfile;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/dashboard")
public class MemberDashboardController {

	private MemberDashboardService memberDashboardService;
	
	public String dashboard(HttpSession session, Model model) {
		
		// 1. 세션에서 로그인한 사용자 정보 가져오기
		Member loginMember = (Member)session.getAttribute("loginMember");
		
		// 2. 로그인 안 했으면 로그인 페이지로 보내기
		if(loginMember == null) {
			
			return "redirect:/member/login"; // 주소 맞는지 확인 필요
		}
		
		int memberId = loginMember.getMemberId();
		
		// 3. Service 호출해서 데이터 가져오기
		MemberProfile profile = memberDashboardService.selectMemberProfile(memberId);
		List<CourseCard> courseList = memberDashboardService.selectMyCourseList(memberId);
		List<AssignmentCard> assignmentList = memberDashboardService.selectMyAssignmentList(memberId);
		
		// 4. 데이터 담기
		model.addAttribute("profile", profile);
		model.addAttribute("courseList", courseList);
		model.addAttribute("assignmentList", assignmentList);
		
		// 5. JSP 경로 반환
		return "memberDashboard/memberDashboard";
		// "/WEB-INF/views/memberDashboard/memberDashboard.jsp"
		
	}
}
