package com.kh.blueming.member.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.blueming.assignment.model.vo.AssignmentCard;
import com.kh.blueming.course.model.vo.CourseCard;
import com.kh.blueming.member.model.vo.MemberProfile;

@Repository
public class MemberDashboardDao {

	@Autowired
	private SqlSessionTemplate sqlSession;
	
	// 1. 회원 프로필 조회
	public MemberProfile selectMemberProfile(int memberId) {
		
		return sqlSession.selectOne("memberDashboardMapper.selectMemberProfile", memberId);
	}
	
	// 2. 내 강의 목록 조회(진도율, D-day, 상태)
	public List<CourseCard> selectMyCourseList(int memberId) {
		
		return sqlSession.selectList("memberDashboardMapper.selectMyCourseList", memberId);
	}
	
	// 3. 내 과제 목록 조회(제출 여부)
	public List<AssignmentCard> selectMyAssignmentList(int memberId) {
		
		return sqlSession.selectList("memberDashboardMapper.selectMyAssignmentList", memberId);
	}
	
}
