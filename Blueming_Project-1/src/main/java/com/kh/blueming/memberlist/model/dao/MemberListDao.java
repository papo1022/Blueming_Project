package com.kh.blueming.memberlist.model.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.blueming.memberlist.model.vo.MemberList;
import com.kh.blueming.model.vo.PageInfo;

@Repository
public class MemberListDao {
	
	public int selectListCount(SqlSessionTemplate sqlSession) {
		
		sqlSession.selectOne("boardMapper.selectListCount");
		
		
	}
	
	public ArrayList<MemberList> selectMemberList(SqlSessionTemplate sqlSession,PageInfo pi){
		
		int limit = pi.getBoardLimit();
		int offset = (pi.getCurrentPage()-1)*limit;
		
		int startRow = offset + 1;
	    int endRow = pi.getCurrentPage() * limit;
	    
	 // 파라미터를 담을 Map 생성
	    Map<String, Integer> pageMap = new HashMap<>();
	    pageMap.put("startRow", startRow);
	    pageMap.put("endRow", endRow);
	    
	 // sqlSession에 pageMap을 파라미터로 전달
	    return (ArrayList) sqlSession.selectList("memberMapper.selectMemberList", pageMap);
		
	}

	public int selectSearchCount(SqlSessionTemplate sqlSession, HashMap<String, String> map) {
		
		return sqlSession.selectOne("memberlistMapper.selectSearchCount",map);
	}
	
	
	
	

}
