package com.kh.blueming.reply.model.dao;

import java.util.List;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.kh.blueming.reply.model.vo.Reply;
import com.kh.blueming.attachment.model.vo.Attachment; // 파일용 VO

@Repository 
public class ReplyDao {

    @Autowired
    private SqlSessionTemplate sqlSession; 

    // --- 1. 댓글 관련 메서드 ---
    public List<Reply> selectReplyList(int chapterId) {
        return sqlSession.selectList("replyMapper.selectReplyList", chapterId);
    }

    public int insertReply(Reply r) {
        return sqlSession.insert("replyMapper.insertReply", r);
    }

    public int deleteReply(int replyId) {
        return sqlSession.update("replyMapper.deleteReply", replyId);
    }
    
    public int updateReply(Reply r) {
        return sqlSession.update("replyMapper.updateReply", r);
    }

    // --- 2. 파일 관련 메서드 (추가됨) ---
    /**
     * ATTACHMENT 테이블에 파일 정보 삽입
     */
    public int insertAttachment(Attachment at) {
        return sqlSession.insert("replyMapper.insertAttachment", at);
    }

    /**
     * 방금 INSERT한 파일의 FILE_ID 조회
     */
    public int selectLastFileId() {
        return sqlSession.selectOne("replyMapper.selectLastFileId");
    }
}