package com.kh.blueming.course.controller;

import java.io.File;
import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.kh.blueming.attachment.model.vo.Attachment;
import com.kh.blueming.chapter.model.vo.Chapter;
import com.kh.blueming.common.template.FileRenamePolicy;
import com.kh.blueming.common.template.VideoDurationPolicy;
import com.kh.blueming.common.template.XssDefencePolicy;
import com.kh.blueming.course.model.service.CourseService;
import com.kh.blueming.course.model.vo.Course;
import com.kh.blueming.member.model.vo.Member;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("course")
public class CourseController {

    @Autowired
    private CourseService courseService;
    
    //리스트들을 띄우는 코드
    @GetMapping("list")
    public ModelAndView selectCourseList(@RequestParam(value = "keyword", required = false) String keyword,
                                         @RequestParam(value = "sort", defaultValue = "latest") String sort,
                                         ModelAndView mv) {
        if (!"oldest".equals(sort)) {
                sort = "latest";
        }

        mv.addObject("keyword", keyword)
          .addObject("sort", sort)
          .setViewName("course/courseListView");

        return mv;
    }

    //ajax를 이용한 카드형 표기
    @ResponseBody
    @GetMapping("ajaxList")
    public ArrayList<Course> ajaxSelectCourseList(
            @RequestParam(value = "page", defaultValue = "1") int currentPage,
            @RequestParam(value = "limit", defaultValue = "4") int courseLimit,
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "sort", defaultValue = "latest") String sort,
            HttpSession session) {

        if (currentPage < 1) {
            currentPage = 1;
        }

        if (courseLimit < 1) {
            courseLimit = 4;
        }

        if (!"oldest".equals(sort)) {
            sort = "latest";
        }

        Member loginUser = (Member) session.getAttribute("loginUser");
        String departmentId = (loginUser != null) ? loginUser.getDepartmentId() : null;
        String positionId = (loginUser != null) ? loginUser.getPositionId() : null;
        boolean isAdmin = loginUser != null && "S".equals(loginUser.getRole());

        return courseService.selectCourseList(currentPage,
                                              courseLimit,
                                              keyword,
                                              sort,
                                              departmentId,
                                              positionId,
                                              isAdmin);
    }
    
    //카드를 누르면 상세설명 페이지로 이동
    //챕터 리스트를 불러오기까지 함
    @GetMapping("detail")
    public ModelAndView selectCourse(@RequestParam("courseId") int courseId,
                                     ModelAndView mv) {
    	
        Course course = courseService.selectCourse(courseId);
        ArrayList<Chapter> chapterList = courseService.selectChapterList(courseId);

        mv.addObject("course", course)
            .addObject("chapterList",chapterList)
        	.setViewName("course/courseDetailView");
        return mv;
    }
    
    //챕터 상세 페이지로 이동
    @GetMapping("chapterDetailView")
    public ModelAndView selectChapter(@RequestParam("chapterId") int chapterId, ModelAndView mv) {
    	Chapter chapter = courseService.selectChapter(chapterId);
    	
    	
    	mv.addObject("chapter", chapter)
    		.setViewName("course/chapterDetailView");
    	
    	return mv;
    }
    
    //코스 추가 페이지로 이동
    @GetMapping("addCourseView")
    public String addForm() {
    	return "course/courseAdd";
    }
    
    //코스를 데이터베이스에 추가하는 코드 (완료)
    @PostMapping("addCourse")
    public String addCourse(Course c, Model model, HttpSession session) {
    	
    	String replaceTitle = XssDefencePolicy.defence(c.getCourseTitle());
    	String replaceDescription = XssDefencePolicy.defence(c.getDescription());
    	
    	c.setCourseTitle(replaceTitle);
    	c.setDescription(replaceDescription);
    	
    	int result = courseService.addCourse(c);
    	
    	if(result > 0) {
			session.setAttribute("alertMsg", "강의 등록 완료");
			return "redirect:/course/list";
		} else {
			model.addAttribute("errorMsg", "등록에 실패했습니다.");
			return "common/errorPage";
		}
    }
    
    //챕터 추가 페이지로 이동
    @GetMapping("addChapterView")
    public ModelAndView addChapterForm(int courseId, ModelAndView mv) {
        int nextOrder = courseService.nextOrder(courseId);

    	mv.addObject("courseId", courseId)
    	.addObject("nextOrder", nextOrder)
    	  .setViewName("course/chapterAdd");
    	return mv;
    }
    
    //챕터를 데이터베이스에 추가하는 코드
    @PostMapping("addChapter")
    public String addChapter(Chapter ch, @RequestParam(value="video", required=false) MultipartFile video, Model model, HttpSession session) {
    	
    	Attachment at = new Attachment();
    	int cnt = 0;
    	
		if(video != null && !video.isEmpty()) {
			//파일명 수정
			String changeName = FileRenamePolicy.saveFile(video, session, 
								"resources/video_upfiles/");
			String originalName = video.getOriginalFilename();
			String fileType = VideoDurationPolicy.extractExtension(originalName, changeName);
			String contentType = video.getContentType();
			
			//파일 크기 검사 (bytes)
			at.setFileSize((int) video.getSize());
			
			//영상 길이 추출 (ffprobe)
			String realPath = session.getServletContext().getRealPath("resources/video_upfiles/");
			Integer videoDuration = VideoDurationPolicy.extractVideoDurationSeconds(
					new File(realPath, changeName),
					originalName,
					contentType);

			//멤버 ID 가져오기
			Member loginUser = (Member)session.getAttribute("loginUser");
					
			at.setOriginalName(originalName);
			at.setChangedName(changeName);
			at.setFilePath("resources/video_upfiles/");
			at.setType(fileType);
			at.setVideoDuration(videoDuration);
			at.setMemberId(loginUser.getMemberId());
			cnt = 1;
		}
		
		String replaceTitle = XssDefencePolicy.defence(ch.getChapterTitle());
    	ch.setChapterTitle(replaceTitle);
    	
    	int result = courseService.addChapter(ch, at, cnt);
    	
    	if(result > 0) {
			session.setAttribute("alertMsg", "챕터 등록 완료");
			return "redirect:/course/detail?courseId=" + ch.getCourseId();
		} else {
			model.addAttribute("errorMsg", "등록에 실패했습니다.");
			return "common/errorPage";
		}
    }
    
    //코스 수정 페이지로 이동
	@GetMapping("updateCourseView")
	public ModelAndView updateForm(ModelAndView mv, @RequestParam("courseId") int courseId) {
		
		Course c = courseService.selectCourse(courseId);
		mv.addObject("c", c).setViewName("course/courseUpdate");
		return mv;
	}
    
	//코스 수정하기
	@PostMapping("updateCourse")
    public String updateCourse(Course c, Model model, HttpSession session) {
    	
    	String replaceTitle = XssDefencePolicy.defence(c.getCourseTitle());
    	String replaceDescription = XssDefencePolicy.defence(c.getDescription());
    	
    	c.setCourseTitle(replaceTitle);
    	c.setDescription(replaceDescription);
    	
    	int result = courseService.updateCourse(c);
    	System.out.println(c.getMemberId());
    	System.out.println(c.getCourseId());
    	
    	if(result > 0) {
			session.setAttribute("alertMsg", "강의 수정 완료");
			return "redirect:/course/list";
		} else {
			model.addAttribute("errorMsg", "등록에 실패했습니다.");
			return "common/errorPage";
		}
    }
	
	//코스를 삭제하는 코드
	@PostMapping("deleteCourse")
	public String deleteCourse(@RequestParam("courseId") int courseId, Model model, HttpSession session) {
		
		Member loginUser = (Member)session.getAttribute("loginUser");
		Course c = courseService.selectCourse(courseId);
		
		if(loginUser.getMemberId() != c.getMemberId()) {
			model.addAttribute("errorMsg", "삭제에 실패했습니다.");
			return "common/errorPage";
		}
		
		int result = courseService.deleteCourse(courseId);
		
		if(result > 0) {
			session.setAttribute("alertMsg", "강의 삭제 완료");
			return "redirect:/course/list";
		} else {
			model.addAttribute("errorMsg", "삭제에 실패했습니다.");
			return "common/errorPage";
		}
		
	}
}
