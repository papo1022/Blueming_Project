package com.kh.blueming.member.model.service;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.blueming.member.model.dao.MemberDao;
import com.kh.blueming.member.model.vo.Member;

@Service
public class MemberService {
	
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	@Autowired
	private MemberDao memberDao;
	
	public String findIdByEmail(Member m) {
		return memberDao.findIdByEmail(sqlSession, m);
	}

	public int checkMemberExist(Member m) {
		return memberDao.checkMemberExist(sqlSession, m);
	}

	@Transactional
	public int resetPassword(Member m) {
		return memberDao.resetPassword(sqlSession, m);
	}
	


	public Member loginMember(Member m) {
		
		return memberDao.loginMember(sqlSession, m);
	}





	@Transactional
	public int updatePwd(Member m) {
		
		return memberDao.updatePwd(sqlSession, m);
	}




	@Transactional
	public int updateMember(Member m) {
		
		return memberDao.updateMember(sqlSession, m);
	}




	@Transactional
	public int deleteMember(String loginId) {
		
		return memberDao.deleteMember(sqlSession, loginId);
	}

}