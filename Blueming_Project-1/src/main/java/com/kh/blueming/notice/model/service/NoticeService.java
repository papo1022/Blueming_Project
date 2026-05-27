package com.kh.blueming.notice.model.service;

import java.util.ArrayList;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;

import com.kh.blueming.notice.model.vo.Notice;

public class NoticeService {
	
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	@Autowired
	private NoticeDao noticeDao;
	
	public ArrayList<Notice> selectNoticeList() {
		
		return noticeDao.selectNoticeList(sqlSession);
	}

}
