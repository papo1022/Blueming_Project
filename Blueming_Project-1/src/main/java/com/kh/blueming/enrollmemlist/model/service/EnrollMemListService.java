package com.kh.blueming.enrollmemlist.model.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.blueming.common.model.vo.PageInfo;
import com.kh.blueming.enrollmemlist.model.dao.EnrollMemListDao;

@Service
public class EnrollMemListService {

	@Autowired
    private SqlSessionTemplate sqlSession;
	
    @Autowired
    private EnrollMemListDao enrollDao;

    // 1. 전체 게시글 수 조회
    public int selectListCount() {
        return enrollDao.selectListCount();
    }
    
    // 2. 검색 게시글 수 조회
    public int selectSearchCount(HashMap<String, Object> map) {
        return enrollDao.selectSearchCount(map);
    }

    // 3. 목록 조회 (정렬 + 페이징 적용)
    public ArrayList<Map<String, Object>> selectEnrollmentList(HashMap<String, Object> map, PageInfo pi) {
        int offset = (pi.getCurrentPage() - 1) * pi.getBoardLimit();
        RowBounds rowBounds = new RowBounds(offset, pi.getBoardLimit());
        // DAO에 정렬 map과 페이징 rowBounds 전달
        return enrollDao.selectEnrollmentList(map, rowBounds);
    }

    // 4. 검색 목록 조회 (정렬 + 검색 + 페이징 적용)
    public ArrayList<Map<String, Object>> searchEnrollmentList(HashMap<String, Object> map, PageInfo pi) {
        int offset = (pi.getCurrentPage() - 1) * pi.getBoardLimit();
        RowBounds rowBounds = new RowBounds(offset, pi.getBoardLimit());
        return enrollDao.searchEnrollmentList(map, rowBounds);
    }
    
    // 5. 강의 상세 정보 조회
    public Map<String, Object> selectCourseDetail(int courseId) {
        return enrollDao.selectCourseDetail(courseId);
    }
    
    // 6. 강의별 수강생 목록 조회 (정렬 정보 포함)
    public ArrayList<Map<String, Object>> selectEnrollmentListByCourse(HashMap<String, Object> map, PageInfo pi) {
        int offset = (pi.getCurrentPage() - 1) * pi.getBoardLimit();
        RowBounds rowBounds = new RowBounds(offset, pi.getBoardLimit());
        return enrollDao.selectEnrollmentListByCourse(map, rowBounds);
    }
    
    // 7. 강의별 수강생 수 조회
 // @Override  <-- 이 줄을 지우세요!
    public int selectEnrollmentCountByCourse(Map<String, Object> map) {
        return enrollDao.selectEnrollmentCountByCourse(sqlSession, map);
    }
    
    public ArrayList<Map<String, Object>> selectDeptList() {
        return enrollDao.selectDeptList(sqlSession);
    }
}