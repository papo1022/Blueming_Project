package com.kh.blueming.adminAssignment.model.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.blueming.adminAssignment.model.dao.AdminAssignmentDao;
import com.kh.blueming.adminAssignment.model.vo.AdminAssignment;
import com.kh.blueming.common.model.vo.PageInfo;

@Service
public class AdminAssignmentService {

    @Autowired
    private AdminAssignmentDao adminAssignmentDao;

    @Autowired
    private SqlSessionTemplate sqlSession;

   
    public int selectListCount(
            HashMap<String,String> map){

        return adminAssignmentDao.selectListCount(
                sqlSession,
                map);
    }

    public ArrayList<AdminAssignment> selectAssignmentList(
            HashMap<String,String> map,
            PageInfo pi){

        return adminAssignmentDao.selectAssignmentList(
                sqlSession,
                map,
                pi);
    }
    
   
    
    
    


    public AdminAssignment selectAssignmentDetail(
            int memberId,
            int assignmentId){

        return adminAssignmentDao.selectAssignmentDetail(
                sqlSession,
                memberId,
                assignmentId);
    }

    public int updateScore(
            int submissionId,
            int score){

        return adminAssignmentDao.updateScore(
                sqlSession,
                submissionId,
                score);
    }
    
    public AdminAssignment selectFile(int fileId){

        return adminAssignmentDao.selectFile(
                sqlSession,
                fileId);
    }

        public AdminAssignment selectFileBySubmissionId(int submissionId) {

                return adminAssignmentDao.selectFileBySubmissionId(
                                sqlSession,
                                submissionId);
        }
}