package com.kh.blueming.notice.service;

import java.util.ArrayList;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.blueming.notice.model.dao.NoticeDao;
import com.kh.blueming.notice.model.vo.Notice;

@Service
public class NoticeService {
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
//	@Autowired
//	private NoticeDao noticeDao;

	public ArrayList<Notice> selectNoticeList() {
		return NoticeDao.selectNoticeList(sqlSession);
	}
	
}
