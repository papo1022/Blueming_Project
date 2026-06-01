package com.kh.blueming.member.model.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.blueming.member.model.vo.Member;

@Repository
public class MemberDashboardDao {

	@Autowired
	private SqlSession sqlSession;
	
	// 사원 정보 조회
	public Member getMemberInfo(int memberId) {{
		
		return sqlSession.selectOne("memberDashboard.getMemberInfo", memberId);
	}
}
