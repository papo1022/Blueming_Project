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
    
    // 기존 기능들...
    public int selectListCount(SqlSessionTemplate sqlSession) {
        return sqlSession.selectOne("memberlistMapper.selectListCount");
    }
    
 // MemberListDao.java
    public ArrayList<MemberList> selectMemberList(SqlSessionTemplate sqlSession, PageInfo pi, HashMap<String, String> map) {
        int limit = pi.getBoardLimit();
        int offset = (pi.getCurrentPage() - 1) * limit;
        RowBounds rowBounds = new RowBounds(offset, limit);
        
        // 쿼리 호출 시 map을 전달
        return (ArrayList) sqlSession.selectList("memberlistMapper.selectMemberList", map, rowBounds);
    }
    public int selectSearchCount(SqlSessionTemplate sqlSession, HashMap<String, String> map) {
        return sqlSession.selectOne("memberlistMapper.selectSearchCount", map);
    }

    public ArrayList<MemberList> searchMemberList(SqlSessionTemplate sqlSession, HashMap<String, String> map, PageInfo pi) {
        int limit = pi.getBoardLimit();
        int offset = (pi.getCurrentPage() - 1) * limit;
        RowBounds rowBounds = new RowBounds(offset, limit);
        return (ArrayList) sqlSession.selectList("memberlistMapper.searchMemberList", map, rowBounds);
    }
    
    public MemberList selectMemberDetail(SqlSessionTemplate sqlSession, int memberId) {
        return sqlSession.selectOne("memberlistMapper.selectMemberDetail", memberId);
    }
    
    public int updateMember(SqlSessionTemplate sqlSession, MemberList member) {
        return sqlSession.update("memberlistMapper.updateMember", member);
    }
    
    // --- [추가] 사원 추가 기능 ---
    public int insertMember(SqlSessionTemplate sqlSession, MemberList member) {
        // XML의 id를 확인하세요: memberlistMapper.insertMember
        return sqlSession.insert("memberlistMapper.insertMember", member);
    }

	public int deleteMember(SqlSessionTemplate sqlSession, int memberId) {
		
		return sqlSession.update("memberlistMapper.deleteMember",memberId);
	}
}