package com.kh.blueming.enrollmemlist.model.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class EnrollMemListDao {

    @Autowired
    private SqlSessionTemplate sqlSession;

    public int selectListCount() {
        return sqlSession.selectOne("enrollmemlistMapper.selectListCount");
    }
    
    public int selectSearchCount(HashMap<String, Object> map) {
        return sqlSession.selectOne("enrollmemlistMapper.selectSearchCount", map);
    }

    public ArrayList<Map<String, Object>> selectEnrollmentList(HashMap<String, Object> map, RowBounds rowBounds) {
        return (ArrayList)sqlSession.selectList("enrollmemlistMapper.selectEnrollmentList", map, rowBounds);
    }

    public ArrayList<Map<String, Object>> searchEnrollmentList(HashMap<String, Object> map, RowBounds rowBounds) {
        return (ArrayList)sqlSession.selectList("enrollmemlistMapper.searchEnrollmentList", map, rowBounds);
    }
    
    public Map<String, Object> selectCourseDetail(int courseId) {
        return sqlSession.selectOne("enrollmemlistMapper.selectCourseDetail", courseId);
    }
    
    public ArrayList<Map<String, Object>> selectEnrollmentListByCourse(HashMap<String, Object> map, RowBounds rowBounds) {
        return (ArrayList)sqlSession.selectList("enrollmemlistMapper.selectEnrollmentListByCourse", map, rowBounds);
    }
    
    public int selectEnrollmentCountByCourse(Map<String, Object> map) {
        return sqlSession.selectOne("enrollmemlistMapper.selectEnrollmentCountByCourse", map);
    }
    
    public ArrayList<Map<String, Object>> selectDeptList() {
        return (ArrayList)sqlSession.selectList("enrollmemlistMapper.selectDeptList");
    }
}