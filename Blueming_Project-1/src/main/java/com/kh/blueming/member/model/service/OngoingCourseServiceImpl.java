package com.kh.blueming.member.model.service;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.blueming.common.model.vo.PageInfo;
import com.kh.blueming.member.model.dao.OngoingCourseDao;
import com.kh.blueming.member.model.vo.OngoingCourse;

@Service
public class OngoingCourseServiceImpl implements OngoingCourseService {

    @Autowired
    private SqlSessionTemplate sqlSession;

    @Autowired
    private OngoingCourseDao dao;

    @Override
    public int selectCourseCount(int memberId) {
        return dao.selectCourseCount(sqlSession, memberId);
    }

    @Override
    public List<OngoingCourse> selectMyCourseList(PageInfo pi, int memberId) {
        return dao.selectMyCourseList(sqlSession, pi, memberId);
    }
}