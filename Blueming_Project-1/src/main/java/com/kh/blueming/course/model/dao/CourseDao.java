package com.kh.blueming.course.model.dao;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.blueming.attachment.model.vo.Attachment;
import com.kh.blueming.chapter.model.vo.Chapter;
import com.kh.blueming.course.model.vo.Course;

@Repository
public class CourseDao {

    public ArrayList<Course> selectCourseList(SqlSessionTemplate sqlSession,
                                              int currentPage,
                                              int courseLimit,
                                              String keyword,
                                              String sort,
                                              String departmentId,
                                              String positionId,
                                              boolean isAdmin) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("keyword", keyword);
        map.put("sort", sort);
        map.put("departmentId", departmentId);
        map.put("positionId", positionId);
        map.put("isAdmin", isAdmin);

        int offset = (currentPage - 1) * courseLimit;
        RowBounds rowBounds = new RowBounds(offset, courseLimit);

        return (ArrayList) sqlSession.selectList("courseMapper.selectCourseList", map, rowBounds);
    }
    
    public Course selectCourse(SqlSessionTemplate sqlSession, int courseId) {
		return sqlSession.selectOne("courseMapper.selectCourse", courseId);
	}
    
    public Attachment selectAttachment(SqlSessionTemplate sqlSession, int courseId) {
    	return sqlSession.selectOne("courseMapper.selectAttachment", courseId);
	}
    
    public ArrayList<Chapter> selectChapterList(SqlSessionTemplate sqlSession, int courseId) {
    	return (ArrayList)sqlSession.selectList("courseMapper.selectChapterList", courseId);
	}
    
    public Chapter selectChapter(SqlSessionTemplate sqlSession, int chapterId) {
		return sqlSession.selectOne("courseMapper.selectChapter", chapterId);
	}

	public int addCourse(SqlSessionTemplate sqlSession, Course c) {
		return sqlSession.insert("courseMapper.addCourse", c);
	}

	public int nextOrder(SqlSessionTemplate sqlSession, int courseId) {
		return sqlSession.selectOne("courseMapper.nextOrder", courseId);
	}
	
	public int addChapter(SqlSessionTemplate sqlSession, Chapter ch) {
		return sqlSession.insert("courseMapper.addChapter", ch);
	}

	public int addAttachment(SqlSessionTemplate sqlSession, Attachment at) {
		return sqlSession.insert("courseMapper.addAttachment", at);
	}

	public int addChapterVideo(SqlSessionTemplate sqlSession, Chapter ch) {
		return sqlSession.insert("courseMapper.addChapterVideo", ch);
	}

	public int updateCourse(SqlSessionTemplate sqlSession, Course c) {
		return sqlSession.update("courseMapper.updateCourse", c);
	}

	public int deleteCourse(SqlSessionTemplate sqlSession, int courseId) {
		return sqlSession.update("courseMapper.deleteCourse", courseId);
	}

	public int deleteChapter(SqlSessionTemplate sqlSession, int courseId) {
		// TODO Auto-generated method stub
		return 0;
	}

}
