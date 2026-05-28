package com.kh.blueming.course.model.service;

import java.util.ArrayList;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.blueming.attachment.model.vo.Attachment;
import com.kh.blueming.course.model.dao.CourseDao;
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
    
	public Course selectCourse(int courseId) {
		return courseDao.selectCourse(sqlSession, courseId);
	}
	
	public Attachment selectAttachment(int courseId) {
		return courseDao.selectAttachment(sqlSession, courseId);
	}
	
	@Transactional
	public int addCourse(Course c) {
		return courseDao.addCourse(sqlSession, c);
	}
    
}
