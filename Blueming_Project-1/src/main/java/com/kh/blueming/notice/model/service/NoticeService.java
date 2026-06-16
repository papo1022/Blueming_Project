package com.kh.blueming.notice.model.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.blueming.common.model.vo.PageInfo;
import com.kh.blueming.notice.model.dao.NoticeDao;
import com.kh.blueming.notice.model.vo.Notice;

@Service
public class NoticeService {
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	@Autowired
	private NoticeDao noticeDao;
	
	
	public ArrayList<Notice> selectNoticeList() {
		
		return noticeDao.selectNoticeList(sqlSession);
	}
	
	@Transactional
	public int insertNotice(Notice n) {
		
		return noticeDao.insertNotice(sqlSession, n);
	}

	@Transactional
	public int increaseCount(int noticeId) {
		
		return noticeDao.increaseCount(sqlSession, noticeId);
	}
	
	public Notice selectNotice(int noticeId) {
		
		return noticeDao.selectNotice(sqlSession, noticeId);
	}

	@Transactional
	public int updateNotice(Notice n) {
		
		return noticeDao.updateNotice(sqlSession, n);
	}
	
	@Transactional
	public int deleteNotice(int noticeId) {
		
		return noticeDao.deleteNotice(sqlSession, noticeId);
	}

	public int selectListCount() {
		
		return noticeDao.selectListCount(sqlSession);
	}
	
	public ArrayList<Notice> selectNoticeList(PageInfo pi) {
		
		return noticeDao.selectNoticeList(sqlSession, pi);
	}

	public int selectSearchCount(HashMap<String, String> map) {
		
		return noticeDao.selectSearchCount(sqlSession, map);
	}
	
	public ArrayList<Notice> searchNoticeList(HashMap<String, String> map,
			PageInfo pi) {

		return noticeDao.searchNoticeList(sqlSession, map, pi);
	}

	public List<Notice> selectRecentNoticeList() {
		return noticeDao.selectRecentNoticeList(sqlSession);
	}
}
