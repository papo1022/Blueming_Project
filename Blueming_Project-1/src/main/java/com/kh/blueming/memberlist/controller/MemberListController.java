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

    // 2. 상세 조회
    @GetMapping("/detail")
    public ModelAndView memberDetail(@RequestParam("memberId") int memberId, HttpSession session, ModelAndView mv) {
        // 1. 권한 체크
        if (isNotAuthorized(session)) return new ModelAndView("redirect:/");
        
        // 2. 서비스 호출 시, 단순히 ID만 넘기지 말고 
        //    관리자가 조회 가능한 데이터인지 검증하는 로직을 서비스단에서 수행
        MemberList member = memlistService.selectMemberDetail(memberId);
        
        // 3. 존재하지 않는 사원이거나 관리 불가 사원일 경우 차단
        if (member == null) {
            session.setAttribute("alertMsg", "유효하지 않은 사원 정보입니다.");
            mv.setViewName("redirect:/memberlist");
            return mv;
        }
        
        mv.addObject("member", member).setViewName("member/memberListDetail");
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
    
 
}