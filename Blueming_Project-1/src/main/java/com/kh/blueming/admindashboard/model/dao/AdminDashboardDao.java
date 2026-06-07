package com.kh.blueming.admindashboard.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.blueming.admindashboard.model.vo.AdminDashboardCourse;
import com.kh.blueming.notice.model.vo.Notice;

@Repository
public class AdminDashboardDao {
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	// 관리자 대시보드 강의 목록 조회
	public List<AdminDashboardCourse> selectAdminCourseList() {
		return sqlSession.selectList("adminDashboardMapper.selectAdminCourseList");
	}
	
	// 최근 공지사항 3개 조회
	public List<Notice> selectRecentNoticeList() {
		
		return sqlSession.selectList("adminDashboardMapper.selectRecentNoticeList");
	}
}
