package com.kh.blueming.member.model.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.blueming.member.model.vo.Member;

@Repository
public class MemberDao {
	
	public String findIdByEmail(SqlSessionTemplate sqlSession, Member m) {
		return sqlSession.selectOne("memberMapper.findIdByEmail", m);
	}

	public int checkMemberExist(SqlSessionTemplate sqlSession, Member m) {
		return sqlSession.selectOne("memberMapper.checkMemberExist", m);
	}

	public int resetPassword(SqlSessionTemplate sqlSession, Member m) {
		return sqlSession.update("memberMapper.resetPassword", m);
	}
	

public Member loginMember(SqlSessionTemplate sqlSession, Member m) {
	
	return sqlSession.selectOne("memberMapper.loginMember", m);
}

public int updatePwd(SqlSessionTemplate sqlSession, Member m) {
	
	return sqlSession.update("memberMapper.updatePwd", m);
}

public int updateMember(SqlSessionTemplate sqlSession, Member m) {
	
	return sqlSession.update("memberMapper.updateMember", m);
}

public int deleteMember(SqlSessionTemplate sqlSession, String loginId) {
	
	return sqlSession.update("memberMapper.deleteMember", loginId);
}

}
