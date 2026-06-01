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
                                              boolean isAdmin) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("keyword", keyword);
        map.put("targetType", targetType);
        map.put("memberId", memberId);
        map.put("departmentId", departmentId);
        map.put("positionId", positionId);
        map.put("isAdmin", isAdmin);

        int offset = (currentPage - 1) * assignmentLimit;
        RowBounds rowBounds = new RowBounds(offset, assignmentLimit);

        return (ArrayList) sqlSession.selectList("assignmentMapper.selectAssignmentList", map, rowBounds);
    }

    public int insertAttachment(SqlSessionTemplate sqlSession, Attachment attachment) {
        return sqlSession.insert("assignmentMapper.insertAttachment", attachment);
    }

    public Map<String, Object> selectLatestSubmissionInfo(SqlSessionTemplate sqlSession, Map<String, Object> paramMap) {
        return sqlSession.selectOne("assignmentMapper.selectLatestSubmissionInfo", paramMap);
    }

    public int updateAttachmentStatusToN(SqlSessionTemplate sqlSession, int fileId) {
        return sqlSession.update("assignmentMapper.updateAttachmentStatusToN", fileId);
    }

    public int insertAssignmentSubmission(SqlSessionTemplate sqlSession, Map<String, Object> paramMap) {
        return sqlSession.insert("assignmentMapper.insertAssignmentSubmission", paramMap);
    }

    public int updateAssignmentSubmission(SqlSessionTemplate sqlSession, Map<String, Object> paramMap) {
        return sqlSession.update("assignmentMapper.updateAssignmentSubmission", paramMap);
    }
}
