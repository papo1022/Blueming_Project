package com.kh.blueming.memberlist.model.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.kh.blueming.common.model.vo.PageInfo;
import com.kh.blueming.memberlist.model.dao.MemberListDao;
import com.kh.blueming.memberlist.model.vo.MemberList;

@Service
public class MemberListService {
    
    @Autowired
    private SqlSessionTemplate sqlSession;
    
    @Autowired
    private MemberListDao memlistDao;
    
    @Autowired
    private BCryptPasswordEncoder passwordEncoder; // 여기서 주입받아 사용
    
    // --- 기존 기능들 ---
    public int selectListCount() { 
    	return memlistDao.selectListCount(sqlSession); 
    }
    public ArrayList<MemberList> selectMemberList(PageInfo pi){
    	return memlistDao.selectMemberList(sqlSession,pi); 
    	}
    public int selectSearchCount(HashMap<String,String> map) {
    	return memlistDao.selectSearchCount(sqlSession,map); 
    	}
    public ArrayList<MemberList> searchMemberList(HashMap<String, String> map, PageInfo pi) { 
    	return memlistDao.searchMemberList(sqlSession,map,pi);
    	}
    public MemberList selectMemberDetail(int memberId) { 
    	return memlistDao.selectMemberDetail(sqlSession, memberId); 
    	}
    public int updateMember(MemberList member) { 
    	return memlistDao.updateMember(sqlSession, member); 
    	}
    
    	// 💡 사원 추가 메서드 추가
    	// Service.java
	    
	
	    public int insertMember(MemberList member) {
	        // 1. 여기서 암호화 처리
	        String encodedPwd = passwordEncoder.encode(member.getLoginPwd());
	        member.setLoginPwd(encodedPwd);
	        
	        // 2. DAO로 전달
	        return memlistDao.insertMember(sqlSession, member);
	    }
	    
	    public int deleteMember(int memberId) {
	        return memlistDao.deleteMember(sqlSession, memberId);
	    }
    	
    
     	
}