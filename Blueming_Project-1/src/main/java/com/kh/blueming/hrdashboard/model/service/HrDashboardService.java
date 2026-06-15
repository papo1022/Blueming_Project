package com.kh.blueming.hrdashboard.model.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.blueming.common.model.vo.PageInfo;
import com.kh.blueming.hrdashboard.model.dao.HrDashboardDao;
import com.kh.blueming.hrdashboard.model.vo.HrDashboardMember;

@Service
public class HrDashboardService {

    @Autowired
    private HrDashboardDao hrDashboardDao;

    public int getMemberCount(String keyword) {
        return hrDashboardDao.getMemberCount(keyword);
    }

    public List<HrDashboardMember> getMemberProgressList(PageInfo pi, String keyword) {

        Map<String, Object> param = new HashMap<>();
        param.put("keyword", keyword);
        param.put("startRow", pi.getStartRow());
        param.put("endRow", pi.getEndRow());

        return hrDashboardDao.getMemberProgressList(param);
    }

    public int getNoticeCount() {
        return hrDashboardDao.getNoticeCount();
    }

    public List<HrDashboardMember> getRecentNoticeList(PageInfo pi) {

        Map<String, Object> param = new HashMap<>();
        param.put("startRow", pi.getStartRow());
        param.put("endRow", pi.getEndRow());

        return hrDashboardDao.getRecentNoticeList(param);
    }
}