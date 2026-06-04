package com.kh.blueming.hrdashboard.model.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.blueming.hrdashboard.model.dao.HrDashboardDao;
import com.kh.blueming.hrdashboard.model.vo.HrDashboardMember;

@Service
public class HrDashboardService {

	@Autowired
	private HrDashboardDao hrDashboardDao;
	
	public List<HrDashboardMember> selectHrMemberList() {
		
		return hrDashboardDao.selectHrMemberList();
	}
}
