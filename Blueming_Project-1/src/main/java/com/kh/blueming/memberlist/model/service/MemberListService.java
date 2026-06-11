package com.kh.blueming.memberlist.model.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.blueming.common.model.vo.PageInfo;
import com.kh.blueming.course.model.service.CourseService;
import com.kh.blueming.memberlist.model.dao.MemberListDao;
import com.kh.blueming.memberlist.model.vo.MemberList;

@Transactional
@Service
public class MemberListService {
    
    @Autowired
    private SqlSessionTemplate sqlSession;
    
    @Autowired
    private MemberListDao memlistDao;
    
    @Autowired
    private BCryptPasswordEncoder passwordEncoder; // 여기서 주입받아 사용

	@Autowired
	private CourseService courseService;
    
    // --- 기존 기능들 ---
    public int selectListCount() { 
    	return memlistDao.selectListCount(sqlSession); 
    }
 // MemberListService.java 에 추가/수정
    public ArrayList<MemberList> selectMemberList(PageInfo pi, HashMap<String, String> map) {
        // DAO로 맵과 pi를 함께 전달하도록 수정
        return memlistDao.selectMemberList(sqlSession, pi, map);
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
		int result = memlistDao.updateMember(sqlSession, member);
		if (result > 0) {
			courseService.syncEnrollmentByMember(member.getMemberId());
		}
		return result;
	}
    
    	// 💡 사원 추가 메서드 추가
    	// Service.java
	    
	
	    public int insertMember(MemberList member) {
	        // 1. 여기서 암호화 처리
	        String encodedPwd = passwordEncoder.encode(member.getLoginPwd());
	        member.setLoginPwd(encodedPwd);
	        
	        // 2. DAO로 전달
	        int result = memlistDao.insertMember(sqlSession, member);
	        if (result > 0) {
	        	courseService.syncEnrollmentByMember(member.getMemberId());
	        }
	        return result;
	    }
	 // MemberListService.java 파일 내에 추가
	    public ArrayList<MemberList> selectDeptList() {
	        return memlistDao.selectDeptList(sqlSession);
	    }
	    
	    public ArrayList<MemberList> selectPosList() {
	        return memlistDao.selectPosList(sqlSession);
	    }
	    
	    
	    

     	
}