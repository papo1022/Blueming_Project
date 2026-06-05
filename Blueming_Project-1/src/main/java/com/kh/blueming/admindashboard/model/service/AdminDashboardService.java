package com.kh.blueming.admindashboard.model.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.blueming.admindashboard.model.dao.AdminDashboardDao;
import com.kh.blueming.admindashboard.model.vo.AdminDashboardCourse;

@Service
public class AdminDashboardService {

	@Autowired
	private AdminDashboardDao adminDashboardDao;
	
	// 관리자 대시보드 강의 목록 조회
	public List<AdminDashboardCourse> selectAdminCourseList() {
		
		return adminDashboardDao.selectAdminCourseList();
	}
}
