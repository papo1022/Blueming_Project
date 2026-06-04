package com.kh.blueming.hrdashboard.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.blueming.hrdashboard.model.vo.HrDashboardMember;

@Repository
public class HrDashboardDao {

	@Autowired
	private SqlSessionTemplate sqlSession;
	
	public List<HrDashboardMember> selectHrMemberList() {
		
		return sqlSession.selectList("hrDashboardMapper.selectHrMemberList");
	}
}
