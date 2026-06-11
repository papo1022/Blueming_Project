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
public class ReplyController {

    @Autowired
    private ReplyService replyService;

    // 댓글 목록 조회
    @ResponseBody
    @PostMapping(value="/list", produces="application/json; charset=UTF-8")
    public List<Reply> selectReplyList(
            @RequestParam("chapterId") int chapterId){

        return replyService.selectReplyList(chapterId);
    }

    // 댓글 등록
    @ResponseBody
    @PostMapping("/insert")
    public String insertReply(
            @RequestParam("chapterId") int chapterId,
            @RequestParam("content") String content,
            @RequestParam(value="isPrivate", defaultValue="N") String isPrivate,
            @RequestParam(value="parentReplyId", required=false) Integer parentReplyId,
            @RequestParam(value="uploadFile", required=false) MultipartFile uploadFile,
            HttpSession session){

        Member loginUser =
                (Member)session.getAttribute("loginUser");

        if(loginUser == null){
            return "NOT_LOGGED_IN";
        }

        Reply r = new Reply();

        r.setChapterId(chapterId);
        r.setMemberId(loginUser.getMemberId());
        r.setContent(content);
        r.setIsPrivate(isPrivate);

        if(parentReplyId != null){
            r.setParentReplyId(parentReplyId);
        }

        int result =
                replyService.insertReply(r, uploadFile);

        return result > 0 ? "SUCCESS" : "FAIL";
    }

    // 댓글 삭제
    @ResponseBody
    @PostMapping("/delete")
    public String deleteReply(
            @RequestParam("replyId") int replyId,
            HttpSession session){

        Member loginUser =
                (Member)session.getAttribute("loginUser");

        if(loginUser == null){
            return "NOT_LOGGED_IN";
        }

        Reply reply =
                replyService.selectReply(replyId);

        if(reply == null){
            return "NOT_FOUND";
        }

        // 작성자 또는 관리자(S)
        if(reply.getMemberId() != loginUser.getMemberId()
                && !"S".equals(loginUser.getRole())){
            return "NO_AUTH";
        }

        int result =
                replyService.deleteReply(replyId);

        return result > 0 ? "SUCCESS" : "FAIL";
    }

    // 댓글 수정
    @ResponseBody
    @PostMapping("/update")
    public String updateReply(
            @RequestParam("replyId") int replyId,
            @RequestParam("content") String content,
            HttpSession session){

        Member loginUser =
                (Member)session.getAttribute("loginUser");

        if(loginUser == null){
            return "NOT_LOGGED_IN";
        }

        Reply origin =
                replyService.selectReply(replyId);

        if(origin == null){
            return "NOT_FOUND";
        }

        // 작성자만 수정 가능
        if(origin.getMemberId()
                != loginUser.getMemberId()){
            return "NO_AUTH";
        }

        Reply r = new Reply();
        r.setReplyId(replyId);
        r.setContent(content);

        int result =
                replyService.updateReply(r);

        return result > 0 ? "SUCCESS" : "FAIL";
    }
}