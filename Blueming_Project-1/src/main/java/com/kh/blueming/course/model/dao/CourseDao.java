package com.kh.blueming.course.model.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.blueming.attachment.model.vo.Attachment;
import com.kh.blueming.chapter.model.vo.Chapter;
import com.kh.blueming.chapter.model.vo.ChapterProgress;
import com.kh.blueming.course.model.vo.Course;

@Repository
public class CourseDao {

    public ArrayList<Course> selectCourseList(SqlSessionTemplate sqlSession,
                                              int currentPage,
                                              int courseLimit,
                                              String keyword,
                                              String sort,
											  Integer memberId,
                                              String departmentId,
                                              String positionId,
											  boolean isAdmin,
											  boolean mineOnly) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("keyword", keyword);
        map.put("sort", sort);
		map.put("memberId", memberId);
        map.put("departmentId", departmentId);
        map.put("positionId", positionId);
        map.put("isAdmin", isAdmin);
		map.put("mineOnly", mineOnly);

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

	public int insertCourseTarget(SqlSessionTemplate sqlSession, int courseId, String targetType, String targetValue) {
		Map<String, Object> map = new HashMap<>();
		map.put("courseId", courseId);
		map.put("targetType", targetType);
		map.put("targetValue", targetValue);
		return sqlSession.insert("courseMapper.insertCourseTarget", map);
	}

	public int insertEnrollmentByCourseTarget(SqlSessionTemplate sqlSession, int courseId, String targetType, String targetValue) {
		Map<String, Object> map = new HashMap<>();
		map.put("courseId", courseId);
		map.put("targetType", targetType);
		map.put("targetValue", targetValue);
		return sqlSession.insert("courseMapper.insertEnrollmentByCourseTarget", map);
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

	public int updateTotalHoursInMinutes(SqlSessionTemplate sqlSession, int courseId) {
		return sqlSession.update("courseMapper.updateTotalHoursInMinutes", courseId);
	}

	public int updateCourse(SqlSessionTemplate sqlSession, Course c) {
		return sqlSession.update("courseMapper.updateCourse", c);
	}

	public int deleteCourse(SqlSessionTemplate sqlSession, int courseId) {
		return sqlSession.delete("courseMapper.deleteCourse", courseId);
	}

	public int deleteAllChapter(SqlSessionTemplate sqlSession, int courseId) {
		return sqlSession.delete("courseMapper.deleteAllChapter", courseId);
	}

	public int deleteChapter(SqlSessionTemplate sqlSession, int chapterId) {
		return sqlSession.delete("courseMapper.deleteChapter", chapterId);
	}

	public int deleteAttachment(SqlSessionTemplate sqlSession, int videoFileId) {
		return sqlSession.delete("courseMapper.deleteAttachment", videoFileId);
	}

	public Attachment selectVideoAttachmentByChapterId(SqlSessionTemplate sqlSession, int chapterId) {
		return sqlSession.selectOne("courseMapper.selectVideoAttachmentByChapterId", chapterId);
	}

	public int selectEnrollmentId(SqlSessionTemplate sqlSession, int memberId, int courseId) {
		Map<String, Object> map = new HashMap<>();
		map.put("memberId", memberId);
		map.put("courseId", courseId);
		Integer result = sqlSession.selectOne("courseMapper.selectEnrollmentId", map);
		return result != null ? result : 0;
	}

	public ChapterProgress selectChapterProgress(SqlSessionTemplate sqlSession, int enrollmentId, int chapterId) {
		Map<String, Object> map = new HashMap<>();
		map.put("enrollmentId", enrollmentId);
		map.put("chapterId", chapterId);
		return sqlSession.selectOne("courseMapper.selectChapterProgress", map);
	}

	public int upsertChapterProgress(SqlSessionTemplate sqlSession, Map<String, Object> map) {
		return sqlSession.update("courseMapper.upsertChapterProgress", map);
	}

}
