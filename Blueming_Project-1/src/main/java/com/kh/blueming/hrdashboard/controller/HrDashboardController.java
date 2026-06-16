package com.kh.blueming.hrdashboard.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.blueming.common.model.vo.PageInfo;
import com.kh.blueming.common.template.Pageination;
import com.kh.blueming.hrdashboard.model.service.HrDashboardService;
import com.kh.blueming.hrdashboard.model.vo.HrDashboardMember;
import com.kh.blueming.notice.model.service.NoticeService;
import com.kh.blueming.notice.model.vo.Notice;

@Controller
public class HrDashboardController {

    @Autowired
    private HrDashboardService hrDashboardService;
    
    @Autowired
    private NoticeService noticeService;

    @GetMapping("/member/hr")
    public String dashboard(
            @RequestParam(value="mpage", defaultValue="1") int mpage,
            @RequestParam(value="npage", defaultValue="1") int npage,
            @RequestParam(value="keyword", required=false) String keyword,
            Model model
    ) {

        int listCount = hrDashboardService.getMemberCount(keyword);
        PageInfo mpi = Pageination.getPageInfo(listCount, mpage, 5, 10);

        int noticeCount = hrDashboardService.getNoticeCount();
        PageInfo npi = Pageination.getPageInfo(noticeCount, npage, 5, 5);

        List<HrDashboardMember> progressList =
                hrDashboardService.getMemberProgressList(mpi, keyword);

        List<HrDashboardMember> noticeList =
                hrDashboardService.getRecentNoticeList(npi);

        model.addAttribute("progressList", progressList);
        model.addAttribute("noticeList", noticeList);
        model.addAttribute("mpi", mpi);
        model.addAttribute("npi", npi);
        model.addAttribute("keyword", keyword);

        return "member/hr";
    }
    
    @GetMapping("/notice/detail/hr") // 대시보드에서 접근할 별도 URL
    public String noticeDetail(@RequestParam(value="no") int noticeId, Model model) {
        
        // 1. 조회수 증가 (NoticeController의 selectNotice 메서드 로직 재활용)
        int result = noticeService.increaseCount(noticeId);
        
        if(result > 0) {
            // 2. 상세 조회
            Notice n = noticeService.selectNotice(noticeId);
            model.addAttribute("n", n); // 💡 기존 noticeDetailView.jsp에서 'n'이라는 이름으로 쓰고 있으므로 동일하게 맞춥니다.
            
            // 💡 기존 공지사항 상세 페이지 뷰 경로를 그대로 리턴
            return "notice/noticeDetailView"; 
        } else {
            model.addAttribute("errorMsg", "공지사항 상세조회에 실패했습니다.");
            return "common/errorPage";
        }
    }
}