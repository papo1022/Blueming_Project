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

    /**
     * 1. 수강 정보 목록 조회
     * 🌟 [수정] JSP가 GET으로 전송하든 다른 메뉴바에서 POST로 넘어오든 무조건 허용하도록 멀티 매핑 설정
     */
    @RequestMapping(value = "/enrollMemList", method = {RequestMethod.GET, RequestMethod.POST})
    public String enrollmentList(
            @RequestParam(value="cpage", defaultValue="1") int currentPage,
            @RequestParam(value="condition", required=false) String condition,
            @RequestParam(value="keyword", required=false) String keyword,
            @RequestParam(value="sortCol", defaultValue="COURSE_ID") String sortCol,
            @RequestParam(value="sortOrder", defaultValue="DESC") String sortOrder,
            HttpSession session, Model model) {

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

    /**
     * 2. 수강 정보 상세 페이지 이동 및 수강생 관리
     * 🌟 [중요 수정] 상세페이지 내 페이징/정렬이 GET 방식으로 제출되므로, 
     * 최초 목록에서 진입할 때의 POST와 상세페이지 내부 정렬용 GET을 둘 다 허용하도록 변경합니다.
     */
    @RequestMapping(value = "/enrollMemDetail", method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView detail(
            @RequestParam("courseId") int courseId,
            @RequestParam(value="cpage", defaultValue="1") int listCpage, 
            @RequestParam(value="sortCol", defaultValue="DEPARTMENT_NAME") String sortCol,
            @RequestParam(value="sortOrder", defaultValue="ASC") String sortOrder,
            @RequestParam(value="listSortCol", required=false) String listSortCol,   
            @RequestParam(value="listSortOrder", required=false) String listSortOrder, 
            @RequestParam(value="deptFilter", defaultValue="") String deptFilter,
            @RequestParam(value="condition", required=false) String condition, 
            @RequestParam(value="keyword", required=false) String keyword,
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
        
        int listCount = emlService.selectEnrollmentCountByCourse(map);
        PageInfo pi = Pageination.getPageInfo(listCount, detailCpage, 10, 10);

        if(detailCpage > pi.getMaxPage() && pi.getMaxPage() > 0){
            detailCpage = 1;
            pi = Pageination.getPageInfo(listCount, detailCpage, 10, 10);
        }
        
        ArrayList<Map<String, Object>> enrollList = emlService.selectEnrollmentListByCourse(map, pi);
     
        mv.addObject("c", emlService.selectCourseDetail(courseId))
          .addObject("enrollList", enrollList)
          .addObject("pi", pi) 
          .addObject("courseId", courseId)
          .addObject("sortCol", sortCol)           
          .addObject("sortOrder", sortOrder)       
          .addObject("deptFilter", deptFilter)
          .addObject("deptList", emlService.selectDeptList())
          .addObject("cpage", listCpage) 
          .addObject("listCondition", condition) 
          .addObject("listKeyword", keyword)
          .addObject("listSortCol", listSortCol != null ? listSortCol : "COURSE_ID")       
          .addObject("listSortOrder", listSortOrder != null ? listSortOrder : "DESC");  
          
        mv.setViewName("enrollment/enrollMemListDetail");
        return mv;
    }
}