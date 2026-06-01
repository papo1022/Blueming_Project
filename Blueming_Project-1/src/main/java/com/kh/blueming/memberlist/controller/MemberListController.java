package com.kh.blueming.memberlist.controller;

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
import com.kh.blueming.memberlist.model.service.MemberListService;
import com.kh.blueming.memberlist.model.vo.MemberList;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/memberlist")
public class MemberListController {
    
    @Autowired
    private MemberListService memlistService;

    // 1. 목록 조회
    @GetMapping
    public String memberList(
            @RequestParam(value="cpage", defaultValue="1") int currentPage,
            @RequestParam(value="sortColumn", defaultValue="MEMBER_ID") String sortColumn,
            @RequestParam(value="sortOrder", defaultValue="DESC") String sortOrder,
            Model model) { // ModelAndView 대신 Model 사용 권장
        
        HashMap<String, String> map = new HashMap<>();
        map.put("sortColumn", sortColumn);
        map.put("sortOrder", sortOrder);
        
        int listCount = memlistService.selectListCount();
        PageInfo pi = Pageination.getPageInfo(listCount, currentPage, 10, 10);
        
        ArrayList<MemberList> list = memlistService.selectMemberList(pi, map); 
        
        model.addAttribute("list", list);
        model.addAttribute("pi", pi);
        model.addAttribute("sortColumn", sortColumn);
        model.addAttribute("sortOrder", sortOrder);
        
        return "member/memberListView";
    }

    // 2. 검색 기능
    @PostMapping("/search")
    public ModelAndView searchMemberList(@RequestParam(value="condition", required=false) String condition,
                                          @RequestParam(value="keyword", required=false) String keyword,
                                          @RequestParam(value="cpage", defaultValue="1") int currentPage,
                                          ModelAndView mv, HttpSession session) {
        
        session.setAttribute("accessTicket", "OK"); 

        HashMap<String, String> map = new HashMap<>();
        map.put("condition", condition);
        map.put("keyword", keyword);
        
        int searchCount = memlistService.selectSearchCount(map);
        PageInfo pi = Pageination.getPageInfo(searchCount, currentPage, 10, 10);
        ArrayList<MemberList> list = memlistService.searchMemberList(map, pi);
        
        mv.addObject("list", list).addObject("pi", pi).addObject("condition", condition)
          .addObject("keyword", keyword).setViewName("member/memberListView");
        return mv;
    }

    
 // 3. 상세 조회 (보안 제거)
    @RequestMapping(value = "/detail", method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView memberDetail(@RequestParam("memberId") int memberId, ModelAndView mv) {

        // 바로 서비스를 호출하여 데이터를 조회합니다.
        MemberList member = memlistService.selectMemberDetail(memberId);
        System.out.println("조회된 사원 객체: " + member);
        
        mv.addObject("member", member).setViewName("member/memberListDetail");
        return mv;
    }
    
 // 5. 수정 화면으로 이동
 // 수정: Get과 Post 둘 다 받을 수 있도록 설정
    @RequestMapping(value = "/updateForm", method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView updateForm(@RequestParam("memberId") int memberId, ModelAndView mv) {
        
        MemberList member = memlistService.selectMemberDetail(memberId);
        mv.addObject("member", member).setViewName("member/memberListUpdateForm");
        
        return mv;
    }
    
    @PostMapping("/update")
    public String updateMember(MemberList m, RedirectAttributes ra) {
        
        int result = memlistService.updateMember(m);
        
        if(result > 0) {
            ra.addFlashAttribute("alertMsg", "성공적으로 수정되었습니다.");
            return "redirect:/memberlist"; // 수정 성공 후 목록 페이지로 이동
        } else {
            ra.addFlashAttribute("alertMsg", "수정에 실패했습니다.");
            return "redirect:/memberlist";
        }
    }
    /*
 // 3. 보안 체크 로직 (타입 안전성 확보)
    private boolean isAccessAllowed(HttpSession session) {
        String ticket = (String) session.getAttribute("accessTicket");
        Object loginUser = session.getAttribute("loginUser"); // Object로 받아서 타입을 체크
        
        System.out.println("보안 티켓 확인: " + ticket);
        System.out.println("로그인 유저 객체: " + loginUser);
        
        if (ticket == null || loginUser == null) {
            return false;
        }

        // 로그인 유저의 role을 가져오기 위한 변수
        String role = null;

        // 1. 로그인 객체가 MemberList 타입인 경우
        if (loginUser instanceof com.kh.blueming.memberlist.model.vo.MemberList) {
            role = ((com.kh.blueming.memberlist.model.vo.MemberList) loginUser).getRole();
        } 
        // 2. 로그인 객체가 일반 Member 타입인 경우
        else if (loginUser instanceof com.kh.blueming.member.model.vo.Member) {
            role = ((com.kh.blueming.member.model.vo.Member) loginUser).getRole();
        }

        // 역할이 "A"(관리자)인지 확인
        return "R".equals(role);
    }

    // 4. 상세 조회
    @RequestMapping(value = "/detail", method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView memberDetail(@RequestParam("memberId") int memberId, 
                                     HttpSession session, ModelAndView mv) {

        // 보안 체크 통과 못하면 목록으로 튕겨냄
        if (!isAccessAllowed(session)) {
            System.out.println("보안 체크 실패! 목록으로 리다이렉트.");
            mv.setViewName("redirect:/memberlist");
            return mv;
        }
        
        // 티켓을 지우지 않습니다 (목록 버튼 클릭 시에도 필요하기 때문)
        MemberList member = memlistService.selectMemberDetail(memberId);
        System.out.println("조회된 사원 객체: " + member);
        
        mv.addObject("member", member).setViewName("member/memberListDetail");
        return mv;
    }*/
}