package com.kh.blueming.assignment.model.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.blueming.attachment.model.vo.Attachment;
import com.kh.blueming.assignment.model.vo.Assignment;

@Repository
public class AssignmentDao {

    public ArrayList<Assignment> selectAssignmentList(SqlSessionTemplate sqlSession,
                                              int currentPage,
                                              int assignmentLimit,
                                              String keyword,
                                              String targetType,
                                              Integer memberId,
                                              String departmentId,
                                              String positionId,
                                              boolean isAdmin,
                                              boolean mineOnly) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("keyword", keyword);
        map.put("targetType", targetType);
        map.put("memberId", memberId);
        map.put("departmentId", departmentId);
        map.put("positionId", positionId);
        map.put("isAdmin", isAdmin);
        map.put("mineOnly", mineOnly);

        int offset = (currentPage - 1) * assignmentLimit;
        RowBounds rowBounds = new RowBounds(offset, assignmentLimit);

        return (ArrayList) sqlSession.selectList("assignmentMapper.selectAssignmentList", map, rowBounds);
    }

    public ArrayList<Assignment> selectAssignmentListByChapterId(SqlSessionTemplate sqlSession, int chapterId) {
        return (ArrayList) sqlSession.selectList("assignmentMapper.selectAssignmentListByChapterId", chapterId);
    }

    public Assignment selectAssignment(SqlSessionTemplate sqlSession, int assignmentId) {
        return sqlSession.selectOne("assignmentMapper.selectAssignment", assignmentId);
    }

    public int insertAssignment(SqlSessionTemplate sqlSession, Assignment assignment) {
        return sqlSession.insert("assignmentMapper.insertAssignment", assignment);
    }

    public int updateAssignment(SqlSessionTemplate sqlSession, Assignment assignment) {
        return sqlSession.update("assignmentMapper.updateAssignment", assignment);
    }

    public int deleteAssignment(SqlSessionTemplate sqlSession, int assignmentId) {
        return sqlSession.delete("assignmentMapper.deleteAssignment", assignmentId);
    }

    public int deleteAssignmentSubmissionByAssignmentId(SqlSessionTemplate sqlSession, int assignmentId) {
        return sqlSession.delete("assignmentMapper.deleteAssignmentSubmissionByAssignmentId", assignmentId);
    }

    public int deleteAssignmentSubmissionByChapterId(SqlSessionTemplate sqlSession, int chapterId) {
        return sqlSession.delete("assignmentMapper.deleteAssignmentSubmissionByChapterId", chapterId);
    }

    public int deleteAssignmentByChapterId(SqlSessionTemplate sqlSession, int chapterId) {
        return sqlSession.delete("assignmentMapper.deleteAssignmentByChapterId", chapterId);
    }

    public int deleteAssignmentSubmissionByCourseId(SqlSessionTemplate sqlSession, int courseId) {
        return sqlSession.delete("assignmentMapper.deleteAssignmentSubmissionByCourseId", courseId);
    }

    public int deleteAssignmentByCourseId(SqlSessionTemplate sqlSession, int courseId) {
        return sqlSession.delete("assignmentMapper.deleteAssignmentByCourseId", courseId);
    }

    public int insertAttachment(SqlSessionTemplate sqlSession, Attachment attachment) {
        return sqlSession.insert("assignmentMapper.insertAttachment", attachment);
    }

    public Assignment selectLatestSubmissionInfo(SqlSessionTemplate sqlSession, Map<String, Object> paramMap) {
        return sqlSession.selectOne("assignmentMapper.selectLatestSubmissionInfo", paramMap);
    }

    public Attachment selectAttachmentByFileId(SqlSessionTemplate sqlSession, int fileId) {
        return sqlSession.selectOne("assignmentMapper.selectAttachmentByFileId", fileId);
    }

    public int updateAttachmentStatusToN(SqlSessionTemplate sqlSession, int fileId) {
        return sqlSession.update("assignmentMapper.updateAttachmentStatusToN", fileId);
    }

    public int deleteAttachment(SqlSessionTemplate sqlSession, int fileId) {
        return sqlSession.delete("assignmentMapper.deleteAttachment", fileId);
    }

    public int insertAssignmentSubmission(SqlSessionTemplate sqlSession, Map<String, Object> paramMap) {
        return sqlSession.insert("assignmentMapper.insertAssignmentSubmission", paramMap);
    }

    public int updateAssignmentSubmission(SqlSessionTemplate sqlSession, Map<String, Object> paramMap) {
        return sqlSession.update("assignmentMapper.updateAssignmentSubmission", paramMap);
    }
}
