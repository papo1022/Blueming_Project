package com.kh.blueming.member.model.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.kh.blueming.assignment.model.vo.AssignmentCard;
import com.kh.blueming.course.model.vo.CourseCard;
import com.kh.blueming.member.model.dao.MemberDashboardDao;
import com.kh.blueming.member.model.vo.MemberProfile;

@Service
public class MemberDashboardService {

	private MemberDashboardDao memberDashboardDao;
	
	// 1. 회원 프로필 조회
	public MemberProfile selectMemberProfile(int memberId) {
		
		return memberDashboardDao.selectMemberProfile(memberId);
	}
	
	// 2. 내 강의 목록 조회
	public List<CourseCard> selectMyCourseList(int memberId) {
		
		return memberDashboardDao.selectMyCourseList(memberId);
	}
	
	// 3. 내 과제 목록 조회
	public List<AssignmentCard> selectMyAssignmentList(int memberId) {
		
		return memberDashboardDao.selectMyAssignmentList(memberId);
	}
	
}
