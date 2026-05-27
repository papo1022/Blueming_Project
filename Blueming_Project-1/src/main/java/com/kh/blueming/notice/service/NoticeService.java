package com.kh.blueming.notice.service;

import java.util.ArrayList;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.blueming.notice.model.dao.NoticeDao;
import com.kh.blueming.notice.model.vo.Notice;

@Service
public class NoticeService {
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	@Autowired
	private NoticeDao noticeDao;

	//공지사항 전체 조회
	public ArrayList<Notice> selectNoticeList() {
		return noticeDao.selectNoticeList(sqlSession);
	}
	
	//공지사항 등록
	@Transactional
	public int insertNotice(Notice n) {
		return noticeDao.insertNotice(sqlSession, n);
	}

	//공지사항 상세조회
	@Transactional
	public int increaseCount(int noticeNo) {
		return noticeDao.increaseCount(sqlSession, noticeNo);
	}
	
	public Notice selectNotice(int noticeNo) {
		return noticeDao.selectNotice(sqlSession, noticeNo);
	}
	
	@Transactional
	public int updateNotice(Notice n) {
		return noticeDao.updateNotice(sqlSession, n);
	}

	@Transactional
	public int deleteNotice(int noticeNo) {
		return noticeDao.deleteNotice(sqlSession, noticeNo);
	}
	
}
