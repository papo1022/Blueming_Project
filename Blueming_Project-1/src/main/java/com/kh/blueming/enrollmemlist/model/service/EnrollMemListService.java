package com.kh.blueming.enrollmemlist.model.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.blueming.common.model.vo.PageInfo;
import com.kh.blueming.enrollmemlist.model.dao.EnrollMemListDao;

@Service
public class EnrollMemListService {

    @Autowired
    private EnrollMemListDao enrollDao;

    public int selectListCount() {
        return enrollDao.selectListCount();
    }
    
    public int selectSearchCount(HashMap<String, Object> map) {
        return enrollDao.selectSearchCount(map);
    }

    public ArrayList<Map<String, Object>> selectEnrollmentList(HashMap<String, Object> map, PageInfo pi) {
        int offset = (pi.getCurrentPage() - 1) * pi.getBoardLimit();
        RowBounds rowBounds = new RowBounds(offset, pi.getBoardLimit());
        return enrollDao.selectEnrollmentList(map, rowBounds);
    }

    public ArrayList<Map<String, Object>> searchEnrollmentList(HashMap<String, Object> map, PageInfo pi) {
        int offset = (pi.getCurrentPage() - 1) * pi.getBoardLimit();
        RowBounds rowBounds = new RowBounds(offset, pi.getBoardLimit());
        return enrollDao.searchEnrollmentList(map, rowBounds);
    }
    
    public Map<String, Object> selectCourseDetail(int courseId) {
        return enrollDao.selectCourseDetail(courseId);
    }
    
    public ArrayList<Map<String, Object>> selectEnrollmentListByCourse(HashMap<String, Object> map, PageInfo pi) {
        int offset = (pi.getCurrentPage() - 1) * pi.getBoardLimit();
        RowBounds rowBounds = new RowBounds(offset, pi.getBoardLimit());
        return enrollDao.selectEnrollmentListByCourse(map, rowBounds);
    }
    
    public int selectEnrollmentCountByCourse(Map<String, Object> map) {
        return enrollDao.selectEnrollmentCountByCourse(map); // sqlSession 삭제
    }
    
    public ArrayList<Map<String, Object>> selectDeptList() {
        return enrollDao.selectDeptList(); // sqlSession 삭제
    }

}