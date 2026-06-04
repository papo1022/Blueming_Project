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
import sun.util.resources.cldr.ext.CurrencyNames_en_GH;

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
			
			String replaceName = XssDefencePolicy.defence(originalName);
			
			at.setOriginalName(replaceName);
			
			//파일 크기 검사 (bytes)
			at.setFileSize((int) video.getSize());
			
			//영상 길이 추출 (ffprobe)
			String realPath = session.getServletContext().getRealPath("resources/video_upfiles/");
			Integer videoDuration = VideoDurationPolicy.extractVideoDurationSeconds(
					new File(realPath, changeName),
					replaceName,
					contentType);

			//멤버 ID 가져오기
			Member loginUser = (Member)session.getAttribute("loginUser");
			
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
    public String updateCourse(@RequestParam("courseId") int courseId, Course c, Model model, HttpSession session) {
    	
		Member loginUser = (Member)session.getAttribute("loginUser");
		
    	String replaceTitle = XssDefencePolicy.defence(c.getCourseTitle());
    	String replaceDescription = XssDefencePolicy.defence(c.getDescription());
    	
    	c.setCourseTitle(replaceTitle);
    	c.setDescription(replaceDescription);
    	
    	if(loginUser.getMemberId() != c.getMemberId()) {
			model.addAttribute("errorMsg", "본인이 작성하지 않은 게시물은 수정할 수 없습니다.");
			return "common/errorPage";
		}
    	
    	int result = courseService.updateCourse(c);
    	
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
			model.addAttribute("errorMsg", "본인이 작성하지 않은 게시물은 삭제할 수 없습니다.");
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
	
	//챕터 1개를 삭제하는 코드
	@PostMapping("deleteChapter")
	public String deleteChapter(@RequestParam("chapterId") int chapterId, Model model, HttpSession session) {
		
		Member loginUser = (Member)session.getAttribute("loginUser");
		Chapter ch = courseService.selectChapter(chapterId);
		Course c = courseService.selectCourse(ch.getCourseId());
		boolean hasOld = ch.getVideoFileId() > 0;
		
		if(loginUser.getMemberId() != c.getMemberId()) {
			model.addAttribute("errorMsg", "본인이 작성하지 않은 게시물은 삭제할 수 없습니다.");
			return "common/errorPage";
		}
		
		int result = courseService.deleteChapter(chapterId);
		
		if(result > 0) {
			if(hasOld) {
				String oldPath = ch.getFilePath();
				String oldChangeName = ch.getChangedName();
				String realPath = session.getServletContext().getRealPath(oldPath);
				
				File oldFile = new File(realPath, oldChangeName);
				
				if(oldFile.exists()) {
					System.out.println("파일을 지웁니다.");
					oldFile.delete();
				}
    		}
			session.setAttribute("alertMsg", "챕터 삭제 완료");
			return "redirect:/course/detail?courseId=" + c.getCourseId();
		} else {
			model.addAttribute("errorMsg", "삭제에 실패했습니다.");
			return "common/errorPage";
		}
	}
	
	//챕터를 수정하는 화면으로 이동
	@GetMapping("updateChapterView")
	public ModelAndView updateChapterForm(ModelAndView mv, Course c, @RequestParam("chapterId") int chapterId) {
		
		Chapter ch = courseService.selectChapter(chapterId);
		
		mv.addObject("ch", ch)
		.addObject("c", c)
		.setViewName("course/chapterUpdate");
		return mv;
	}
	
	//챕터 수정 하기
	@PostMapping("updateChapter")
	public String updateChapter(Attachment at, Chapter ch,
			@RequestParam(value="video", required=false) MultipartFile video, 
			@RequestParam(value="deleteVideo", required=false) String isDelete, 
			Model model, HttpSession session) {
	    
		//기존 객체 불러오기 (로그인 정보 / 기존 챕터 / 해당 코스)
		Member loginUser = (Member)session.getAttribute("loginUser");
		Chapter originCh = courseService.selectChapter(ch.getChapterId());
		Course c = courseService.selectCourse(originCh.getCourseId());			
		Attachment originAt = courseService.selectAttachment(originCh.getVideoFileId());
		
		//전역변수
		int result = 1;
		
		//작성자 확인
		if(loginUser.getMemberId() != c.getMemberId()) {
			model.addAttribute("errorMsg", "본인이 작성하지 않은 게시물은 수정할 수 없습니다.");
			return "common/errorPage";
		}
		
		//기존파일과 신규파일 조건 넣기
		boolean hasOld = originCh.getVideoFileId() > 0;
    	boolean hasNew = video != null && !video.isEmpty();
    	boolean ereaeFile = true;
		
    	//업로드된 파일 이름 변경하기 (올라온 영상을 객체화시키기)
		if(hasNew) {
			//파일명 수정
			String changeName = FileRenamePolicy.saveFile(video, session, 
								"resources/video_upfiles/");
			String originalName = video.getOriginalFilename();
			String fileType = VideoDurationPolicy.extractExtension(originalName, changeName);
			String contentType = video.getContentType();
			
			String replaceName = XssDefencePolicy.defence(originalName);
			
			at.setOriginalName(replaceName);
			
			//파일 크기 검사 (bytes)
			at.setFileSize((int) video.getSize());
			
			//영상 길이 추출 (ffprobe)
			String realPath = session.getServletContext().getRealPath("resources/video_upfiles/");
			Integer videoDuration = VideoDurationPolicy.extractVideoDurationSeconds(
					new File(realPath, changeName),
					replaceName,
					contentType);
			
			at.setChangedName(changeName);
			at.setFilePath("resources/video_upfiles/");
			at.setType(fileType);
			at.setVideoDuration(videoDuration);
			at.setMemberId(loginUser.getMemberId());
		}
		
		String replaceTitle = XssDefencePolicy.defence(ch.getChapterTitle());
    	ch.setChapterTitle(replaceTitle);
    	ch.setCourseId(originCh.getCourseId());
		
    	//cnt == 0 신규추가 / cnt == 1 업데이트 / cnt == 2 그대로
		// 첨부파일도 없고, 이전 파일도 없을 경우
		if(!hasOld && !hasNew) {
			result *= courseService.updateChapter(ch, at, 2);
			ereaeFile = false;
		}
		
		// 첨부파일이 없고, 새로 생김
		else if(!hasOld && hasNew) {
			result = courseService.updateChapter(ch, at, 0);
			ereaeFile = false;
		}
		
		// 첨부파일이 있고, 신규파일 없음 (제거를 희망하는 경우)
		else if(hasOld && !hasNew) {
			
			if("Y".equals(isDelete)) {
				result *= courseService.updateChapter(originCh, originAt, 3);
				result *= courseService.deleteAttachment(originCh);
			} else {
				result *= courseService.updateChapter(originCh, originAt, 2);
				ereaeFile = false;
			}
		}
		
		// 첨부파일이 있고, 파일이 변경됨
		else if(hasOld && hasNew) {
			at.setFileId(originCh.getVideoFileId());
			System.out.println("origin videoFileId : "
			        + originCh.getVideoFileId());

			System.out.println("at fileId : "
			        + at.getFileId());
			result = courseService.updateChapter(ch, at, 1);
		}
		
		System.out.println("origin courseId = " + originCh.getCourseId());
		System.out.println("ch courseId = " + ch.getCourseId());
    	
    	if(result > 0) {
    		
    		if(ereaeFile && hasOld) {
				String oldPath = originCh.getFilePath();
				String oldChangeName = originCh.getChangedName();
				String realPath = session.getServletContext().getRealPath(oldPath);
				
				File oldFile = new File(realPath, oldChangeName);
				
				if(oldFile.exists()) {
					System.out.println("파일을 지웁니다.");
					oldFile.delete();
				}
    		}

		session.setAttribute("alertMsg", "챕터 수정 완료");
		return "redirect:/course/detail?courseId=" + originCh.getCourseId();
		} else {
			model.addAttribute("errorMsg", "수정에 실패했습니다.");
			return "common/errorPage";
		}
	}
  }
