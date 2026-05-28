package com.kh.blueming.assignment.controller;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.kh.blueming.assignment.model.service.AssignmentService;
import com.kh.blueming.assignment.model.vo.Assignment;
import com.kh.blueming.member.model.vo.Member;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("assignment")
public class AssignmentController {

    @Autowired
    private AssignmentService assignmentService;

    @GetMapping("list")
    public ModelAndView selectAssignmentList(@RequestParam(value = "keyword", required = false) String keyword,
                                         @RequestParam(value = "targetType", defaultValue = "cName") String targetType,
                                         ModelAndView mv) {
        if (!"deadline".equals(targetType)) {
                targetType = "cName";
        }

        mv.addObject("keyword", keyword)
          .addObject("targetType", targetType)
          .setViewName("assignment/assignmentListView");

        return mv;
    }

    @ResponseBody
    @GetMapping("ajaxList")
    public ArrayList<Assignment> ajaxSelectAssignmentList(
            @RequestParam(value = "page", defaultValue = "1") int currentPage,
            @RequestParam(value = "limit", defaultValue = "8") int assignmentLimit,
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "targetType", defaultValue = "cName") String targetType,
            HttpSession session) {

        if (currentPage < 1) {
            currentPage = 1;
        }

        if (assignmentLimit < 1) {
            assignmentLimit = 8;
        }

        if (!"deadline".equals(targetType)) {
            targetType = "cName";
        }

        Member loginUser = (Member) session.getAttribute("loginUser");
        Integer memberId = (loginUser != null) ? loginUser.getMemberId() : null;

        return assignmentService.selectAssignmentList(currentPage, assignmentLimit, keyword, targetType, memberId);
    }
}
