package com.kh.blueming.hrdashboard.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.blueming.hrdashboard.model.vo.HrDashboardMember;

@Repository
public class HrDashboardDao {

    @Autowired
    private SqlSession sqlSession;

    public int getMemberCount(String keyword) {
        return sqlSession.selectOne("hrDashboardMapper.getMemberCount", keyword);
    }

    public List<HrDashboardMember> getMemberProgressList(Map<String, Object> param) {
        return sqlSession.selectList("hrDashboardMapper.getMemberProgressList", param);
    }

    public int getNoticeCount() {
        return sqlSession.selectOne("hrDashboardMapper.getNoticeCount");
    }

    public List<HrDashboardMember> getRecentNoticeList(Map<String, Object> param) {
        return sqlSession.selectList("hrDashboardMapper.getRecentNoticeList", param);
    }
}