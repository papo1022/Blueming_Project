package com.kh.blueming.notice.controller;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.blueming.notice.model.vo.Notice;
import com.kh.blueming.notice.service.NoticeService;

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
}
