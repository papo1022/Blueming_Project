package com.kh.blueming.course.controller;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.kh.blueming.attachment.model.vo.Attachment;
import com.kh.blueming.course.model.service.CourseService;
import com.kh.blueming.course.model.vo.Course;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("course")
public class CourseController {

    @Autowired
    private CourseService courseService;
    
    //리스트들을 띄우는 코드
    @GetMapping("list")
    public ModelAndView selectCourseList(@RequestParam(value = "keyword", required = false) String keyword,
                                         @RequestParam(value = "sort", defaultValue = "latest") String sort,
                                         ModelAndView mv) {
        if (!"oldest".equals(sort)) {
                sort = "latest";
        }

        mv.addObject("keyword", keyword)
          .addObject("sort", sort)
          .setViewName("course/courseListView");

        return mv;
    }

    //ajax를 이용한 카드형 표기
    @ResponseBody
    @GetMapping("ajaxList")
    public ArrayList<Course> ajaxSelectCourseList(
            @RequestParam(value = "page", defaultValue = "1") int currentPage,
            @RequestParam(value = "limit", defaultValue = "4") int courseLimit,
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "sort", defaultValue = "latest") String sort) {

        if (currentPage < 1) {
            currentPage = 1;
        }

        if (courseLimit < 1) {
            courseLimit = 4;
        }

        if (!"oldest".equals(sort)) {
            sort = "latest";
        }

        return courseService.selectCourseList(currentPage, courseLimit, keyword, sort);
    }
    
    //카드를 누르면 상세설명 페이지로 이동
    @GetMapping("detail")
    public ModelAndView selectCourse(@RequestParam("courseId") int courseId,
                                     ModelAndView mv) {
    	
        Course course = courseService.selectCourse(courseId);

        mv.addObject("course", course)
        	.setViewName("course/courseDetailView");
        return mv;
    }
    
    //코스 추가 페이지로 이동
    @GetMapping("addCourseView")
    public String addForm() {
    	return "course/courseAdd";
    }
    
    //챕터 추가 페이지로 이동
    @GetMapping("addChapterView")
    public ModelAndView addChapterForm(int courseId, ModelAndView mv) {
    	mv.addObject("courseId", courseId)
    	  .setViewName("course/chapterAdd");
    	return mv;
    }
    
    //코스를 데이터베이스에 추가하는 코드
    @PostMapping("addCourse")
    public String addCourse(Course c, Model model, HttpSession session) {
    	
    	int result = courseService.addCourse(c);
    	
    	if(result > 0) {
			session.setAttribute("alertMsg", "강의 등록 완료");
			return "redirect:/course/list";
		} else {
			model.addAttribute("errorMsg", "등록에 실패했습니다.");
			return "common/errorPage";
		}
    }
}
