package com.kh.blueming.member.model.dao;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.kh.blueming.member.model.vo.Member;

@Repository
public class MemberDashboardDao {

	private SqlSession sqlSession;
	
	// 1. 회원 프로필 조회
	public Member selectMemberProfile(int memberId) {
		
		return sqlSession.selectOne("memberDashboardMapper.selectMemberProfile", memberId);
	}
	
	// 2. 내 강의 목록 조회(진도율, D-day, 상태)
	public List<Map<String, object>> selectMyCourseList(int memberId) {
		
		return sqlSession.selectList("memberDashboardMapper.selectMyCourseList", memberId);
	}
	
	// 3. 내 과제 목록 조회(제출 여부)
	public List<> selectMyAssignmentList(int memberId) {
		
		return sqlSession.selectList("memberDashboardMapper.selectMyAssignmentList", memberId);
	}
	
}
