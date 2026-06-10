package com.kh.blueming.memberlist.controller;





import jakarta.servlet.http.HttpServletRequest;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.blueming.common.model.vo.PageInfo;
import com.kh.blueming.common.template.Pageination;
import com.kh.blueming.member.model.vo.Member;
import com.kh.blueming.memberlist.model.service.MemberListService;
import com.kh.blueming.memberlist.model.vo.MemberList;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/memberlist")
public class MemberListController {
    
    @Autowired
    private MemberListService memlistService;

    // 공통 권한 체크 로직: 로그인 여부와 ROLE이 'R'인지 확인
    private boolean isNotAuthorized(HttpSession session) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        return loginUser == null || !"R".equals(loginUser.getRole());
    }

    // 1. 사원 관리 목록 페이지
    @RequestMapping(value = "", method = {RequestMethod.GET, RequestMethod.POST})
    public String memberList(
            @RequestParam(value="cpage", defaultValue="1") int currentPage,
            @RequestParam(value="sortColumn", defaultValue="MEMBER_ID") String sortColumn,
            @RequestParam(value="sortOrder", defaultValue="DESC") String sortOrder,
            @RequestParam(value="condition", required=false) String condition, // 검색 조건
            @RequestParam(value="keyword", required=false) String keyword,     // 검색어
            HttpSession session, Model model) {
        
        // 1. 권한 체크
        if (isNotAuthorized(session)) {
            session.setAttribute("alertMsg", "접근 권한이 없습니다.");
            return "redirect:/";
        }
        
        // 2. 검색/정렬 데이터 맵핑
        HashMap<String, String> map = new HashMap<>();
        map.put("sortColumn", sortColumn);
        map.put("sortOrder", sortOrder);
        map.put("condition", condition);
        map.put("keyword", keyword);
        
        // 3. 검색 여부 판단 (키워드가 비어있지 않으면 검색 모드)
        boolean isSearch = (keyword != null && !keyword.trim().isEmpty());
        
        // 4. 리스트 총 개수 조회 (검색 모드인지 일반 모드인지에 따라 호출)
        int listCount = isSearch ? memlistService.selectSearchCount(map) 
                                 : memlistService.selectListCount();
        
        // 5. 페이징 처리
        PageInfo pi = Pageination.getPageInfo(listCount, currentPage, 10, 10);
        
        // 6. 리스트 조회
        ArrayList<MemberList> list = isSearch ? memlistService.searchMemberList(map, pi) 
                                              : memlistService.selectMemberList(pi, map); 
        
        // 7. 화면으로 데이터 전달
        model.addAttribute("list", list)
             .addAttribute("pi", pi)
             .addAttribute("sortColumn", sortColumn)
             .addAttribute("sortOrder", sortOrder)
             .addAttribute("condition", condition)
             .addAttribute("keyword", keyword);
        
        return "member/memberListView";
    }

 
 // 2. 상세 조회 (수정본)
    @GetMapping("/detail")
    public ModelAndView memberDetail(
            @RequestParam("memberId") int memberId,
            @RequestParam(value="cpage", defaultValue="1") int listCpage,           // 🌟 추가: 원래 목록 페이지 번호
            @RequestParam(value="condition", required=false) String condition,     // 🌟 추가: 원래 목록 검색 조건
            @RequestParam(value="keyword", required=false) String keyword,         // 🌟 추가: 원래 목록 검색어
            @RequestParam(value="sortColumn", defaultValue="MEMBER_ID") String sortColumn, // 🌟 추가: 원래 목록 정렬 컬럼
            @RequestParam(value="sortOrder", defaultValue="DESC") String sortOrder,       // 🌟 추가: 원래 목록 정렬 순서
            HttpSession session, ModelAndView mv) {
        
        // 1. 권한 체크
        if (isNotAuthorized(session)) return new ModelAndView("redirect:/");
        
        // 2. 서비스 호출
        MemberList member = memlistService.selectMemberDetail(memberId);
        
        // 3. 존재하지 않는 사원이거나 관리 불가 사원일 경우 차단
        if (member == null) {
            session.setAttribute("alertMsg", "유효하지 않은 사원 정보입니다.");
            mv.setViewName("redirect:/memberlist");
            return mv;
        }
        
        // 4. 사원 상세 정보와 함께 '원래 보던 목록의 페이징/검색 상태 정보'를 바구니에 담아 보냅니다.
        mv.addObject("member", member)
          .addObject("listCpage", listCpage)
          .addObject("listCondition", condition)
          .addObject("listKeyword", keyword)
          .addObject("listSortColumn", sortColumn)
          .addObject("listSortOrder", sortOrder)
          .setViewName("member/memberListDetail");
          
        return mv;
    }
    
    // 3. 수정 화면 이동
    @PostMapping("/updateForm")
    public ModelAndView updateForm(@RequestParam("memberId") int memberId, HttpSession session, ModelAndView mv) {
        if (isNotAuthorized(session)) {
            mv.setViewName("redirect:/");
            return mv;
        }
        mv.addObject("deptList", memlistService.selectDeptList());
        ArrayList<MemberList> posList = memlistService.selectPosList();
        
        mv.addObject("posList", posList);
        
        MemberList member = memlistService.selectMemberDetail(memberId);
        mv.addObject("member", member).setViewName("member/memberListUpdateForm");
        
        
        return mv;
    }
    
    // 4. 수정 처리
    @PostMapping("/update")
    public String updateMember(MemberList m, HttpSession session, RedirectAttributes ra) {
        if (isNotAuthorized(session)) {
            return "redirect:/";
        }
        
     // 2. [데이터 검증] 수정을 요청한 대상(m.getMemberId())이 
        //    실제로 수정 가능한 대상인지 한 번 더 확인 (핵심)
        MemberList existingMember = memlistService.selectMemberDetail(m.getMemberId());
        if (existingMember == null) {
            ra.addFlashAttribute("alertMsg", "수정할 수 없는 대상입니다.");
            return "redirect:/memberlist";
        }

        // 3. [로직 수행]
    
        
        int result = memlistService.updateMember(m);
        if(result > 0) {
            ra.addFlashAttribute("alertMsg", "성공적으로 수정되었습니다.");
        } else {
            ra.addFlashAttribute("alertMsg", "수정에 실패했습니다.");
        }
        return "redirect:/memberlist";
    }
    
    
    /**
     * 5. 사원 등록 화면 이동
     * 부서 목록과 직급 목록을 조회해서 등록 폼(JSP)으로 넘겨줍니다.
     */
    @GetMapping("/insertForm")
    public ModelAndView enrollForm(HttpSession session, ModelAndView mv) {
        // 1. 권한 체크 (기존에 만드신 공통 권한 체크 활용)
        if (isNotAuthorized(session)) {
            mv.setViewName("redirect:/");
            return mv;
        }

        // 2. 등록 화면(Select 내 내보낼 옵션)에 필요한 부서/직급 리스트 조회 후 바구니에 담기
        mv.addObject("deptList", memlistService.selectDeptList());
        mv.addObject("posList", memlistService.selectPosList());
        
        // 3. 이동할 JSP 경로 지정 (memberListEnrollForm.jsp)
        mv.setViewName("member/insertForm");
        
        return mv;
    }

    /**
     * 6. 사원 등록 실행 (DB Insert)
     * XML 구문의 #{loginId}, #{loginPwd}, #{name} 등이 MemberList 객체 m에 자동 매핑됩니다.
     */
    @PostMapping("/insert")
    public String insertMember(MemberList m, HttpSession session, RedirectAttributes ra) {
        // 1. 권한 체크
        if (isNotAuthorized(session)) {
            return "redirect:/";
        }

        // 2. 서비스 호출하여 DB에 사원 정보 삽입
        int result = memlistService.insertMember(m);
        
        // 3. insert 성공(1 이상 리턴) 여부에 따른 알림창 메시지 세팅
        if (result > 0) {
            ra.addFlashAttribute("alertMsg", "새로운 사원이 성공적으로 등록되었습니다.");
        } else {
            ra.addFlashAttribute("alertMsg", "사원 등록에 실패했습니다.");
        }
        
        // 4. 등록이 끝나면 깔끔하게 사원 목록 페이지로 리다이렉트 이동
        return "redirect:/memberlist";
    }
    
    private String cleanXss(String value) {
        if(value == null) return null;

        return value.replaceAll("<", "&lt;")
                    .replaceAll(">", "&gt;")
                    .replaceAll("\"", "&quot;")
                    .replaceAll("'", "&#x27;");
    }
 
}