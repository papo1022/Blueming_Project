package com.kh.blueming.reply.controller;

import java.util.List;
import jakarta.servlet.http.HttpSession; 
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import com.kh.blueming.member.model.vo.Member; // 💡 본인 프로젝트의 Member VO 경로로 맞춰주세요
import com.kh.blueming.reply.model.service.ReplyService;
import com.kh.blueming.reply.model.vo.Reply;

@Controller
@RequestMapping("/reply")
public class ReplyController {

    @Autowired
    private ReplyService replyService; // 🌟 직접 Service 클래스를 주입받아 사용

    /**
     * 1. 댓글 및 대댓글 목록 조회 (Ajax)
     */
    @ResponseBody
    @GetMapping(value = "/list", produces = "application/json; charset=UTF-8")
    public List<Reply> selectReplyList(int chapterId) {
        return replyService.selectReplyList(chapterId);
    }

    /**
     * 2. 댓글 및 대댓글 등록 (Ajax)
     */
    @ResponseBody
    @PostMapping("/insert")
    public String insertReply(Reply r, HttpSession session) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        
        if (loginUser == null) {
            return "NOT_LOGGED_IN";
        }
        
        r.setMemberId(loginUser.getMemberId()); 
        int result = replyService.insertReply(r);
        
        return (result > 0) ? "SUCCESS" : "FAIL";
    }

    /**
     * 3. 댓글 삭제 (Ajax)
     */
    @ResponseBody
    @PostMapping("/delete")
    public String deleteReply(int replyId) {
        int result = replyService.deleteReply(replyId);
        return (result > 0) ? "SUCCESS" : "FAIL";
    }
}