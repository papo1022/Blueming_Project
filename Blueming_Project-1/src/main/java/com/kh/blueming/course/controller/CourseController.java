package com.kh.blueming.course.controller;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.kh.blueming.course.model.vo.Course;
import com.kh.blueming.course.service.CourseService;

@Controller
@RequestMapping("course")
public class CourseController {

    @Autowired
    private CourseService courseService;

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
    /*
    @GetMapping("detail")
    public ModelAndView selectCourse(@RequestParam("courseId") int courseId,
                                     ModelAndView mv) {
        Course course = courseService.selectCourse(courseId);

        Attatchment at = courseService.selectAttachment(courseId);

        mv.addObject("course", course)
          .setViewName("course/courseDetailView");
        return mv;
    }
    */
}
