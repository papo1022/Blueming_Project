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
    @Transactional(rollbackFor = Exception.class)
    public int insertReply(Reply r, MultipartFile uploadFile) {
        
        // 1. 파일이 존재하는 경우만 로직 수행
        if (uploadFile != null && !uploadFile.isEmpty()) {
            int fileId = saveFile(uploadFile); 
            r.setFileId(fileId);
        } else {
            // 🌟 핵심: 파일이 없으면 명시적으로 null 처리 (DB 외래키 제약조건 방지)
            r.setFileId(null); 
        }
        
        // 2. 댓글 DB 저장
        return replyDao.insertReply(r);
    }
    /**
     * 3. 댓글 삭제
     */
    public int deleteReply(int replyId) {
        return replyDao.deleteReply(replyId);
    }
    
    /**
     * 댓글 수정 비즈니스 로직
     */
    @Transactional // 수정 중 예외 발생 시 롤백 처리
    public int updateReply(Reply r) {
        return replyDao.updateReply(r);
    }
    
 // ReplyService.java 내부
    private int saveFile(MultipartFile file) {
        String savePath = "C:\\upload\\blueming\\";
        String originName = file.getOriginalFilename();
        
        // 파일 확장자 추출 (예: "png", "jpg")
        String type = originName.substring(originName.lastIndexOf(".") + 1);
        String changeName = System.currentTimeMillis() + "_" + originName;

        try {
            File targetFile = new File(savePath + changeName);
            file.transferTo(targetFile);

            Attachment at = new Attachment();
            at.setOriginalName(originName);
            at.setChangedName(changeName);
            at.setFilePath(savePath);
            
            // 🌟 추가된 필수 데이터 세팅
            at.setFileSize((int) file.getSize()); // DB가 NUMBER 타입이므로 int로 캐스팅
            at.setType(type);                     // 확장자
            at.setMemberId(1);                    // TODO: 실제 로그인한 유저 ID로 변경 필요!
            
            // 4. DAO를 통해 ATTACHMENT 테이블에 데이터 삽입
            replyDao.insertAttachment(at);

            // 5. 방금 생성된 FILE_ID 리턴
            return replyDao.selectLastFileId();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
    
    
}