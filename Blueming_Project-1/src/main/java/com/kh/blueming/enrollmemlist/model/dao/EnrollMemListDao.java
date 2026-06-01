package com.kh.blueming.enrollmemlist.model.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.apache.ibatis.session.SqlSession;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class EnrollMemListDao {

    @Autowired
    private SqlSessionTemplate sqlSession;

    // 1. 전체 게시글 수 조회
    public int selectListCount() {
        return sqlSession.selectOne("enrollmemlistMapper.selectListCount");
    }

    public int selectSearchCount(HashMap<String, Object> map) {
        return sqlSession.selectOne("enrollmemlistMapper.selectSearchCount", map);
    }

    public ArrayList<Map<String, Object>> searchEnrollmentList(HashMap<String, Object> map, RowBounds rowBounds) {
        return (ArrayList)sqlSession.selectList("enrollmemlistMapper.searchEnrollmentList", map, rowBounds);
    }

    

    // 3. 목록 조회 (페이징 적용)
    public ArrayList<Map<String, Object>> selectEnrollmentList(RowBounds rowBounds) {
        return (ArrayList)sqlSession.selectList("enrollmemlistMapper.selectEnrollmentList", null, rowBounds);
    }

   
    
    // 5. 강의 상세 정보 조회
    public Map<String, Object> selectCourseDetail(int courseId) {
        return sqlSession.selectOne("enrollmemlistMapper.selectCourseDetail", courseId);
    }

    // 6. 강의별 수강생 목록 및 수강률 조회
    public ArrayList<Map<String, Object>> selectEnrollmentListByCourse(SqlSession sqlSession, 
            HashMap<String, Object> map, 
            RowBounds rowBounds) {
    	// 매퍼 호출 시 map을 전달
    	return (ArrayList)sqlSession.selectList("enrollmemlistMapper.selectEnrollmentListByCourse", map, rowBounds);
    }

    public int selectEnrollmentCountByCourse(SqlSession sqlSession, int courseId) {
        return sqlSession.selectOne("enrollmemlistMapper.selectEnrollmentCountByCourse", courseId);
    }
}