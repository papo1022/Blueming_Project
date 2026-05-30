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

    public int selectSearchCount(HashMap<String, String> map) {
        return sqlSession.selectOne("enrollmemlistMapper.selectSearchCount", map);
    }

    public ArrayList<Map<String, Object>> selectEnrollmentList(RowBounds rowBounds) {
        return (ArrayList)sqlSession.selectList("enrollmemlistMapper.selectEnrollmentList", null, rowBounds);
    }

    public ArrayList<Map<String, Object>> searchEnrollmentList(HashMap<String, String> map, RowBounds rowBounds) {
        return (ArrayList)sqlSession.selectList("enrollmemlistMapper.searchEnrollmentList", map, rowBounds);
    }
}