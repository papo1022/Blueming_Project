package com.kh.blueming.admindashboard.model.service;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.blueming.admindashboard.model.dao.AdminDashboardDao;
import com.kh.blueming.admindashboard.model.vo.AdminDashboardCourse;
import com.kh.blueming.notice.model.vo.Notice;

@Service
public class AdminDashboardService {

	@Autowired
	private AdminDashboardDao adminDashboardDao;
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	// 관리자 대시보드 강의 목록 조회
	public List<AdminDashboardCourse> selectAdminCourseList() {
		
		return adminDashboardDao.selectAdminCourseList(sqlSession);
	}
	
	// 최근 공지사항 3개 조회
	public List<Notice> selectRecentNoticeList() {
		
		return adminDashboardDao.selectRecentNoticeList(sqlSession);
	}
}
