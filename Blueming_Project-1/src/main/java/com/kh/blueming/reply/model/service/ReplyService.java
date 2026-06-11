package com.kh.blueming.reply.model.service;

import java.io.File;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.kh.blueming.attachment.model.vo.Attachment;
import com.kh.blueming.reply.model.dao.ReplyDao;
import com.kh.blueming.reply.model.vo.Reply;

@Service
public class ReplyService {

    @Autowired
    private ReplyDao replyDao;

    /**
     * 댓글 목록 조회
     */
    public List<Reply> selectReplyList(int chapterId) {
        return replyDao.selectReplyList(chapterId);
    }

    /**
     * 댓글 등록
     */
    @Transactional(rollbackFor = Exception.class)
    public int insertReply(Reply r, MultipartFile uploadFile) {

        if(uploadFile != null && !uploadFile.isEmpty()) {

            int fileId = saveFile(uploadFile, r.getMemberId());

            if(fileId <= 0) {
                throw new RuntimeException("파일 저장 실패");
            }

            r.setFileId(fileId);

        } else {
            r.setFileId(null);
        }

        return replyDao.insertReply(r);
    }

    /**
     * 댓글 삭제
     */
    public int deleteReply(int replyId) {
        return replyDao.deleteReply(replyId);
    }

    /**
     * 댓글 수정
     */
    @Transactional
    public int updateReply(Reply r) {
        return replyDao.updateReply(r);
    }

    /**
     * 첨부파일 저장
     */
    private int saveFile(MultipartFile file, int memberId) {

        String savePath = "C:\\upload\\blueming\\";

        try {

            File folder = new File(savePath);

            if(!folder.exists()) {
                folder.mkdirs();
            }

            String originName = file.getOriginalFilename();

            String ext = "";

            if(originName != null && originName.lastIndexOf(".") > -1) {
                ext = originName.substring(originName.lastIndexOf(".") + 1);
            }

            String changeName =
                    System.currentTimeMillis()
                    + "_"
                    + originName;

            File targetFile = new File(savePath + changeName);

            file.transferTo(targetFile);

            Attachment at = new Attachment();

            at.setOriginalName(originName);
            at.setChangedName(changeName);
            at.setFilePath(savePath);
            at.setFileSize((int)file.getSize());
            at.setType(ext);
            at.setMemberId(memberId);

            int result = replyDao.insertAttachment(at);

            if(result <= 0) {
                throw new RuntimeException("첨부파일 DB 저장 실패");
            }

            return replyDao.selectLastFileId();

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("파일 저장 중 오류 발생");
        }
    }
    
    public Reply selectReply(int replyId) {
        return replyDao.selectReply(replyId);
    }
}