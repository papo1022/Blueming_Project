package com.kh.blueming.notice.model.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.blueming.common.model.vo.PageInfo;
import com.kh.blueming.notice.model.vo.Notice;

@Repository
public class NoticeDao {

	
	public ArrayList<Notice> selectNoticeList(SqlSessionTemplate sqlSession) {
		
		return (ArrayList)sqlSession.selectList("noticeMapper.selectNoticeList");
	}

	public int insertNotice(SqlSessionTemplate sqlSession, Notice n) {
		
		return sqlSession.insert("noticeMapper.insertNotice", n);
	}

	public int increaseCount(SqlSessionTemplate sqlSession, int noticeId) {
		
		return sqlSession.update("noticeMapper.increaseCount", noticeId);
	}
	
	public Notice selectNotice(SqlSessionTemplate sqlSession, int noticeId) {
		
		return sqlSession.selectOne("noticeMapper.selectNotice", noticeId);
	}
	
	public int updateNotice(SqlSessionTemplate sqlSession, Notice n) {
		
		return sqlSession.update("noticeMapper.updateNotice", n);
	}
	
	public int deleteNotice(SqlSessionTemplate sqlSession, int noticeid) {
		
		return sqlSession.update("noticeMapper.deleteNotice", noticeid);
	}

	public int selectListCount(SqlSessionTemplate sqlSession) {
		
		return sqlSession.selectOne("noticeMapper.selectListCount");
	}

	public ArrayList<Notice> selectNoticeList(SqlSessionTemplate sqlSession, PageInfo pi) {
		
		int limit = pi.getBoardLimit();
		int offset = (pi.getCurrentPage() - 1) * limit;
		
		RowBounds rowBounds = new RowBounds(offset, limit);
		
		// 이 RowBounds 객체를 같이 넘기면서 selectList 메소드를 호출 (3번째 매개변수)
		return (ArrayList)sqlSession.selectList("noticeMapper.selectNoticeList2", null, rowBounds);
	}
	
	public ArrayList<Notice> searchNoticeList(SqlSessionTemplate sqlSession,
			HashMap<String, String> map,
			PageInfo pi) {

		int limit = pi.getBoardLimit();
		int offset = (pi.getCurrentPage() - 1) * limit;
		
		RowBounds rowBounds = new RowBounds(offset, limit);
		
		return (ArrayList)sqlSession.selectList("noticeMapper.searchNoticeList", map, rowBounds);
		}

	public int selectSearchCount(SqlSessionTemplate sqlSession, HashMap<String, String> map) {
		
		return sqlSession.selectOne("noticeMapper.selectSearchCount", map);
	}

	public static List<Notice> selectRecentNoticeList(SqlSessionTemplate sqlSession) {
		return sqlSession.selectList("adminDashboardMapper.selectRecentNoticeList");
	}
	

}
