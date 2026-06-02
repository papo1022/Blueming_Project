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

    // 1. 전체 게시글 수 조회
    public int selectListCount() {
        return sqlSession.selectOne("enrollmemlistMapper.selectListCount");
    }

    // 2. 검색 게시글 수 조회
    public int selectSearchCount(HashMap<String, Object> map) {
        return sqlSession.selectOne("enrollmemlistMapper.selectSearchCount", map);
    }

    // 3. 목록 조회 (정렬 + 페이징 적용 - map 파라미터 추가)
    public ArrayList<Map<String, Object>> selectEnrollmentList(HashMap<String, Object> map, RowBounds rowBounds) {
        return (ArrayList)sqlSession.selectList("enrollmemlistMapper.selectEnrollmentList", map, rowBounds);
    }

    // 4. 검색 목록 조회
    public ArrayList<Map<String, Object>> searchEnrollmentList(HashMap<String, Object> map, RowBounds rowBounds) {
        return (ArrayList)sqlSession.selectList("enrollmemlistMapper.searchEnrollmentList", map, rowBounds);
    }

    // 5. 강의 상세 정보 조회
    public Map<String, Object> selectCourseDetail(int courseId) {
        return sqlSession.selectOne("enrollmemlistMapper.selectCourseDetail", courseId);
    }

    // 6. 강의별 수강생 목록 조회 (정렬 정보 포함)
    public ArrayList<Map<String, Object>> selectEnrollmentListByCourse(HashMap<String, Object> map, RowBounds rowBounds) {
        // sqlSession 인자 제거하고 내부 멤버 변수 사용
        return (ArrayList)sqlSession.selectList("enrollmemlistMapper.selectEnrollmentListByCourse", map, rowBounds);
    }

    // 7. 강의별 수강생 수 조회
    public int selectEnrollmentCountByCourse(SqlSessionTemplate sqlSession, Map<String, Object> map) {
        return sqlSession.selectOne("enrollmemlistMapper.selectEnrollmentCountByCourse", map);
    }
    
 // DAO: EnrollMemListDao.java
    public ArrayList<Map<String, Object>> selectDeptList(SqlSessionTemplate sqlSession) {
        // Map 형태로 결과 반환
        return (ArrayList)sqlSession.selectList("enrollmemlistMapper.selectDeptList");
    }
}