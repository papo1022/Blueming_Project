package com.kh.blueming.member.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.blueming.member.model.service.MemberService;
import com.kh.blueming.member.model.vo.Member;

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

	@GetMapping("login")
	public String loginForm() {
	    return "login";
	}

	@PostMapping("login")
	public String loginMember(Member m, String saveId, Model model,
	          HttpSession session, HttpServletResponse response) {

	    // 아이디 저장 쿠키 처리
	    if((saveId != null) && (saveId.equals("y"))) {

	        Cookie cookie = new Cookie("saveId", m.getLoginId());
	        cookie.setMaxAge(30 * 24 * 60 * 60); // 30일 유지
	        cookie.setPath("/blueming/");

	        response.addCookie(cookie);

	    } else {

	        Cookie cookie = new Cookie("saveId", m.getLoginId());
	        cookie.setMaxAge(0);
	        cookie.setPath("/blueming/");

	        response.addCookie(cookie);
	    }

	    // 로그인 조회
	    Member loginUser = memberService.loginMember(m);
	    if(loginUser == null) {
	    	System.out.println("[LOGIN][FAIL] user not found or inactive | loginId=" + m.getLoginId());
	    }

	    boolean passwordMatched = (loginUser != null)
	    		&& bCryptPasswordEncoder.matches(m.getLoginPwd(), loginUser.getLoginPwd());
	    if((loginUser != null) && !passwordMatched) {
	    	System.out.println("[LOGIN][FAIL] password mismatch | loginId=" + m.getLoginId());
			// System.out.println("ENC(password) = " + bCryptPasswordEncoder.encode("password"));
	    }

	    // 비밀번호 확인
	    if(passwordMatched) {

	        // 세션 저장
	        session.setAttribute("loginUser", loginUser);

	        session.setAttribute("alertMsg",
	                             "성공적으로 로그인이 되었습니다.");

	        // 권한별 페이지 이동
	        switch(loginUser.getRole()) {

	            case "S":
	                return "redirect:/admin/main";

	            case "R":
	                return "redirect:/hr/main";

	            case "N":
	                return "redirect:/employee/main";

	            default:
	                return "redirect:/";
	        }

	    } else {

	        model.addAttribute("errorMsg",
	                           "로그인에 실패했습니다.");

	        return "common/errorPage";
	    }
	}
}
