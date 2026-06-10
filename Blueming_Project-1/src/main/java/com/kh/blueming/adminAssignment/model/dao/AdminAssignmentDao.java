package com.kh.blueming.adminAssignment.model.dao;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.blueming.adminAssignment.model.vo.AdminAssignment;
import com.kh.blueming.common.model.vo.PageInfo;

@Repository
public class AdminAssignmentDao {
	
	
	public int selectListCount(
	        SqlSessionTemplate sqlSession,
	        HashMap<String,String> map){

	    return sqlSession.selectOne(
	            "adminAssignmentMapper.selectListCount",
	            map);
	}
	
	public ArrayList<AdminAssignment> selectAssignmentList(

	        SqlSessionTemplate sqlSession,

	        HashMap<String,String> map,

	        PageInfo pi){

	    int offset =
	            (pi.getCurrentPage()-1)
	            * pi.getBoardLimit();

	    RowBounds rowBounds =
	            new RowBounds(
	                    offset,
	                    pi.getBoardLimit());

	    return (ArrayList)sqlSession.selectList(
	            "adminAssignmentMapper.selectAssignmentList",
	            map,
	            rowBounds);
	}
	
	

 

    public AdminAssignment selectAssignmentDetail(
            SqlSessionTemplate sqlSession,
            int memberId,
            int assignmentId){

        HashMap<String,Integer> map = new HashMap<>();

        map.put("memberId", memberId);
        map.put("assignmentId", assignmentId);

        return sqlSession.selectOne(
                "adminAssignmentMapper.selectAssignmentDetail",
                map);
    }

    public int updateScore(
            SqlSessionTemplate sqlSession,
            int submissionId,
            int score){

        HashMap<String,Integer> map = new HashMap<>();

        map.put("submissionId", submissionId);
        map.put("score", score);

        return sqlSession.update(
                "adminAssignmentMapper.updateScore",
                map);
    }
    
    public AdminAssignment selectFile(
            SqlSessionTemplate sqlSession,
            int fileId) {

        HashMap<String, Integer> map = new HashMap<>();
        map.put("fileId", fileId);

        return sqlSession.selectOne(
                "adminAssignmentMapper.selectFile",
                map);
    }

        public AdminAssignment selectFileBySubmissionId(
                        SqlSessionTemplate sqlSession,
                        int submissionId) {

                HashMap<String, Integer> map = new HashMap<>();
                map.put("submissionId", submissionId);

                return sqlSession.selectOne(
                                "adminAssignmentMapper.selectFileBySubmissionId",
                                map);
        }
}