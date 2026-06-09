package com.kh.blueming.adminAssignment.controller;

import java.net.URLEncoder;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.blueming.adminAssignment.model.service.AdminAssignmentService;
import com.kh.blueming.adminAssignment.model.vo.AdminAssignment;
import com.kh.blueming.common.model.vo.PageInfo;
import com.kh.blueming.common.template.Pageination;

@Controller
@RequestMapping("/adminAssignment")
public class AdminAssignmentController {

    @Autowired
    private AdminAssignmentService adminAssignmentService;

    
    @GetMapping("/list")
    public String selectAssignmentList(

            @RequestParam(value="cpage", defaultValue="1")
            int currentPage,

            @RequestParam(value="condition", required=false)
            String condition,

            @RequestParam(value="keyword", required=false)
            String keyword,

            @RequestParam(value="sort", required=false)
            String sort,

            Model model) {

        HashMap<String, String> map = new HashMap<>();

        map.put("condition", condition);
        map.put("keyword", keyword);
        map.put("sort", sort);

        int listCount =
                adminAssignmentService.selectListCount(map);

        PageInfo pi =
                Pageination.getPageInfo(
                        listCount,
                        currentPage,
                        10,
                        10);

        ArrayList<AdminAssignment> list =
                adminAssignmentService.selectAssignmentList(
                        map,
                        pi);

        model.addAttribute("list", list);
        model.addAttribute("pi", pi);

        model.addAttribute("condition", condition);
        model.addAttribute("keyword", keyword);
        model.addAttribute("sort", sort);

        return "adminAssignment/assignmentList";
    }
    
    
    

    @GetMapping("/detail")
    public String selectAssignmentDetail(
            int memberId,
            int assignmentId,
            Model model) {

        AdminAssignment assignment =
                adminAssignmentService.selectAssignmentDetail(
                        memberId,
                        assignmentId);

        model.addAttribute("assignment", assignment);

        return "adminAssignment/assignmentDetail";
    }

    @PostMapping("/updateScore")
    public String updateScore(
            int submissionId,
            int score) {

        adminAssignmentService.updateScore(
                submissionId,
                score);

        return "redirect:/adminAssignment/list";
    }
    
    @GetMapping("/download")
    public ResponseEntity<Resource> downloadFile(int fileId)
    throws Exception {

        AdminAssignment file =
                adminAssignmentService.selectFile(fileId);

        Path path = Paths.get(
                file.getFilePath(),
                file.getChangedName());

        Resource resource =
                new UrlResource(path.toUri());

        return ResponseEntity.ok()
                .header(
                        HttpHeaders.CONTENT_DISPOSITION,
                        "attachment; filename=\"" +
                        URLEncoder.encode(
                                file.getOriginalName(),
                                "UTF-8") +
                        "\"")
                .body(resource);
    }
    
    
    
}