package com.kh.blueming.notice.model.controller;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.blueming.notice.model.vo.Notice;

@Controller
@RequestMapping("notice")
public class NoticeController {
	
	@Autowired
	private NoticeService noticeService;
	
	@GetMapping("list")
	public String selectNoticeList(Model model) {
		
		ArrayList<Notice> list = noticeService.selectNoticeList();
		
		model.addAttribute("list", list);
		
		// 응답페이지를 먼저 만들어서 포워딩
		return "notice/noticeListView";
		
	}

}
