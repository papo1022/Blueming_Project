package com.kh.blueming.course.model.service;

import java.util.ArrayList;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.blueming.attachment.model.vo.Attachment;
import com.kh.blueming.chapter.model.vo.Chapter;
import com.kh.blueming.course.model.dao.CourseDao;
import com.kh.blueming.course.model.vo.Course;

@Service
public class CourseService {

    @Autowired
    private SqlSessionTemplate sqlSession;

    @Autowired
    private CourseDao courseDao;
    
	public ArrayList<Course> selectCourseList(int currentPage,
											  int courseLimit,
											  String keyword,
											  String sort,
											  String departmentId,
											  String positionId,
											  boolean isAdmin) {
		return courseDao.selectCourseList(sqlSession,
										  currentPage,
										  courseLimit,
										  keyword,
										  sort,
										  departmentId,
										  positionId,
										  isAdmin);
    }
    
    
	public Course selectCourse(int courseId) {
		return courseDao.selectCourse(sqlSession, courseId);
	}
	
	public Attachment selectAttachment(int courseId) {
		return courseDao.selectAttachment(sqlSession, courseId);
	}
	
	public ArrayList<Chapter> selectChapterList(int courseId) {
		return courseDao.selectChapterList(sqlSession, courseId);
	}
	
	public Chapter selectChapter(int chapterId) {
		return courseDao.selectChapter(sqlSession, chapterId);
	}
	
	@Transactional
	public int addCourse(Course c) {
		return courseDao.addCourse(sqlSession, c);
	}

	public int nextOrder(int courseId) {
		return courseDao.nextOrder(sqlSession, courseId);
	}

	@Transactional
	public int addChapter(Chapter ch, Attachment at, int cnt) {
		
		int result1 = 1;
		int result2 = 0;
		int result3 = 0;
		if(cnt > 0) {
			result1 = courseDao.addAttachment(sqlSession, at);
			ch.setVideoFileId(at.getFileId());
			result2 = courseDao.addChapterVideo(sqlSession, ch);
		} else {
			result2 = courseDao.addChapter(sqlSession, ch);
		}
		if (result1 > 0 && result2 > 0) {
			result3 = courseDao.updateTotalHoursInMinutes(sqlSession, ch.getCourseId());
		}
		
		return result1 * result2 * result3;
	}

	@Transactional
	public int updateCourse(Course c) {
		return courseDao.updateCourse(sqlSession, c);
	}

	@Transactional
	public int deleteCourse(int courseId) {
		
		ArrayList<Chapter> chapterList = courseDao.selectChapterList(sqlSession, courseId);
		
		int result1 = 1;
		
		int result2 = courseDao.deleteAllChapter(sqlSession, courseId);
		
		for(Chapter ch : chapterList) {
			if(ch.getVideoFileId() > 0) {
				result1 *= courseDao.deleteAttachment(sqlSession, ch.getVideoFileId());
			}
		}
		
		int result3 = courseDao.deleteCourse(sqlSession, courseId);
		
		return result1 * result2 * result3;
		
	}
	
	@Transactional
	public int deleteChapter(int chapterId) {
		Chapter ch = courseDao.selectChapter(sqlSession, chapterId);
		
		int result1 = 1;
		
		int result2 = courseDao.deleteChapter(sqlSession, chapterId);
		
		if(ch.getVideoFileId() > 0) {
			result1 = courseDao.deleteAttachment(sqlSession, ch.getVideoFileId());
		}
		
		return result1 * result2;
	}
}
