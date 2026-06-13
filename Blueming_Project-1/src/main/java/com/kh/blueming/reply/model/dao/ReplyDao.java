package com.kh.blueming.reply.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.blueming.attachment.model.vo.Attachment;
import com.kh.blueming.reply.model.vo.Reply;

@Repository
public class ReplyDao {

    @Autowired
    private SqlSessionTemplate sqlSession;

    // 댓글 목록 조회
    public List<Reply> selectReplyList(int chapterId) {
        return sqlSession.selectList(
                "replyMapper.selectReplyList",
                chapterId);
    }

    // 댓글 단건 조회
    public Reply selectReply(int replyId) {
        return sqlSession.selectOne(
                "replyMapper.selectReply",
                replyId);
    }

    // 댓글 등록
    public int insertReply(Reply r) {
        return sqlSession.insert(
                "replyMapper.insertReply",
                r);
    }

    // 댓글 삭제
    public int deleteReply(int replyId) {
        return sqlSession.update(
                "replyMapper.deleteReply",
                replyId);
    }

    // 댓글 수정
    public int updateReply(Reply r) {
        return sqlSession.update(
                "replyMapper.updateReply",
                r);
    }

    // 첨부파일 등록
    public int insertAttachment(Attachment at) {
        return sqlSession.insert(
                "replyMapper.insertAttachment",
                at);
    }

    // 마지막 파일번호 조회
    public int selectLastFileId() {
        return sqlSession.selectOne(
                "replyMapper.selectLastFileId");
    }

    // 댓글 기준 첨부파일 조회
    public Reply selectAttachmentByReplyId(int replyId) {
        return sqlSession.selectOne(
                "replyMapper.selectAttachmentByReplyId",
                replyId);
    }

}