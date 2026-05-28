package com.kh.blueming.memberlist.model.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
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
    
    // --- 기존 기능들 ---
    public int selectListCount() { return memlistDao.selectListCount(sqlSession); }
    public ArrayList<MemberList> selectMemberList(PageInfo pi){ return memlistDao.selectMemberList(sqlSession,pi); }
    public int selectSearchCount(HashMap<String,String> map) { return memlistDao.selectSearchCount(sqlSession,map); }
    public ArrayList<MemberList> searchMemberList(HashMap<String, String> map, PageInfo pi) { return memlistDao.searchMemberList(sqlSession,map,pi); }
    public MemberList selectMemberDetail(int memberId) { return memlistDao.selectMemberDetail(sqlSession, memberId); }
    public int updateMember(MemberList member) { return memlistDao.updateMember(sqlSession, member); }
    
    // --- [추가] 사원 추가 기능 ---
    @Autowired
    private org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder bcryptPasswordEncoder;

    // --- [추가] 사원 추가 기능 (암호화 적용) ---
 // MemberListService.java
    public int insertMember(MemberList member) {
        String encPwd = bcryptPasswordEncoder.encode("1111");
        member.setLoginPwd(encPwd); // 수정된 메소드명 적용
        return memlistDao.insertMember(sqlSession, member);
    }
    
    
    
    
}