package com.kh.blueming.enrollmemlist.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.kh.blueming.common.model.vo.PageInfo;
import com.kh.blueming.common.template.Pageination;
import com.kh.blueming.enrollmemlist.model.service.EnrollMemListService;
import com.kh.blueming.member.model.vo.Member;

@Controller
@RequestMapping("/enrollment")
public class EnrollMemListController {

    @Autowired
    private EnrollMemListService emlService;

    // 공통 권한 체크 로직
    private boolean isNotAuthorized(HttpSession session) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        return loginUser == null || !"R".equals(loginUser.getRole());
    }

    // 1. 목록 조회
    @RequestMapping(value = "/enrollMemList", method = {RequestMethod.GET, RequestMethod.POST})
    public String enrollmentList(
    		@RequestParam(value="cpage", defaultValue="1") int currentPage,
            @RequestParam(value="condition", required=false) String condition,
            @RequestParam(value="keyword", required=false) String keyword,
            @RequestParam(value="sortCol", defaultValue="COURSE_ID") String sortCol,
            @RequestParam(value="sortOrder", defaultValue="DESC") String sortOrder,
            @RequestParam(value="fromDetail", defaultValue="N") String fromDetail, // 🌟 토큰 수신 추가
            HttpSession session, Model model) {

        // 1. 상세페이지에서 [목록으로]를 통해 들어온 '진짜 첫 번째 요청'인 경우
        if ("Y".equals(fromDetail)) {
            // 유저가 가려던 진짜 페이지와 검색 상태를 세션에 안전하게 박제합니다.
            session.setAttribute("bakedCpage", currentPage);
            session.setAttribute("bakedCondition", condition);
            session.setAttribute("bakedKeyword", keyword);
            session.setAttribute("bakedSortCol", sortCol);
            session.setAttribute("bakedSortOrder", sortOrder);
            // 무한 루프 방지를 위해 다음 가짜 요청이 올 때까지 대기하도록 변수 설정
            session.setAttribute("lockTrigger", "ON");
        } 
        
        // 2. 직후에 깨진 리소스로 인해 fromDetail 토큰 없이 들어온 '가짜 중복 요청'인 경우
        else if ("N".equals(fromDetail) 
                 && "ON".equals(session.getAttribute("lockTrigger")) 
                 && session.getAttribute("bakedCpage") != null) {
            
            // 깡통 파라미터들을 무시하고, 박제해 두었던 진짜 데이터로 강제 덮어씁니다.
            currentPage = (int) session.getAttribute("bakedCpage");
            condition = (String) session.getAttribute("bakedCondition");
            keyword = (String) session.getAttribute("bakedKeyword");
            sortCol = (String) session.getAttribute("bakedSortCol");
            sortOrder = (String) session.getAttribute("bakedSortOrder");
            
            // 가짜 요청 처리가 끝났으므로 방어벽 임시 해제
            session.removeAttribute("lockTrigger");
            
         
        }

      
        
        
        if (isNotAuthorized(session)) {
            session.setAttribute("alertMsg", "접근 권한이 없습니다.");
            return "redirect:/";
        }

        HashMap<String, Object> map = new HashMap<>(); 
        map.put("condition", condition);
        map.put("keyword", keyword);
        map.put("sortCol", sortCol);
        map.put("sortOrder", sortOrder);
        
        boolean isSearch = (keyword != null && !keyword.trim().isEmpty());
        int listCount = isSearch ? emlService.selectSearchCount(map) : emlService.selectListCount();

        PageInfo pi = Pageination.getPageInfo(listCount, currentPage, 10, 10);
        
        // 정렬 조건이 포함된 map을 서비스에 전달
        ArrayList<Map<String, Object>> list = isSearch ? emlService.searchEnrollmentList(map, pi) 
                                                       : emlService.selectEnrollmentList(map, pi);
        
        model.addAttribute("list", list)
             .addAttribute("pi", pi)
             .addAttribute("condition", condition)
             .addAttribute("keyword", keyword)
             .addAttribute("sortCol", sortCol)
             .addAttribute("sortOrder", sortOrder);
             
        return "enrollment/enrollMemList";
    }

 // 2. 상세 페이지 이동 (수정 완료 버전)
    @RequestMapping(value = "/enrollMemDetail", method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView detail(
            @RequestParam("courseId") int courseId,
            @RequestParam(value="cpage", defaultValue="1") int listCpage, // 🌟 이름을 listCpage로 변경하여 목록의 페이지를 온전히 보존합니다.
            @RequestParam(value="sortCol", defaultValue="DEPARTMENT_NAME") String sortCol,
            @RequestParam(value="sortOrder", defaultValue="ASC") String sortOrder,
            @RequestParam(value="deptFilter", defaultValue="") String deptFilter,
            @RequestParam(value="condition", required=false) String condition, 
            @RequestParam(value="keyword", required=false) String keyword,
            // 🌟 상세페이지 내부의 수강생 목록 전용 페이징 번호를 따로 받습니다. (기본값 1)
            @RequestParam(value="detailCpage", defaultValue="1") int detailCpage, 
            HttpSession session, ModelAndView mv) {

        if (isNotAuthorized(session)) {
            session.setAttribute("alertMsg", "접근 권한이 없습니다.");
            mv.setViewName("redirect:/");
            return mv;
        }
        
        HashMap<String, Object> map = new HashMap<>();
        map.put("courseId", courseId);
        map.put("sortCol", sortCol);
        map.put("sortOrder", sortOrder);
        map.put("deptFilter", deptFilter);
        
        // 수강생 총원 계산 및 페이징 객체 생성 (목록의 페이지가 아니라 detailCpage를 넣어야 합니다!)
        int listCount = emlService.selectEnrollmentCountByCourse(map);
        PageInfo pi = Pageination.getPageInfo(listCount, detailCpage, 10, 10);

        if(detailCpage > pi.getMaxPage() && pi.getMaxPage() > 0){
            detailCpage = 1;
            pi = Pageination.getPageInfo(listCount, detailCpage, 10, 10);
        }
        
        ArrayList<Map<String, Object>> enrollList = emlService.selectEnrollmentListByCourse(map, pi);
     
        mv.addObject("c", emlService.selectCourseDetail(courseId))
          .addObject("enrollList", enrollList)
          .addObject("pi", pi) // 상세 페이지 내부 수강생용 페이징 정보
          .addObject("courseId", courseId)
          .addObject("sortCol", sortCol)           
          .addObject("sortOrder", sortOrder)       
          .addObject("deptFilter", deptFilter)
          .addObject("deptList", emlService.selectDeptList())
          
          // 🌟 [핵심 변경] 온전하게 살아남은 목록의 원래 페이지 번호(listCpage)를 그대로 넘겨줍니다!
          .addObject("cpage", listCpage) 
          
          .addObject("listCondition", condition) 
          .addObject("listKeyword", keyword)
          .addObject("listSortCol", sortCol)       
          .addObject("listSortOrder", sortOrder);  
          
        mv.setViewName("enrollment/enrollMemListDetail");
        return mv;
    }
    
    
}