package com.kh.blueming.assignment.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
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
import com.kh.blueming.course.model.service.CourseService;
import com.kh.blueming.course.model.vo.Course;
import com.kh.blueming.chapter.model.vo.Chapter;
import com.kh.blueming.member.model.vo.Member;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("assignment")
public class AssignmentController {

    @Autowired
    private AssignmentService assignmentService;

    @Autowired
    private CourseService courseService;

    private boolean canManageCourse(Member loginUser, Course course) {
        return loginUser != null
            && course != null
            && ("S".equals(loginUser.getRole()) || loginUser.getMemberId() == course.getMemberId());
    }

    private String validateAssignmentInput(Assignment assignment) {
        if (assignment == null) {
            return "잘못된 요청입니다.";
        }

        if (assignment.getAssignmentTitle() == null || assignment.getAssignmentTitle().trim().isEmpty()) {
            return "과제명을 입력해주세요.";
        }

        if (assignment.getStartDate() == null) {
            return "시작일을 입력해주세요.";
        }

        if (assignment.getDueDate() == null) {
            return "마감일을 입력해주세요.";
        }

        if (assignment.getDueDate().before(assignment.getStartDate())) {
            return "마감일은 시작일보다 빠를 수 없습니다.";
        }

        if (assignment.getMaxScore() <= 0) {
            return "만점은 1 이상 입력해주세요.";
        }

        return null;
    }

    @GetMapping("list")
    public ModelAndView selectAssignmentList(@RequestParam(value = "keyword", required = false) String keyword,
                                            @RequestParam(value = "targetType", defaultValue = "cName") String targetType,
                                            @RequestParam(value = "mineOnly", defaultValue = "false") boolean mineOnly,
                                            ModelAndView mv) {
        if (!"deadline".equals(targetType)) {
                targetType = "cName";
        }

        mv.addObject("keyword", keyword)
          .addObject("targetType", targetType)
          .addObject("mineOnly", mineOnly)
          .setViewName("assignment/assignmentListView");

        return mv;
    }

    @GetMapping("addView")
    public ModelAndView addAssignmentView(@RequestParam("chapterId") int chapterId, ModelAndView mv, HttpSession session) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        Chapter chapter = courseService.selectChapter(chapterId);
        Course course = chapter == null ? null : courseService.selectCourse(chapter.getCourseId());

        if (!canManageCourse(loginUser, course)) {
            mv.addObject("errorMsg", "과제를 등록할 권한이 없습니다.")
              .setViewName("common/errorPage");
            return mv;
        }

        mv.addObject("chapter", chapter)
          .setViewName("assignment/assignmentAdd");

        return mv;
    }

    @GetMapping("updateView")
    public ModelAndView updateAssignmentView(@RequestParam("assignmentId") int assignmentId, ModelAndView mv, HttpSession session) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        Assignment assignment = assignmentService.selectAssignment(assignmentId);
        if (assignment == null) {
                mv.addObject("errorMsg", "존재하지 않는 과제입니다.")
                    .setViewName("common/errorPage");
                return mv;
        }

        Chapter chapter = courseService.selectChapter(assignment.getChapterId());
        Course course = chapter == null ? null : courseService.selectCourse(chapter.getCourseId());

        if (!canManageCourse(loginUser, course)) {
                mv.addObject("errorMsg", "과제를 수정할 권한이 없습니다.")
                    .setViewName("common/errorPage");
                return mv;
        }

        mv.addObject("assignment", assignment)
        .addObject("chapter", chapter)
        .setViewName("assignment/assignmentUpdate");

        return mv;
    }

    @PostMapping("add")
    public String addAssignment(Assignment assignment, BindingResult bindingResult, Model model, HttpSession session) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser == null) {
            model.addAttribute("errorMsg", "로그인이 필요합니다.");
            return "common/errorPage";
        }

        if (bindingResult.hasErrors()) {
            int chapterId = assignment != null ? assignment.getChapterId() : 0;
            if (chapterId > 0) {
                session.setAttribute("alertMsg", "필수 항목을 모두 입력해주세요.");
                return "redirect:/assignment/addView?chapterId=" + chapterId;
            }

            model.addAttribute("errorMsg", "요청 값이 올바르지 않습니다.");
            return "common/errorPage";
        }

        Chapter chapter = courseService.selectChapter(assignment.getChapterId());
        if (chapter == null) {
            model.addAttribute("errorMsg", "존재하지 않는 챕터입니다.");
            return "common/errorPage";
        }

        Course course = courseService.selectCourse(chapter.getCourseId());
        if (!canManageCourse(loginUser, course)) {
            model.addAttribute("errorMsg", "과제를 등록할 권한이 없습니다.");
            return "common/errorPage";
        }

        String validationMessage = validateAssignmentInput(assignment);
        if (validationMessage != null) {
            session.setAttribute("alertMsg", validationMessage);
            return "redirect:/assignment/addView?chapterId=" + chapter.getChapterId();
        }

        assignment.setCourseId(chapter.getCourseId());
        assignment.setAssignmentTitle(XssDefencePolicy.defence(assignment.getAssignmentTitle()));
        assignment.setDescription(XssDefencePolicy.defence(assignment.getDescription()));

        int result = assignmentService.insertAssignment(assignment);
        if (result > 0) {
            session.setAttribute("alertMsg", "과제 등록 완료");
            return "redirect:/course/chapterDetailView?chapterId=" + assignment.getChapterId();
        }

        model.addAttribute("errorMsg", "과제 등록에 실패했습니다.");
        return "common/errorPage";
    }

    @PostMapping("update")
    public String updateAssignment(Assignment assignment, BindingResult bindingResult, Model model, HttpSession session) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser == null) {
            model.addAttribute("errorMsg", "로그인이 필요합니다.");
            return "common/errorPage";
        }

        if (bindingResult.hasErrors()) {
            int assignmentId = assignment != null ? assignment.getAssignmentId() : 0;
            if (assignmentId > 0) {
                session.setAttribute("alertMsg", "필수 항목을 모두 입력해주세요.");
                return "redirect:/assignment/updateView?assignmentId=" + assignmentId;
            }

            model.addAttribute("errorMsg", "요청 값이 올바르지 않습니다.");
            return "common/errorPage";
        }

        Assignment origin = assignmentService.selectAssignment(assignment.getAssignmentId());
        if (origin == null) {
            model.addAttribute("errorMsg", "존재하지 않는 과제입니다.");
            return "common/errorPage";
        }

        Chapter chapter = courseService.selectChapter(origin.getChapterId());
        Course course = chapter == null ? null : courseService.selectCourse(chapter.getCourseId());
        if (!canManageCourse(loginUser, course)) {
            model.addAttribute("errorMsg", "과제를 수정할 권한이 없습니다.");
            return "common/errorPage";
        }

        String validationMessage = validateAssignmentInput(assignment);
        if (validationMessage != null) {
            session.setAttribute("alertMsg", validationMessage);
            return "redirect:/assignment/updateView?assignmentId=" + origin.getAssignmentId();
        }

        assignment.setChapterId(origin.getChapterId());
        assignment.setCourseId(origin.getCourseId());
        assignment.setAssignmentTitle(XssDefencePolicy.defence(assignment.getAssignmentTitle()));
        assignment.setDescription(XssDefencePolicy.defence(assignment.getDescription()));

        int result = assignmentService.updateAssignment(assignment);
        if (result > 0) {
            session.setAttribute("alertMsg", "과제 수정 완료");
            return "redirect:/course/chapterDetailView?chapterId=" + origin.getChapterId();
        }

        model.addAttribute("errorMsg", "과제 수정에 실패했습니다.");
        return "common/errorPage";
    }

    @PostMapping("delete")
    public String deleteAssignment(@RequestParam("assignmentId") int assignmentId,
                                   @RequestParam("chapterId") int chapterId,
                                   Model model,
                                   HttpSession session) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser == null) {
            model.addAttribute("errorMsg", "로그인이 필요합니다.");
            return "common/errorPage";
        }

        Chapter chapter = courseService.selectChapter(chapterId);
        Course course = chapter == null ? null : courseService.selectCourse(chapter.getCourseId());
        if (!canManageCourse(loginUser, course)) {
            model.addAttribute("errorMsg", "과제를 삭제할 권한이 없습니다.");
            return "common/errorPage";
        }

        int result = assignmentService.deleteAssignment(assignmentId);
        if (result > 0) {
            session.setAttribute("alertMsg", "과제 삭제 완료");
            return "redirect:/course/chapterDetailView?chapterId=" + chapterId;
        }

        model.addAttribute("errorMsg", "과제 삭제에 실패했습니다.");
        return "common/errorPage";
    }

    @ResponseBody
    @GetMapping("ajaxList")
    public ArrayList<Assignment> ajaxSelectAssignmentList(
            @RequestParam(value = "page", defaultValue = "1") int currentPage,
            @RequestParam(value = "limit", defaultValue = "8") int assignmentLimit,
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "targetType", defaultValue = "cName") String targetType,
            @RequestParam(value = "mineOnly", defaultValue = "false") boolean mineOnly,
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
        boolean mineOnlyFilter = mineOnly && loginUser != null;

        return assignmentService.selectAssignmentList(currentPage,
                                                      assignmentLimit,
                                                      keyword,
                                                      targetType,
                                                      memberId,
                                                      departmentId,
                                                      positionId,
                                                      isAdmin,
                                                      mineOnlyFilter);
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
