package com.kh.blueming.reply.model.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.kh.blueming.reply.model.dao.ReplyDao;
import com.kh.blueming.reply.model.vo.Reply;

@Service // 🌟 인터페이스 없이 서비스 계층을 직접 구현합니다.
public class ReplyService {

    @Autowired
    private ReplyDao replyDao;

    /**
     * 1. 특정 챕터의 댓글 목록 조회
     */
    public List<Reply> selectReplyList(int chapterId) {
        return replyDao.selectReplyList(chapterId);
    }

    /**
     * 2. 댓글 및 대댓글 등록
     */
    public int insertReply(Reply r) {
        return replyDao.insertReply(r);
    }

    /**
     * 3. 댓글 삭제
     */
    public int deleteReply(int replyId) {
        return replyDao.deleteReply(replyId);
    }
}