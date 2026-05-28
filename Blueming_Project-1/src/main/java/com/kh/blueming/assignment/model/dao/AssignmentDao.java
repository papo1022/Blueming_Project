package com.kh.blueming.assignment.model.dao;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.blueming.assignment.model.vo.Assignment;

@Repository
public class AssignmentDao {

    public ArrayList<Assignment> selectAssignmentList(SqlSessionTemplate sqlSession,
                                              int currentPage,
                                              int assignmentLimit,
                                              String keyword,
                                              String targetType,
                                              Integer memberId) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("keyword", keyword);
        map.put("targetType", targetType);
        map.put("memberId", memberId);

        int offset = (currentPage - 1) * assignmentLimit;
        RowBounds rowBounds = new RowBounds(offset, assignmentLimit);

        return (ArrayList) sqlSession.selectList("assignmentMapper.selectAssignmentList", map, rowBounds);
    }
}
