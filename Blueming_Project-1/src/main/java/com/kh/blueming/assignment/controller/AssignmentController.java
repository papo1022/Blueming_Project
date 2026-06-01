package com.kh.blueming.assignment.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.kh.blueming.assignment.model.service.AssignmentService;
import com.kh.blueming.assignment.model.vo.Assignment;
import com.kh.blueming.common.template.XssDefencePolicy;
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
        String departmentId = (loginUser != null) ? loginUser.getDepartmentId() : null;
        String positionId = (loginUser != null) ? loginUser.getPositionId() : null;
        boolean isAdmin = loginUser != null && "S".equals(loginUser.getRole());

        return assignmentService.selectAssignmentList(currentPage,
                                                      assignmentLimit,
                                                      keyword,
                                                      targetType,
                                                      memberId,
                                                      departmentId,
                                  positionId,
                                  isAdmin);
    }

    @ResponseBody
    @PostMapping("submit")
    public Map<String, Object> submitAssignment(@RequestParam("assignmentId") int assignmentId,
                                                @RequestParam("content") String content,
                                                @RequestParam(value = "upfile", required = false) MultipartFile upfile,
                                                HttpSession session) {
        Map<String, Object> resultMap = new HashMap<>();

        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser == null) {
            resultMap.put("success", false);
            resultMap.put("message", "로그인이 필요합니다.");
            return resultMap;
        }

        if (assignmentId < 1) {
            resultMap.put("success", false);
            resultMap.put("message", "유효하지 않은 과제입니다.");
            return resultMap;
        }

        String safeContent = XssDefencePolicy.defence(content);
        int memberId = loginUser.getMemberId();

        int result = assignmentService.submitAssignment(assignmentId, memberId, safeContent, upfile, session);

        if (result > 0) {
            resultMap.put("success", true);
            resultMap.put("message", "과제가 제출되었습니다.");
        } else {
            resultMap.put("success", false);
            resultMap.put("message", "과제 제출에 실패했습니다.");
        }

        return resultMap;
    }
}
