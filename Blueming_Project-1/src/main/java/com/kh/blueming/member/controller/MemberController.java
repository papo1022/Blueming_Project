package com.kh.blueming.member.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.kh.blueming.admindashboard.model.vo.AdminDashboardCourse;
import com.kh.blueming.common.model.vo.PageInfo;
import com.kh.blueming.common.template.Pageination;
import com.kh.blueming.common.template.XssDefencePolicy;
import com.kh.blueming.course.model.service.CourseService;
import com.kh.blueming.member.model.service.MemberDashboardService;
import com.kh.blueming.member.model.service.MemberService;
import com.kh.blueming.member.model.service.OngoingCourseService;
import com.kh.blueming.member.model.vo.Member;
import com.kh.blueming.member.model.vo.MemberProfile;
import com.kh.blueming.member.model.vo.OngoingCourse;
import com.kh.blueming.notice.model.service.NoticeService;
import com.kh.blueming.notice.model.vo.Notice;

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
	
	@Autowired
	private CourseService courseService;
	
	@Autowired
	private NoticeService noticeService;
	
	@Autowired
	private JavaMailSender mailSender;
	
	@Autowired
	private OngoingCourseService ongoingCourseService;
	
	@GetMapping("login")
	public String loginGet() {
	   
	    return "login";
	}
	
	@GetMapping("enrollForm1")
	public String enrollForm1() {
		return "member/enrollForm1"; 
	}

	@GetMapping("enrollForm2")
	public String enrollForm2() {
		return "member/enrollForm2"; 
	}
	
	
	@GetMapping("admin")
	public String admin(Model model, HttpSession session) {
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
		//MemberProfile profile = MemberDashboardService.selectMemberProfile(memberId);
		List<AdminDashboardCourse> courseList = courseService.selectAdminCourseList();
		List<Notice> noticeList = noticeService.selectRecentNoticeList();
		
		// 5. Model에 담기
		//model.addAttribute("profile", profile);
		model.addAttribute("courseList", courseList);
		model.addAttribute("noticeList", noticeList);
		model.addAttribute("test", "으악");
		
		// 6. JSP로 이동
		return "member/admin";
	}

	@GetMapping("employee")
	public String employee() {
	    return "member/employee";
	}
	
	/**
	 * [아이디 찾기] STEP 1: 인증번호 이메일 발송
	 * @param m 사용자가 입력한 name과 email 정보가 담긴 객체
	 */
	@ResponseBody
	@PostMapping("sendCodeForId")
	public String sendCodeForId(Member m, HttpSession session) {
		// 1. 입력받은 이름과 이메일로 가입된 아이디가 존재하는지 확인 (VO 가공 정책 준수)
		String loginId = memberService.findIdByEmail(m);
		if (loginId == null) {
			return "NOT_FOUND"; // 일치하는 회원 없음
		}
		
		// 2. 6자리 난수(인증번호) 생성 후 메일 발송
		String authCode = String.valueOf((int)(Math.random() * 899999) + 100000);
		try {
			SimpleMailMessage message = new SimpleMailMessage();
			message.setTo(m.getEmail());
			message.setSubject("[Blueming] 아이디 찾기 본인확인 인증번호");
			message.setText("안녕하세요. 아이디 찾기를 위한 인증번호는 [" + authCode + "] 입니다.");
			mailSender.send(message);
			
			// 3. 인증번호 확인을 위해 세션에 임시 저장
			session.setAttribute("idAuthCode", authCode);
			session.setAttribute("targetEmail", m.getEmail());
			session.setAttribute("targetName", m.getName());
			return "SUCCESS";
			
		} catch (Exception e) {
			e.printStackTrace();
			return "ERROR";
		}
	}

	/**
	 * [아이디 찾기] STEP 2: 인증번호 확인 후 아이디 노출 페이지 이동
	 */
	@PostMapping("findId")
	public String findId(String code, HttpSession session, Model model) {
		String savedCode = (String) session.getAttribute("idAuthCode");
		String email = (String) session.getAttribute("targetEmail");
		String name = (String) session.getAttribute("targetName");
		
		if (savedCode != null && savedCode.equals(code)) {
			Member m = new Member();
			m.setEmail(email);
			m.setName(name);
			
			String loginId = memberService.findIdByEmail(m);
			model.addAttribute("loginId", loginId);
			
			// 인증용 세션 초기화
			session.removeAttribute("idAuthCode");
			session.removeAttribute("targetEmail");
			session.removeAttribute("targetName");
			
			return "member/findIdResult"; // views/member/findIdResult.jsp
		} else {
			session.setAttribute("alertMsg", "인증번호가 일치하지 않습니다.");
			return "redirect:/member/findIdForm"; // 다시 찾기 폼으로 리다이렉트
		}
	}

	/**
	 * [비밀번호 찾기] STEP 1: 아이디, 이름, 이메일 일치 여부 확인 후 인증번호 발송
	 */
	@ResponseBody
	@PostMapping("sendCodeForPwd")
	public String sendCodeForPwd(Member m, HttpSession session) {
		// 1. 입력받은 정보와 일치하는 회원이 있는지 확인
		int count = memberService.checkMemberExist(m);
		if (count == 0) {
			return "NOT_FOUND"; 
		}
		
		// 2. 존재한다면 인증번호 생성 및 메일 발송
		String authCode = String.valueOf((int)(Math.random() * 899999) + 100000);
		try {
			SimpleMailMessage message = new SimpleMailMessage();
			message.setTo(m.getEmail());
			message.setSubject("[Blueming] 비밀번호 찾기 본인확인 인증번호");
			message.setText("안녕하세요. 비밀번호 재설정을 위한 인증번호는 [" + authCode + "] 입니다.");
			mailSender.send(message);
			
			// 3. 비밀번호 재설정을 위해 주요 정보를 세션에 보관
			session.setAttribute("pwdAuthCode", authCode);
			session.setAttribute("targetEmail", m.getEmail());
			session.setAttribute("targetId", m.getLoginId());
			return "SUCCESS";
			
		} catch (Exception e) {
			e.printStackTrace();
			return "ERROR";
		}
	}

	/**
	 * [비밀번호 찾기] STEP 2: 인증번호 일치 시 새 비밀번호 입력 폼으로 이동
	 */
	@PostMapping("verifyPwdCode")
	public String verifyPwdCode(String code, HttpSession session) {
		String savedCode = (String) session.getAttribute("pwdAuthCode");
		
		if (savedCode != null && savedCode.equals(code)) {
			session.setAttribute("pwdPassed", true); // 인증 통과 자격 부여
			session.removeAttribute("pwdAuthCode");
			return "member/resetPasswordForm"; // views/member/resetPasswordForm.jsp
		} else {
			session.setAttribute("alertMsg", "인증번호가 일치하지 않습니다.");
			return "redirect:/member/findPwdForm"; 
		}
	}

	/**
	 * [비밀번호 찾기] STEP 3: 최종 새로운 비밀번호로 재설정 처리 (암호화 반영)
	 * @param newPwd 사용자가 새로 입력한 평문 비밀번호
	 */
	@PostMapping("resetPassword")
	public String resetPassword(String newPwd, HttpSession session) {
		Boolean pwdPassed = (Boolean) session.getAttribute("pwdPassed");
		String loginId = (String) session.getAttribute("targetId");
		String email = (String) session.getAttribute("targetEmail");
		
		// 비정상적인 URL 접근 차단
		if (pwdPassed == null || !pwdPassed) {
			return "redirect:/"; 
		}
		
		// 기존 updatePwd 로직처럼 bCryptPasswordEncoder를 사용해 암호화 진행
		String encryptedPwd = bCryptPasswordEncoder.encode(newPwd);
		
		Member m = new Member();
		m.setLoginId(loginId);
		m.setEmail(email);
		m.setLoginPwd(encryptedPwd); // 암호화된 비밀번호 대입
		
		int result = memberService.resetPassword(m);
		
		if (result > 0) {
			session.invalidate(); // 인증에 사용된 세션 제거 및 전체 로그아웃 효과
			return "member/resetPwdSuccess"; // views/member/resetPwdSuccess.jsp
		} else {
			return "common/errorPage";
		}
	}
	
	
	@RequestMapping("/")
	public String home(HttpSession session) {
	    Member loginUser = (Member) session.getAttribute("loginUser");
	    
	    // 로그인 상태가 아니라면 views/index.jsp (로그인 화면)로 이동
	    if (loginUser == null) {
	        return "index"; 
	    }
	    
	    // 로그인 상태라면 권한(Role)별 페이지로 이동
	    String role = loginUser.getRole();
	    if ("S".equals(role)) {
	        return "member/admin";      // views/member/admin.jsp
	    } else if ("R".equals(role)) {
	        return "member/hr";         // views/member/hr.jsp
	    } else {
	        return "member/employee";   // views/member/employee.jsp
	    }
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
	            return "redirect:/member/admin";

	        case "R":
	            return "redirect:/member/hr";

	        case "N":
	            return "redirect:/member/employee";

	        default:
	            return "redirect:/";
	        }

	    } else {

	        model.addAttribute("errorMsg",
	                "아이디 또는 비밀번호를 잘못 입력했습니다.");

	        return "login";
	    }
	}
	
	@GetMapping("logout")
	public String logoutMember(HttpSession session) {
		
		session.setAttribute("alertMsg", "성공적으로 로그아웃이 되었습니다.");
		session.removeAttribute("loginUser");
		
		
		
		
		
		return "redirect:/";
		
	}
	
	@GetMapping("myPage")
	public ModelAndView myPage(
	        @RequestParam(value="cpage", defaultValue="1") int currentPage,
	        ModelAndView mv,
	        HttpSession session) {

	    Member loginUser =
	            (Member)session.getAttribute("loginUser");

	    int memberId = loginUser.getMemberId();

	    // 전체 강의 수
	    int listCount =
	            ongoingCourseService.selectCourseCount(memberId);

	    // 페이징 정보 생성
	    PageInfo pi =
	            Pageination.getPageInfo(
	                    listCount,
	                    currentPage,
	                    5,   // 페이지번호 5개씩
	                    3   // 한 페이지당 10개
	            );

	    // 현재 페이지 강의 조회
	    List<OngoingCourse> courseList =
	            ongoingCourseService.selectMyCourseList(
	                    pi,
	                    memberId);

	    mv.addObject("pi", pi);
	    mv.addObject("courseList", courseList);

	    mv.setViewName("member/myPage");

	    return mv;
	}
	
	
	
	@PostMapping("updatePwd")
	public String updatePwd(String loginId, String loginPwd, String updatePwd, HttpSession session) {
		
		// System.out.println(userPwd);
		// System.out.println(updatePwd);
		
		// > 쿼리문을 미리 짜봤더니 
		//   해당 회원(== 비번을 바꾸고자 하는 회원 == 현재 로그인한 회원) 의 아이디도 필요함!!
		
		// * 현재 로그인한 회원의 정보를 알아내는 방법
		// 1. HttpSession 객체로부터 꺼내오는 방법
		// String userId = ((Member)(session.getAttribute("loginUser"))).getUserId();
		// System.out.println(userId);
		
		// 2. form 태그 내부에서 <input type="hidden"> 을 통해 로그인한 회원의 정보를 넘기는 방법
		// System.out.println(userId);
		
		// > 평문 아이디, 평문 현재의 비밀번호, 평문 바꿀 비밀번호
		
		// 우선 사용자가 입력한 평문 현재의 비밀번호와 
		// 세션에 담겨있는 현재 로그인한 사용자의 암호화된 비밀번호가 맞아 떨어지는지 대조
		Member loginUser = (Member)(session.getAttribute("loginUser"));
		
		if(bCryptPasswordEncoder.matches(loginPwd, loginUser.getLoginPwd())) {
			// > 평문과 암호문 비밀번호가 맞아 떨어질 경우 
			
			// 비밀번호 변경 요청 서비스 호출 후 결과 받기
			// > 변경할 비밀번호 또한 암호문 형태로 변경해야한다!!
			String updateEncPwd = bCryptPasswordEncoder.encode(updatePwd);
			
			// 아이디와 변경할 비밀번호의 암호문을 넘기면서 서비스 호출 및 결과 받기
			// > 두 개 이상의 값을 한번에 넘길 경우에는 무조건 VO 등으로 가공해서 한번에 넘긴다!!
			Member m = new Member();
			m.setLoginId(loginId);
			m.setLoginPwd(updateEncPwd);
			
			int result = memberService.updatePwd(m);
			
			// 처리된 결과에 따라 사용자가 보게 될 응답페이지를 지정
			if(result > 0) { 
				// > 비밀번호 변경 성공
				
				// 현재 로그인한 회원의 정보가 조금이라도 변경되었다면 
				// 무조건 그 갱신된 정보를 다시 불러와서 세션에 덮어씌워야함!!
				// > 기존의 로그인용 서비스 재활용하기
				Member updateMem = memberService.loginMember(m);
				
				session.setAttribute("loginUser", updateMem);
				// > 동일한 키값으로 한번 더 추가를 하면 밸류가 덮어씌워짐!!
				
				// 비밀번호가 잘 변경되었음을 1회성 알림 문구로 담아줄 것
				session.setAttribute("alertMsg", "성공적으로 비밀번호가 변경되었습니다.");
				
			} else {
				// > 비밀번호 변경 실패
				
				// 1회성 알림문구를 담기
				session.setAttribute("alertMsg", "비밀번호 변경에 실패했습니다.");
			}
			
		} else {
			// > 평문과 암호문 비밀번호가 맞아 떨어지지 않을 경우
			//   (사용자가 현재 비밀번호를 잘못 입력한 경우)
			
			// 1회성 알림 문구로 잘못입력했다고 알려주기
			session.setAttribute("alertMsg", "잘못된 비밀번호입니다. 다시 입력해주세요.");
		}
		
		// 뭐가 되었든 간에 마이페이지로 url 재요청
		return "redirect:/member/myPage";
	}
	@PostMapping("update")
	public ModelAndView updateMember(Member m, ModelAndView mv, HttpSession session) {
		
		m.setName(XssDefencePolicy.defence(m.getName()));
		m.setEmail(XssDefencePolicy.defence(m.getEmail()));
		m.setAddress(XssDefencePolicy.defence(m.getAddress()));
		
		int result = memberService.updateMember(m);
		System.out.println(result);
		// 3. 결과에 따른 응답페이지 처리
		if(result > 0) {
			// > 회원 정보 변경 성공
			
			// 갱신된 회원의 정보를 다시 조회해와서 세션에 덮어씌운 후
			// > 기존의 로그인용 서비스를 재활용 해서 단순히 호출해서 쓸 것!!
			//   (아까 로그인용 쿼리문에서 아이디가 일치하고 STATUS = 'Y' 일 경우만 조회되도록 수정했음)
			
			
			Member updateMem = memberService.loginMember(m);
			
			
			
			session.setAttribute("loginUser", updateMem);
			// > session 에 이미 loginUser 라는 키 + 밸류로 갱신 전 회원의 정보가 담겨있는 상황
			//   loginUser 키값으로 갱신된 회원의 정보를 다시 setAttribute 하면
			//   동일한 키값으로 데이터가 덮어씌워진다!! (HashMap 과 동일)
			
			// 일회성 문구를 담아서 마이페이지로 url 재요청 
			// > 우리가 마이페이지에서 내 정보 조회 기능을 별도로 따로 조회해서 출력하는게 아니라
			//   이미 세션에 담겨있던 해당 회원의 정보를 그냥 출력해줬기 때문에
			//   회원 정보 변경이 일어난 후 갱신된 정보로 다시 세션에 덮어씌워주는것 까지 해줘야함!!
			session.setAttribute("alertMsg", "성공적으로 회원 정보가 변경되었습니다.");
			
			// ModelAndView 방식으로도 url 재요청이 가능!!
			mv.setViewName("redirect:/member/myPage");
			// > 똑같이 "redirect:url주소" 를 적는다!!
			
		} else {
			// > 회원 정보 변경 실패
			
			// 에러 문구를 담아서 에러페이지로 포워딩
			mv.addObject("errorMsg", "회원정보 변경에 실패했습니다.");
			
			mv.setViewName("common/errorPage");
			// > /WEB-INF/views/common/errorPage.jsp
		}
		
		return mv;
		
	}

	@PostMapping("delete")
	public String deleteMember(String userPwd, HttpSession session, Model model) {
		
		// 우선 사용자가 입력한 평문 비밀번호와 세션에 담겨있는 암호화된 기존의 비밀번호를 대조하기
		Member loginUser = (Member)(session.getAttribute("loginUser"));
		
		if(bCryptPasswordEncoder.matches(userPwd, loginUser.getLoginPwd())) {
			// > 평문과 암호문 비밀번호가 맞아 떨어질 경우
			
			// 회원 탈퇴 서비스 요청 후 결과 받기
			int result = memberService.deleteMember(loginUser.getLoginId());
			
			// 탈퇴 처리 결과에 따른 응답 페이지 지정
			if(result > 0) { 
				// > 탈퇴 성공
				
				// 로그아웃 처리 후 일회성 알림 문구를 담고 메인페이지로 url 재요청
				session.removeAttribute("loginUser");
				
				session.setAttribute("alertMsg", "성공적으로 회원 탈퇴 처리 되었습니다. 그동안 이용해 주셔서 감사합니다.");
				
				return "redirect:/";
				
			} else {
				// > 탈퇴 실패
				
				// 에러문구를 담아서 에러페이지로 포워딩
				model.addAttribute("errorMsg", "회원 탈퇴에 실패했습니다.");
				
				return "common/errorPage";
			}
			
		} else {
			// > 평문과 암호문 비밀번호가 다를 경우
			//   (현재 비밀번호를 잘못 입력한 경우)
			
			// 1회성 알림 문구로 잘못 입력했음을 알려주고, 마이페이지로 url 재요청
			session.setAttribute("alertMsg", "잘못된 비밀번호입니다. 다시 입력해주세요.");
			
			return "redirect:/member/myPage";
		}
		
	}
	
	
}
