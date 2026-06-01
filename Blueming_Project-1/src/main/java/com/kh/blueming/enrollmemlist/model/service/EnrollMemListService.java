package com.kh.blueming.enrollmemlist.model.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.blueming.common.model.vo.PageInfo;
import com.kh.blueming.enrollmemlist.model.dao.EnrollMemListDao;

@Service
public class EnrollMemListService {

    @Autowired
    private EnrollMemListDao enrollDao;
    
    @Autowired
    private SqlSession sqlSession; // 1. SqlSession 주입 추가

    // 1. 전체 게시글 수 조회
    public int selectListCount() {
        return enrollDao.selectListCount();
    }

   
   

    // 3. 목록 조회 (페이징 적용)
    public ArrayList<Map<String, Object>> selectEnrollmentList(PageInfo pi) {
        int offset = (pi.getCurrentPage() - 1) * pi.getBoardLimit();
        RowBounds rowBounds = new RowBounds(offset, pi.getBoardLimit());
        
        return enrollDao.selectEnrollmentList(rowBounds);
    }

    // 4. 검색 목록 조회 (페이징 + 검색 적용)
 // 서비스 메서드 인자 변경
    public int selectSearchCount(HashMap<String, Object> map) {
        return enrollDao.selectSearchCount(map);
    }

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
        
        // 이제 map 안에는 courseId, sortCol, sortOrder가 들어있습니다.
        return enrollDao.selectEnrollmentListByCourse(sqlSession, map, rowBounds);
    }
    
    // 7. 강의별 수강생 수 조회
    public int selectEnrollmentCountByCourse(int courseId) {
        return enrollDao.selectEnrollmentCountByCourse(sqlSession, courseId);
    }
}