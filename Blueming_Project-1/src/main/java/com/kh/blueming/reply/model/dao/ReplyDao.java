package com.kh.blueming.reply.model.dao;

import java.util.List; // 🌟 안전한 처리를 위해 java.util.List 임포트
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.kh.blueming.reply.model.vo.Reply;

@Repository 
public class ReplyDao {

    @Autowired
    private SqlSessionTemplate sqlSession; 

    /**
     * 특정 챕터의 댓글 목록 조회
     */
    public List<Reply> selectReplyList(int chapterId) {
        // 강제 형변환 대신 List<Reply> 인터페이스 규격을 그대로 반환하여 파싱 충돌 방지
        return sqlSession.selectList("replyMapper.selectReplyList", chapterId);
    }

    /**
     * 댓글 및 대댓글 등록
     */
    public int insertReply(Reply r) {
        return sqlSession.insert("replyMapper.insertReply", r);
    }

    /**
     * 댓글 삭제 (상태값 N으로 변환)
     */
    public int deleteReply(int replyId) {
        return sqlSession.update("replyMapper.deleteReply", replyId);
    }
    
    /**
     * 댓글 수정 DB 요청
     */
    public int updateReply(Reply r) {
        // "네임스페이스명.태그ID", 전송할 객체
        // reply-mapper.xml 최상단 <mapper namespace="replyMapper"> 와 
        // <update id="updateReply"> 구문을 실행하라는 의미입니다.
        return sqlSession.update("replyMapper.updateReply", r);
    }
}