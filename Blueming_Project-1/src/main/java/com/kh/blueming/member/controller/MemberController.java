package com.kh.blueming.member.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.blueming.member.model.vo.Member;

import ch.qos.logback.core.model.Model;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("member")
public class MemberController {
	@Autowired
	private BCryptPasswordEncoder bCryptPasswordEncoder;
	
	@Autowired
	private MemberService memberService;
	
	@PostMapping("login")
	public void loginMember {Member m, String saveId, Model model, 
		  					HttpSession session, HttpServletResponse response) {
		
		  						
		  						
		  	if((saveId != null) && (saveId.equals("y"))) {
		
			Cookie cookie = new Cookie("saveId", m.getUserId());
			cookie.setMaxAge(1 * 24 * 60 * 60); // 1일 (초단위)
			cookie.setPath("/blueming/"); // 이 쿠키를 우리 웹사이트 내부에서만 이용 가능하게끔
			
			/*
			 * 4. 쿠키를 생성했다면 저장은 브라우저에 해야 함!!
			 * > 생성된 쿠키를 브라우저가 받아볼 수 있도록 응답 정보에 첨부하기
			 * response.addCookie(쿠키객체명);
			 */
			
			response.addCookie(cookie);
			
		} else {
		
			
			Cookie cookie = new Cookie("saveId", m.getUserId());
			cookie.setMaxAge(0);
			cookie.setPath("/blueming/");
			
			response.addCookie(cookie);
		}
		  					
		  	Member loginUser = memberService.loginMember(m);
			
			if((loginUser != null) && 
			   (bCryptPasswordEncoder.matches(m.getUserPwd(), loginUser.getUserPwd()))) {
				
				session.setAttribute("loginUser", loginUser);
				
				
				session.setAttribute("alertMsg", "성공적으로 로그인이 되었습니다.");
				
				return "redirect:/";
				
			} else {
				
				model.addAttribute("errorMsg", "로그인에 실패했습니다.");
				
				return "common/errorPage";
			}
		  					
		  					
		
	}
}
