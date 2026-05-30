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

    // 1. 전체 게시글 수 조회
    public int selectListCount() {
        return enrollDao.selectListCount();
    }

    // 2. 검색 조건에 맞는 게시글 수 조회
    public int selectSearchCount(HashMap<String, String> map) {
        return enrollDao.selectSearchCount(map);
    }

    // 3. 목록 조회 (페이징 적용)
    public ArrayList<Map<String, Object>> selectEnrollmentList(PageInfo pi) {
        // offset 계산: (현재페이지 - 1) * 페이지당게시글수
        int offset = (pi.getCurrentPage() - 1) * pi.getBoardLimit();
        RowBounds rowBounds = new RowBounds(offset, pi.getBoardLimit());
        
        return enrollDao.selectEnrollmentList(rowBounds);
    }

    // 4. 검색 목록 조회 (페이징 + 검색 적용)
    public ArrayList<Map<String, Object>> searchEnrollmentList(HashMap<String, String> map, PageInfo pi) {
        int offset = (pi.getCurrentPage() - 1) * pi.getBoardLimit();
        RowBounds rowBounds = new RowBounds(offset, pi.getBoardLimit());
        
        return enrollDao.searchEnrollmentList(map, rowBounds);
    }
}