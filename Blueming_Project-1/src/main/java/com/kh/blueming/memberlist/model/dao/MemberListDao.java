package com.kh.blueming.memberlist.model.dao;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.blueming.memberlist.model.vo.MemberList;
import com.kh.blueming.common.model.vo.PageInfo;

@Repository
public class MemberListDao {
	
	// 전체 사원 개수 조회
	public int selectListCount(SqlSessionTemplate sqlSession) {
		return sqlSession.selectOne("memberlistMapper.selectListCount");
	}
	
	// 전체 사원 목록 조회 (페이징)
	public ArrayList<MemberList> selectMemberList(SqlSessionTemplate sqlSession, PageInfo pi) {
		int limit = pi.getBoardLimit();
		int offset = (pi.getCurrentPage() - 1) * limit;
		
		RowBounds rowBounds = new RowBounds(offset, limit);
		
		return (ArrayList) sqlSession.selectList("memberlistMapper.selectMemberList", null, rowBounds);
	}

	// 검색 결과 개수 조회
	public int selectSearchCount(SqlSessionTemplate sqlSession, HashMap<String, String> map) {
		return sqlSession.selectOne("memberlistMapper.selectSearchCount", map);
	}

	// 사원 목록 검색 (페이징)
	public ArrayList<MemberList> searchMemberList(SqlSessionTemplate sqlSession, 
											     HashMap<String, String> map, PageInfo pi) {
		int limit = pi.getBoardLimit();
		int offset = (pi.getCurrentPage() - 1) * limit;
		
		RowBounds rowBounds = new RowBounds(offset, limit);
		
		// map 전달 필수!
		return (ArrayList) sqlSession.selectList("memberlistMapper.searchMemberList", map, rowBounds);
	}
	
	
	public MemberList selectMemberDetail(SqlSessionTemplate sqlSession, int memberId) {
		return sqlSession.selectOne("memberlistMapper.selectMemberDetail", memberId);
	}
	
	public int updateMember(SqlSessionTemplate sqlSession, MemberList member) {
	    return sqlSession.update("memberlistMapper.updateMember", member);
	}
	
	
}