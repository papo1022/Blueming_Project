package com.kh.blueming.memberlist.model.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.blueming.memberlist.model.dao.MemberListDao;
import com.kh.blueming.memberlist.model.vo.MemberList;
import com.kh.blueming.model.vo.PageInfo;

@Service
public class MemberListService {
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	@Autowired
	private MemberListDao memlistDao;
	
	public int selectListCOunt() {
		return memlistDao.selectListCount(sqlSession);
	}
	
	public ArrayList<MemberList> selectMemberList(PageInfo pi){
		return memlistDao.selectMemberList(sqlSession,pi);
	}
	
	public int selectSearchCount(HashMap<String,String> map) {
		
		return memlistDao.selectSearchCount(sqlSession,map);
	}
	
	
	
	
	
	

}
