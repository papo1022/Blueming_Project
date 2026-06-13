package com.kh.blueming.assignment.controller;

import java.net.MalformedURLException;
import java.net.URLEncoder;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.server.ResponseStatusException;

import com.kh.blueming.assignment.model.service.AdminAssignmentService;
import com.kh.blueming.assignment.model.vo.AdminAssignment;
import com.kh.blueming.common.model.vo.PageInfo;
import com.kh.blueming.common.template.Pageination;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/assignment/admin")
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

            @RequestParam(value="order", required=false)
            String order,   // ⭐⭐⭐ 이거 추가

            Model model) {

    	HashMap<String, String> map = new HashMap<>();

    	map.put("condition", condition);
    	map.put("keyword", keyword);
    	map.put("sort", sort);
    	map.put("order", order); 

        int listCount =
                adminAssignmentService.selectListCount(map);

        PageInfo pi =
                Pageination.getPageInfo(
                        listCount,
                        currentPage,
                        10,
                        10);

        ArrayList<AdminAssignment> list =
                adminAssignmentService.selectAssignmentList(map, pi);

        model.addAttribute("list", list);
        model.addAttribute("pi", pi);

        model.addAttribute("condition", condition);
        model.addAttribute("keyword", keyword);
        model.addAttribute("sort", sort);
        model.addAttribute("order", order); // ✨ [이 줄을 추가하세요!] JSP에서 ▲/▼ 표시 및 토글 링크 생성에 필요합니다.

        return "assignment/assignmentList";
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

        return "assignment/assignmentDetail";
    }

    @PostMapping("/updateScore")
    public String updateScore(
            @RequestParam int submissionId,
            @RequestParam(required = false) Integer score) {

        if(score == null){
            return "redirect:/assignment/admin/list";
        }

        adminAssignmentService.updateScore(submissionId, score);

        return "redirect:/assignment/admin/list";
    }
    
    
    
    @GetMapping("/download")
    public ResponseEntity<Resource> downloadFile(
            @RequestParam("submissionId") int submissionId,
            HttpServletRequest request) {

        AdminAssignment file =
                adminAssignmentService.selectFileBySubmissionId(submissionId);

        if (file == null
                || file.getFilePath() == null
                || file.getChangedName() == null
                || file.getOriginalName() == null) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    "첨부파일 정보를 찾을 수 없습니다.");
        }

                String storedPath = file.getFilePath().trim();
                Path path;
                Path storedAsPath = Paths.get(storedPath);
                if (storedAsPath.isAbsolute()) {
                        path = storedAsPath.resolve(file.getChangedName()).normalize();
                } else {
                        String webPath = storedPath.startsWith("/") ? storedPath : "/" + storedPath;
                        String realDir = request.getServletContext().getRealPath(webPath);

                        if (realDir != null && !realDir.isBlank()) {
                                path = Paths.get(realDir).resolve(file.getChangedName()).normalize();
                        } else {
                                path = Paths.get(storedPath).resolve(file.getChangedName()).normalize();
                        }
                }

        Resource resource;
        try {
            resource = new UrlResource(path.toUri());
        } catch (MalformedURLException e) {
            throw new ResponseStatusException(
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "첨부파일 경로 처리 중 오류가 발생했습니다.",
                    e);
        }

        if (!resource.exists() || !resource.isReadable()) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    "첨부파일을 찾을 수 없습니다.");
        }

        String encodedName = URLEncoder.encode(
                file.getOriginalName(),
                StandardCharsets.UTF_8).replace("+", "%20");

        return ResponseEntity.ok()
                .header(
                        HttpHeaders.CONTENT_DISPOSITION,
                        "attachment; filename*=UTF-8''" + encodedName)
                .body(resource);
    }
    
    
    
}