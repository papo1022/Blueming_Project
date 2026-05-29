package com.kh.blueming.enrollmemlist.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
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

    // 1. [GET] 메뉴 클릭 시 초기 진입
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

    // 2. [POST] 검색 및 페이지 이동 시 (검색 정보 노출 방지)
    @PostMapping("/list")
    public ModelAndView enrollmentListPost(@RequestParam(value="condition", required=false) String condition,
                                           @RequestParam(value="keyword", required=false) String keyword,
                                           @RequestParam(value="cpage", defaultValue="1") int currentPage,
                                           ModelAndView mv) {
        
        HashMap<String, String> map = new HashMap<>();
        map.put("condition", condition);
        map.put("keyword", keyword);
        
        int searchCount = emlService.selectSearchCount(map);
        PageInfo pi = Pageination.getPageInfo(searchCount, currentPage, 10, 10);
        
        ArrayList<Map<String, Object>> list = emlService.searchEnrollmentList(map, pi);
        
        mv.addObject("list", list)
          .addObject("pi", pi)
          .addObject("condition", condition)
          .addObject("keyword", keyword)
          .setViewName("enrollment/enrollMemList");
        
        return mv;
    }
}