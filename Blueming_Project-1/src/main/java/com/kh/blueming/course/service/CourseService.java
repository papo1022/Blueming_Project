package com.kh.blueming.course.service;

import java.util.ArrayList;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.blueming.course.dao.CourseDao;
import com.kh.blueming.course.model.vo.Course;

@Service
public class CourseService {

    @Autowired
    private SqlSessionTemplate sqlSession;

    @Autowired
    private CourseDao courseDao;

    public int selectListCount() {
        return courseDao.selectListCount(sqlSession);
    }

    public ArrayList<Course> selectCourseList(int currentPage, int courseLimit, String keyword, String sort) {
        return courseDao.selectCourseList(sqlSession, currentPage, courseLimit, keyword, sort);
    }
    
}
