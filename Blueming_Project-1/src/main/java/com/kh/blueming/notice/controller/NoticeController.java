package com.kh.blueming.notice.controller;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.kh.blueming.board.model.vo.Board;
import com.kh.blueming.common.model.vo.PageInfo;
import com.kh.blueming.common.template.Pagination;
import com.kh.blueming.common.template.XssDefencePolicy;
import com.kh.blueming.notice.model.service.NoticeService;
import com.kh.blueming.notice.model.vo.Notice;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("notice")
public class NoticeController {
	
	
	@Autowired
	private NoticeService noticeService;
	
	@GetMapping("list")
	public ModelAndView selectNoticeList(@RequestParam(value="cpage", defaultValue="1") int currentPage, ModelAndView mv) {
		
		// System.out.println("현재 요청한 페이지 : " + currentPage);
		
		// 일반게시판 목록 조회 기능 구현 (+ 페이징 처리)

		// * 페이징 처리 (Pagination)
		// > 리스트 조회 시 한 페이지 당 조회할 건수가 너무 많을 때
		//   한 페이지 당 n 개씩 끊어서 보여질 수 있도록 처리해주는 효과
		
		// --- 페이징 처리 ---
		// 필요한 변수는 총 7개!!
		// > 기본적으로 구할 수 있는 4개의 변수 + 그 4개의 변수를 통해 계산해서 도출해야 하는 3개의 변수
		
		// 기본적으로 구할 수 있는 4개의 변수
		int listCount; // 현재 총 게시글의 갯수 (단, 삭제되지 않은 일반게시글의 갯수)
		// int currentPage; // 현재 사용자가 보고자 하는 페이지 (즉, 사용자가 요청한 페이지)
		// > 이미 매개변수로 요청 시 전달값으로 받아내고 있음!!
		int pageLimit; // 페이지 하단에 보여질 페이징바의 페이지 최대 갯수
		int boardLimit; // 한 페이지에 보여질 게시글의 최대 갯수 (즉, 한 페이지당 몇개씩 볼거냐)
		
		// 위의 4개의 변수들로 계산해서 구해야 하는 3개의 변수
		int maxPage; // 가장 마지막 페이지가 몇 번 페이지인지 (즉, 총 페이지 수)
		int startPage; // 페이지 하단에 보여질 페이징바의 시작수
		int endPage; // 페이지 하단에 보여질 페이징바의 끝수
		
		// * listCount : 총 게시글의 갯수
		// > BOARD 테이블의 유효한 데이터의 갯수를 COUNT 함수로 세오기!!
		listCount = noticeService.selectListCount();
		
		// * currentPage : 현재 사용자가 요청한 페이지
		// > 이미 위에서 매개변수로 요청 시 전달값으로 cpage 라는 키값으로 넘겨받았음!!
		
		// * pageLimit : 페이지 하단에 보여질 페이징바의 페이지 최대 갯수
		// > 한 페이지 당 페이지 목록들을 몇 개 단위씩 보여질건지 임의의 값으로 지정하기
		//   (알고리즘 수식 계산의 편의를 위해 10으로 셋팅할 것)
		pageLimit = 10;
		
		// * boardLimit : 한 페이지에 보여질 게시글의 최대 갯수
		// > 한 페이지 당 게시글이 몇 개 씩 보여질건지 임의의 값으로 지정하기
		//   (알고리즘 수식 계산의 편의를 위해 10으로 셋팅할 것)
		boardLimit = 10;

		// 매번 listCount, currentPage, pageLimit, boardLimit 를 통해
		// maxPage, startPage, endPage 를 일일이 계산하는 코드를 작성하기 귀찮음!!
		// > 마찬가지로 공통 코드 작업을 해둘 것!!
		
		// Pagination 클래스를 생성하고 그 안에 getPageInfo 라는 메소드를 만들것!!
		PageInfo pi = Pagination.getPageInfo(listCount, currentPage, 
											 pageLimit, boardLimit);
		
		// System.out.println(listCount);
		// System.out.println(currentPage);
		// System.out.println(pageLimit);
		// System.out.println(boardLimit);
		// System.out.println(maxPage);
		// System.out.println(startPage);
		// System.out.println(endPage);
		
		// * 페이징 처리의 원리
		// > 게시글들을 최신순으로 정렬 후 페이지 구간별로 끊어서 조회해오는 것!!
		//   이때 위에서 구한 7 개의 변수들이 쿼리문에 영향을 미치기 때문에,
		//   7 개의 변수를 DAO 전달값으로 넘겨줄 것임!!
		
		// > 위의 7 개의 변수를 각 필드로 갖고있는 VO 클래스를 하나 만들 것!!
		// > PageInfo 라는 VO 클래스를 만들어서 각 변수를 필드로 가공해서 한번에 매개변수로 넘길 예정
		//   (한번 만들어 두면 공지사항, 일반게시판, 사진게시판 등 목록 조회 시 
		//    페이징 처리가 필요할 때 마다 계속 재활용해서 쓸 수 있게됨!!)
		
		/*
		PageInfo pi = new PageInfo(listCount, currentPage, pageLimit, boardLimit,
								   maxPage, startPage, endPage);
		*/
				
		// pi 를 전달하면서 Service 로 요청 후 결과 받기
		ArrayList<Notice> list = noticeService.selectNoticeList(pi);
		
		/*
		for(Board b : list) {
			
			System.out.println(b);
		}
		*/
		// > 107 ~ 98 / 97 ~ 88 / 87 ~ 78 / ...
		//   (최신 게시글 기준으로 위에서부터 10개씩)
		
		// 현재 사용자가 요청한 페이지 (currentPage) 에 보여질 게시글 리스트를
		// 응답데이터로 넘기기
		mv.addObject("list", list);
		
		// 또한, 요청 페이지 하단에 보여질 페이징바를 만드려면 위의 7개의 변수를 담은
		// pi 도 응답데이터로 넘겨줘야함!!
		mv.addObject("pi", pi);
		
		// 우선 응답페이지를 만들어서 띄워보기
		mv.setViewName("notice/noticeListView");
		
		
		return mv;
	}
	
	@GetMapping("search")
	public ModelAndView searchNoticeList(String condition, String keyword,
										@RequestParam(value="cpage", defaultValue="1") int currentPage,
										ModelAndView mv) {
		
		// System.out.println(condition);
		// > 검색 조건 : "writer" / "title" / "content"
		
		// System.out.println(keyword);
		// > 사용자가 입력한 검색어 : "ad" / "10" / "입니다"
		
		// 위의 두 값을 가지고 검색을 하되, 페이징 처리까지 해 줘야 한다!!
		// > 기본적으로 검색 시 검색 결과들 중 1번 페이지가 보여져야함!!
		//   또한 검색 결과들 중 n번 페이지를 사용자가 요청할 수도 있음!!
		//   (currentPage 값도 얻어내야함, 또한 7개의 변수도 마저 셋팅해야함)
		
		// 우선 총 검색된 게시글의 갯수를 먼저 구할 것!!
		// > condition, keyword 두개 다 넘기면서 쿼리문을 실행하고 와야 함!!
		// 1. condition, keyword 라는 두개의 필드를 가진 VO 를 만들고 객체로 만들어서 넘기기
		// 2. condition, keyword 라는 값을 HashMap 에 담아서 넘기기
		
		// > HashMap 이용해보기!!
		HashMap<String, String> map = new HashMap<>();
		map.put("condition", condition);
		map.put("keyword", keyword);
		
		int searchCount = noticeService.selectSearchCount(map);
		
		// int currentPage;
		
		int pageLimit = 10;
		int boardLimit = 10;
		
		// System.out.println(searchCount);
		// System.out.println(currentPage);
		
		// 위의 searchCount, currentPage, pageLimit, boardLimit 를 가지고
		// maxPage, startPage, endPage 를 계산해서 구해야함!!
		// > 그리고 이걸 모두 PageInfo 로 한번에 가공해야함!!
		PageInfo pi = Pagination.getPageInfo(searchCount, currentPage, 
											 pageLimit, boardLimit);
		
		// 위의 HashMap 과 PageInfo 둘 다 넘기면서 검색용 쿼리문을 실행해서 결과를 받아야함!!
		ArrayList<Notice> list = noticeService.searchNoticeList(map, pi);
		
		/*
		for(Board b : list) {
			
			System.out.println(b);
		}
		*/
		
		// 위에서 구해진 list 와 pi 를 응답데이터로 넘기면서 결과 화면 포워딩
		// > 기존의 게시글 목록 페이지 (boardListView.jsp) 를 재활용
		
		// 이 때, 검색 결과 창에 검색 조건, 검색어가 그대로 노출되었으면 좋겠음!!
		// 검색 결과 창에서 페이징바를 클릭하면 다음 페이지로 넘어가면 검색이 풀리는 이슈도 있음!!
		
		// 해결방법)
		// > 응답 데이터로 condition, keyword 를 다시 넘겨 주면 됨!!
		
		/*
		mv.addObject("list", list);
		mv.addObject("pi", pi);
		mv.addObject("condition", condition);
		mv.addObject("keyword", keyword);
		
		mv.setViewName("board/boardListView");
		*/
		
		// * ModelAndView 객체의 addObject 메소드는 return 타입이 ModelAndView 다!!
		// > 즉, mv 객체 자기자신을 리턴한다.
		mv.addObject("list", list)
		  .addObject("pi", pi)
		  .addObject("condition", condition)
		  .addObject("keyword", keyword)
		  .setViewName("notice/noticeListView");
		// > 그래서 위와 같이 메소드 체이닝이 가능하다!! (호출 순서 주의)
		
		return mv;
	}
	
	
	/*
	@GetMapping("list")
	public String selectNoticeList(Model model) {
		
		// 공지사항 리스트 조회 페이지에서 필요로 하는 응답데이터를 구해와야함!!
		// > NOTICE 테이블로부터 SELECT 된 결과물들
		ArrayList<Notice> list = noticeService.selectNoticeList();
		// > 여러행 조회이므로 ArrayList<Notice> 로 받기!!
		
		/*
		for(Notice n : list) {
			
			System.out.println(n);
		}
		*/
		/*
		model.addAttribute("list", list);
		
		// 응답페이지를 먼저 만들어서 포워딩
		return "notice/noticeListView";
		// > /WEB-INF/views/notice/noticeListView.jsp
	}
	*/
	@GetMapping("enrollForm")
	public String enrollForm() {
		
		// 공지사항 작성 페이지만 보여주고 끝
		return "notice/noticeEnrollForm";
		// > /WEB-INF/views/notice/noticeEnrollForm.jsp
	}
	
	@PostMapping("insert")
	public String insertNotice(Notice n, Model model, HttpSession session) {
		
		//System.out.println(n);
		// > 글 제목이나 내용 등에 html 태그 형식이 들어가면
		//   상세조회 시 진짜 태그로써 해석되서 화면에 출력됨!! 
		//   (또한 js 구문, css 까지 싹 다 반영됨)
		
		/*
		 * * XSS (Cross-Site-Scripting) 공격
		 * - 웹 사이트 페이지 상에 악성 스크립트를 삽입하는 공격
		 * - 글 제목이나 내용 등에 html 태그, js 코드, css 스타일 등을 삽입
		 *   (그 중에서도 js 구문 삽입이 제일 심각)
		 *   
		 * * 조치방법
		 * - 요청 시 전달값에 < 를 &lt; 으로, > 를 &gt; 로 변경해서 저장
		 * 
		 * * 시큐어 코딩
		 * - 개발 과정에서 보안 취약점을 미리 제거해
		 *   최대한 안전한 소프트웨어를 개발자 선에서 만드는 기법
		 * 예) PreparedStatement 쓰기 - SQL Injection 공격 방지
		 *     html 예약어 변경 - XSS 공격 방지
		 * 	   비밀번호 암호화
		 * 	   등등..
		 */
		
		// XSS 공격 방지용 공통코드 작업 진행!!
		// > XssDefencePolicy 클래스의 defence 메소드 (static)
		String replaceTitle 
			= XssDefencePolicy.defence(n.getNoticeTitle());
		
		String replaceContent 
			= XssDefencePolicy.defence(n.getContent());
		
		// > 각각 치환된 결과를 각 필드로 셋팅!!
		n.setNoticeTitle(replaceTitle);
		n.setContent(replaceContent);
		
		System.out.println(n);
		
		// Service 로 전달값을 넘기면서 요청 후 결과 받기
		int result = noticeService.insertNotice(n);
		
		// 처리된 결과에 따라 사용자가 보게 될 응답페이지를 지정
		if(result > 0) { 
			// > 공지사항 등록 성공
			
			// 1회성 알림 문구를 담아서 공지사항 목록 페이지로 url 재요청
			session.setAttribute("alertMsg", "성공적으로 공지사항이 등록되었습니다.");
			
			return "redirect:/notice/list";
			
		} else { 
			// > 공지사항 등록 실패
		
			// 에러문구를 담아서 에러페이지로 포워딩
			model.addAttribute("errorMsg", "공지사항 등록에 실패했습니다.");
			
			return "common/errorPage";
		}
		
	}
	
	@GetMapping("detail/{nno}")
	public String selectNotice(@PathVariable(value="nno") int noticeId, Model model) {
	

		int result = noticeService.increaseCount(noticeId);
		
		
		if(result > 0) {
			// > 조회수 증가에 성공했다면
			
			// 해당 게시글 정보를 담아서 상세보기 페이지로 포워딩
			Notice n = noticeService.selectNotice(noticeId);
			// > 단일행 조회이므로 Notice 로 받아야함!!
			
			model.addAttribute("n", n);
			
			// 먼저 상세보기 페이지 띄워보기
			return "notice/noticeDetailView";
			// > /WEB-INF/views/notice/noticeDetailView.jsp
			
		} else {
			// > 조회수 증가에 실패했다면
			
			// 에러문구를 담아서 에러페이지로 포워딩
			model.addAttribute("errorMsg", "공지사항 상세조회에 실패했습니다.");
			
			return "common/errorPage";
		}
		
	}
	
	@PostMapping("updateForm")
	public ModelAndView updateForm(@RequestParam("nno") int noticeId, ModelAndView mv) {
		
		// System.out.println("글번호 : " + noticeNo);
		
		// 요청 시 전달값인 글번호를 통해 기존의 해당 공지사항 내용들을 조회해오기
		// > 기존 공지사항 상세보기 서비스를 재활용
		Notice n = noticeService.selectNotice(noticeId);
		// > noticeNo, noticeTitle, noticeContent
		
		mv.addObject("n", n);
		
		// 먼저 공지사항 수정 페이지 띄워보기
		mv.setViewName("notice/noticeUpdateForm");
		// > /WEB-INF/views/notice/noticeUpdateForm.jsp
		
		return mv;
	}
	
	@PostMapping("update")
	public ModelAndView updateNotice(Notice n, ModelAndView mv, HttpSession session) {
		
		// System.out.println(n);
		
		// > 마찬가지로 공지사항 게시글 수정 시에도 XSS 공격 방지를 미리 해줘야 한다.
		//   (공통코드 작업)
		String replaceTitle 
			= XssDefencePolicy.defence(n.getNoticeTitle());
		
		String replaceContent
			= XssDefencePolicy.defence(n.getContent());
		
		n.setNoticeTitle(replaceTitle);
		n.setContent(replaceContent);
		
		int result = noticeService.updateNotice(n);
		
		// 결과에 따른 응답페이지 처리
		if(result > 0) {
			// > 공지사항 수정 성공
			
			// 1회성 알림 문구를 담아서 해당 게시글의 상세보기 페이지로 url 재요청
			session.setAttribute("alertMsg", "성공적으로 공지사항이 수정되었습니다.");
			
			// 쿼리스트링 방식 적용
			// mv.setViewName("redirect:/notice/detail?nno=" + n.getNoticeNo());
			// > url 재요청 방식일 경우에도 필요하다면 직접 쿼리스트링을 명시한다!!
			
			// Path Variable 방식 적용
			mv.setViewName("redirect:/notice/detail/" + n.getNoticeId());
			
		} else {
			// > 공지사항 수정 삭제
			
			// 에러문구를 담아서 에러페이지로 포워딩
			mv.addObject("errorMsg", "공지사항 수정에 실패했습니다.");
			
			mv.setViewName("common/errorPage");
			
		}
		
		return mv;
	}
	
	@PostMapping("delete")
	public String deleteNotice(@RequestParam("nno") int noticeId, Model model, HttpSession session) {
		
		
		
		int result = noticeService.deleteNotice(noticeId);
		
		if(result > 0) {
			// > 공지사항 삭제 성공
			
			// 1회성 알림 문구를 담아 공지사항 목록 페이지로 url 재요청
			session.setAttribute("alertMsg", "성공적으로 공지사항이 삭제되었습니다.");
			
			return "redirect:/notice/list";
			
		} else {
			// > 공지사항 삭제 실패
			
			// 에러문구를 담아서 에러페이지로 포워딩
			model.addAttribute("errorMsg", "공지사항 삭제에 실패했습니다.");
			
			return "common/errorPage";
		}
		
	}
	
	

}
