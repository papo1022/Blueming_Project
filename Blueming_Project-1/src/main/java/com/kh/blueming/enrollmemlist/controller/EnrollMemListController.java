package com.kh.blueming.enrollmemlist.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.kh.blueming.common.model.vo.PageInfo;
import com.kh.blueming.common.template.Pageination;
import com.kh.blueming.enrollmemlist.model.service.EnrollMemListService;

@Controller
@RequestMapping("/enrollment")
public class EnrollMemListController {

    @Autowired
    private EnrollMemListService emlService;

    // 1. [GET] 메뉴 클릭 시 전체 목록 조회
    @GetMapping("/enrollMemList")
    public ModelAndView enrollmentListGet(@RequestParam(value="cpage", defaultValue="1") int currentPage,
                                          ModelAndView mv) {
        
        int listCount = emlService.selectListCount();
        PageInfo pi = Pageination.getPageInfo(listCount, currentPage, 10, 10);
        
        ArrayList<Map<String, Object>> list = emlService.selectEnrollmentList(pi);
        
        mv.addObject("list", list)
          .addObject("pi", pi)
          .setViewName("enrollment/enrollMemList");
        return mv;
    }

    // 2. [POST] 검색 및 목록 내 페이징
    @PostMapping("/list")
    public ModelAndView enrollmentListPost(
            @RequestParam(value="condition", required=false) String condition,
            @RequestParam(value="keyword", required=false) String keyword,
            @RequestParam(value="sortCol", defaultValue="COURSE_ID") String sortCol,
            @RequestParam(value="sortOrder", defaultValue="DESC") String sortOrder,
            @RequestParam(value="cpage", defaultValue="1") int currentPage,
            ModelAndView mv) {
        
        HashMap<String, Object> map = new HashMap<>(); 
        map.put("condition", condition);
        map.put("keyword", keyword);
        map.put("sortCol", sortCol);
        map.put("sortOrder", sortOrder);
        
        int searchCount = emlService.selectSearchCount(map);
        PageInfo pi = Pageination.getPageInfo(searchCount, currentPage, 10, 10);
        
        ArrayList<Map<String, Object>> list = emlService.searchEnrollmentList(map, pi);
        
        mv.addObject("list", list)
          .addObject("pi", pi)
          .addObject("condition", condition)
          .addObject("keyword", keyword)
          .addObject("sortCol", sortCol)
          .addObject("sortOrder", sortOrder)
          .setViewName("enrollment/enrollMemList");
        
        return mv;
    }
    
    // 3. [GET/POST 통합] 상세 페이지 이동 (강의 클릭, 페이징, 정렬 시 호출)
    @RequestMapping(value = "/detail", method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView detail(
            @RequestParam("courseId") int courseId,
            @RequestParam(value="cpage", defaultValue="1") int currentPage,
            @RequestParam(value="sortCol", defaultValue="ENROLLMENT_ID") String sortCol,
            @RequestParam(value="sortOrder", defaultValue="DESC") String sortOrder,
            ModelAndView mv) {
        
        HashMap<String, Object> map = new HashMap<>();
        map.put("courseId", courseId);
        map.put("sortCol", sortCol);
        map.put("sortOrder", sortOrder);

        // 페이징 처리를 위한 총 수강생 수 조회
        int listCount = emlService.selectEnrollmentCountByCourse(courseId);
        PageInfo pi = Pageination.getPageInfo(listCount, currentPage, 10, 10);
        
        // 정렬 및 페이징이 적용된 목록 조회
        ArrayList<Map<String, Object>> enrollList = emlService.selectEnrollmentListByCourse(map, pi);
        
        mv.addObject("c", emlService.selectCourseDetail(courseId))
          .addObject("enrollList", enrollList)
          .addObject("pi", pi)
          .addObject("courseId", courseId)
          .addObject("sortCol", sortCol)
          .addObject("sortOrder", sortOrder)
          .setViewName("enrollment/enrollMemListDetail");
        
        return mv;
    }
}