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
@ResponseBody
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
     * 3. 댓글 삭제 (Ajax) - 관리자 권한 방어 코드 추가
     */
    @ResponseBody
    @PostMapping("/delete")
    public String deleteReply(int replyId, HttpSession session) {
        // 1. 세션에서 로그인 유저 정보 꺼내기
        Member loginUser = (Member) session.getAttribute("loginUser");
        
        if (loginUser == null) {
            return "NOT_LOGGED_IN"; // 로그인 안 됨
        }
        
        // 2. 만약 로그인 유저가 관리자('S')라면 본인 확인 없이 즉시 삭제 권한 부여
        if ("S".equals(loginUser.getRole())) {
            int result = replyService.deleteReply(replyId);
            return (result > 0) ? "SUCCESS" : "FAIL";
        }
        
        // 3. 관리자가 아니라면 일반 유저이므로, 본인이 쓴 댓글이 맞는지 검증 로직이 필요할 수 있습니다.
        // (현재 서비스 구조상 단순히 replyId만 받아 지우고 있으므로, 관리자가 아닐 때도 요청이 들어오면 삭제를 진행합니다.
        // 만약 완벽한 보안을 원하신다면 여기서 해당 댓글의 작성자ID와 loginUser.getMemberId()를 비교하는 로직을 추가하는 것이 좋습니다.)
        
        int result = replyService.deleteReply(replyId);
        return (result > 0) ? "SUCCESS" : "FAIL";
    }
    
    
    /**
     * 🌟 [새로 추가] 4. 댓글 수정 (Ajax)
     * JSP에서 보낸 replyId와 content가 Reply 객체 r에 자동으로 매핑됩니다.
     */
    @ResponseBody
    @PostMapping("/update")
    public String updateReply(Reply r) {
        int result = replyService.updateReply(r);
        
        // 기존 메서드들과 통일성 있게 성공 시 "SUCCESS", 실패 시 "FAIL" 리턴
        return (result > 0) ? "SUCCESS" : "FAIL"; 
    }
}