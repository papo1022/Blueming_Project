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

 // 2. 상세 페이지 이동 (수정)
    @RequestMapping(value = "/detail", method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView detail(
            @RequestParam("courseId") int courseId,
            @RequestParam(value="cpage", defaultValue="1") int currentPage,
            @RequestParam(value="sortCol", defaultValue="ENROLLMENT_ID") String sortCol,
            @RequestParam(value="sortOrder", defaultValue="DESC") String sortOrder,
            @RequestParam(value="deptFilter", defaultValue="") String deptFilter, // 필터 파라미터 추가
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
        map.put("deptFilter", deptFilter); // map에 필터 추가

        // 부서 필터를 적용하여 카운트 조회 (중요: Service/DAO/Mapper도 수정 필요)
        int listCount = emlService.selectEnrollmentCountByCourse(map); 
        PageInfo pi = Pageination.getPageInfo(listCount, currentPage, 10, 10);
        
        // 특정 강의에 대한 수강생 목록 조회 (필터 및 정렬 조건 map 사용)
        ArrayList<Map<String, Object>> enrollList = emlService.selectEnrollmentListByCourse(map, pi);
        
        
        
        mv.addObject("c", emlService.selectCourseDetail(courseId))
          .addObject("enrollList", enrollList)
          .addObject("pi", pi)
          .addObject("courseId", courseId)
          .addObject("sortCol", sortCol)
          .addObject("sortOrder", sortOrder)
          .addObject("deptFilter", deptFilter) // JSP에서 선택 상태 유지용
          .addObject("deptList", emlService.selectDeptList())
          .setViewName("enrollment/enrollMemListDetail");
        
        return mv;
    }
    
    
}