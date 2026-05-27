package com.kh.blueming.notice.controller;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.blueming.notice.model.vo.Notice;
import com.kh.blueming.notice.service.NoticeService;
import com.kh.blueming.template.XssDefencePolicy;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("notice")
public class NoticeController {
	
	@Autowired
	private NoticeService noticeService;
	
	//전체 리스트 조회
	@GetMapping("list")
	public String noticeList(Model model) {
		ArrayList<Notice> list = noticeService.selectNoticeList();
		
		model.addAttribute("list", list);
		return "notice/noticeListView";
	}
	
	//공지사항 작성 (추가) 페이지로 이동
	@GetMapping("enrollForm")
	public String enrollForm() {
		return "notice/noticeEnrollForm";
	}
	
	//공지사항을 등록하는 코드
	@PostMapping("insert")
	public String insertNotice(Notice n, Model model, HttpSession session) {
		String replaceTitle = XssDefencePolicy.defence(n.getNoticeTitle());
		String replaceContent = XssDefencePolicy.defence(n.getContent());
		
		n.setNoticeTitle(replaceTitle);
		n.setContent(replaceContent);
		int result = noticeService.insertNotice(n);
		
		if(result > 0) {
			session.setAttribute("alertMsg", "공지사항 등록 완료");
			return "redirect:/notice/list";
		} else {
			model.addAttribute("errorMsg", "등록에 실패했습니다.");
			return "common/errorPage";
		}
	}
	
	//공지글을 누르면 글이 열림
	@GetMapping("detail")
	public String selectNotice(@RequestParam("nno") int noticeNo, Model model) {
		int result = noticeService.increaseCount(noticeNo);
		
		if(result > 0) {
			Notice n = noticeService.selectNotice(noticeNo);
			model.addAttribute("n", n);
			return "notice/noticeDetailView";
		} else {
			model.addAttribute("errorMsg", "조회에 실패했습니다.");
			return "common/errorPage";
		}
	}
	
	// 공지사항 수정 페이지로 이동
	@PostMapping("updateForm")
	public String updateForm(@RequestParam("nno") int noticeNo, Model model) {
		Notice n = noticeService.selectNotice(noticeNo);
		
		model.addAttribute("n",n);
		return "notice/noticeUpdateForm";
		
	}
	
	//공지글을 업데이트함
	@PostMapping("update")
	public String updateNotice(Notice n, Model model, HttpSession session) {
		String replaceTitle = XssDefencePolicy.defence(n.getNoticeTitle());
		String replaceContent = XssDefencePolicy.defence(n.getContent());
		
		n.setNoticeTitle(replaceTitle);
		n.setContent(replaceContent);
		
		int result = noticeService.updateNotice(n);
		
		if(result > 0) {
			session.setAttribute("alertMsg", "공지사항 수정 완료");
			return "redirect:/notice/list";
		} else {
			model.addAttribute("errorMsg", "수정에 실패했습니다.");
			return "common/errorPage";
		}
	}
	
	//공지글을 삭제함
	@PostMapping("delete")
	public String deleteNotice(@RequestParam("nno") int noticeNo, Model model,
							HttpSession session) {
		
		int result = noticeService.deleteNotice(noticeNo);
		
		if(result > 0) {
			session.setAttribute("alertMsg", "공지사항 삭제 완료");
			return "redirect:/notice/list";
		} else {
			model.addAttribute("errorMsg", "삭제에 실패했습니다.");
			return "common/errorPage";
		}
	}
}
