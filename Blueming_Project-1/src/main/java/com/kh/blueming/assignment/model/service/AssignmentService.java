package com.kh.blueming.assignment.model.service;

import java.util.ArrayList;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.blueming.assignment.model.dao.AssignmentDao;
import com.kh.blueming.assignment.model.vo.Assignment;

@Service
public class AssignmentService {

    @Autowired
    private SqlSessionTemplate sqlSession;

    @Autowired
    private AssignmentDao assignmentDao;

    public ArrayList<Assignment> selectAssignmentList(int currentPage,
                                                      int assignmentLimit,
                                                      String keyword,
                                                      String targetType,
                                                      Integer memberId) {
        return assignmentDao.selectAssignmentList(sqlSession, currentPage, assignmentLimit, keyword, targetType, memberId);
    }

}
