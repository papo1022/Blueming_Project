package com.kh.blueming.reply.controller;

import java.util.List;
import jakarta.servlet.http.HttpSession; 
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.kh.blueming.member.model.vo.Member; 
import com.kh.blueming.reply.model.service.ReplyService;
import com.kh.blueming.reply.model.vo.Reply;

@Controller
@RequestMapping("/reply")
@ResponseBody
public class ReplyController {

    @Autowired
    private ReplyService replyService; 

    // 1. 목록 조회
    @PostMapping(value = "/list", produces = "application/json; charset=UTF-8")
    public List<Reply> selectReplyList(@RequestParam("chapterId") int chapterId) {
        return replyService.selectReplyList(chapterId);
    }

    // 2. 댓글 등록 (파일 첨부 포함)
    @PostMapping("/insert")
    public String insertReply(@RequestParam("chapterId") int chapterId,
                              @RequestParam("content") String content,
                              @RequestParam(value="uploadFile", required=false) MultipartFile uploadFile,
                              HttpSession session) {
    	
    	
    	
    	
        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser == null) return "FAIL";

        Reply r = new Reply();
        r.setChapterId(chapterId);
        r.setContent(content);
        r.setMemberId(loginUser.getMemberId());

        // 서비스에 파일과 댓글 객체를 함께 넘깁니다.
        int result = replyService.insertReply(r, uploadFile);
        
        return (result > 0) ? "SUCCESS" : "FAIL";
        
    }
    

    // 3. 댓글 삭제
    @PostMapping("/delete")
    public String deleteReply(@RequestParam("replyId") int replyId, HttpSession session) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser == null) return "NOT_LOGGED_IN"; 
        
        int result = replyService.deleteReply(replyId);
        return (result > 0) ? "SUCCESS" : "FAIL";
    }
    
    // 4. 댓글 수정
    @PostMapping("/update")
    public String updateReply(@RequestParam("replyId") int replyId,
                              @RequestParam("content") String content) {
        Reply r = new Reply();
        r.setReplyId(replyId);
        r.setContent(content);
        
        int result = replyService.updateReply(r);
        return (result > 0) ? "SUCCESS" : "FAIL"; 
    }
}