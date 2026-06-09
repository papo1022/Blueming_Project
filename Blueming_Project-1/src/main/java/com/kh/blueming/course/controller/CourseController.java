package com.kh.blueming.course.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import com.kh.blueming.attachment.model.vo.Attachment;
import com.kh.blueming.assignment.model.service.AssignmentService;
import com.kh.blueming.assignment.model.vo.Assignment;
import com.kh.blueming.assignment.model.vo.AssignmentSubmission;
import com.kh.blueming.chapter.model.vo.Chapter;
import com.kh.blueming.chapter.model.vo.ChapterProgress;
import com.kh.blueming.common.template.FileRenamePolicy;
import com.kh.blueming.common.template.VideoDurationPolicy;
import com.kh.blueming.common.template.XssDefencePolicy;
import com.kh.blueming.course.model.service.CourseService;
import com.kh.blueming.course.model.vo.Course;
import com.kh.blueming.member.model.vo.Member;

import jakarta.servlet.http.HttpSession;
// import sun.util.resources.cldr.ext.CurrencyNames_en_GH;

@Controller
@RequestMapping("course")
public class CourseController {

    @Autowired
    private CourseService courseService;

	@Autowired
	private AssignmentService assignmentService;

	private boolean canManageCourse(Member loginUser, Course course) {
		return loginUser != null
			&& course != null
			&& ("S".equals(loginUser.getRole()) || loginUser.getMemberId() == course.getMemberId());
	}

	private List<Map<String, String>> parseTargetRules(String targetRulesJson, String legacyTargetType, String legacyTargetValue) {
		if (targetRulesJson != null && !targetRulesJson.isBlank()) {
			try {
				ObjectMapper objectMapper = new ObjectMapper();
				return objectMapper.readValue(targetRulesJson, new TypeReference<List<Map<String, String>>>() {});
			} catch (Exception ignored) {
				// JSON 파싱 실패 시, legacy 방식으로 처리
			}
		}

		ArrayList<Map<String, String>> legacyRules = new ArrayList<>();
		Map<String, String> rule = new HashMap<>();
		rule.put("targetType", legacyTargetType);
		rule.put("targetValue", legacyTargetValue);
		legacyRules.add(rule);
		return legacyRules;
	}

	private String getRuleValueIgnoreCase(Map<String, Object> source, String... candidates) {
		if (source == null || candidates == null) {
			return null;
		}
		for (String key : candidates) {
			if (key == null) {
				continue;
			}
			for (Map.Entry<String, Object> entry : source.entrySet()) {
				if (entry.getKey() != null && entry.getKey().equalsIgnoreCase(key)) {
					Object value = entry.getValue();
					return value == null ? null : String.valueOf(value);
				}
			}
		}
		return null;
	}

	private ArrayList<Map<String, String>> normalizeTargetRulesForView(List<Map<String, Object>> rawRules) {
		ArrayList<Map<String, String>> normalized = new ArrayList<>();
		if (rawRules == null) {
			return normalized;
		}
		for (Map<String, Object> raw : rawRules) {
			String type = getRuleValueIgnoreCase(raw, "targetType", "target_type", "TARGETTYPE", "TARGET_TYPE");
			String value = getRuleValueIgnoreCase(raw, "targetValue", "target_value", "TARGETVALUE", "TARGET_VALUE");
			if (type == null || type.isBlank()) {
				continue;
			}
			Map<String, String> rule = new HashMap<>();
			rule.put("targetType", type);
			rule.put("targetValue", value);
			normalized.add(rule);
		}
		return normalized;
	}

	private void deletePhysicalFile(HttpSession session, Attachment attachment) {
		if (attachment == null || attachment.getChangedName() == null || attachment.getChangedName().isBlank()) {
			return;
		}
		String filePath = attachment.getFilePath();
		if (filePath == null || filePath.isBlank()) {
			return;
		}
		String normalizedPath = filePath.startsWith("/") ? filePath : "/" + filePath;
		String realPath = session.getServletContext().getRealPath(normalizedPath);
		if (realPath == null || realPath.isBlank()) {
			return;
		}
		File file = new File(realPath, attachment.getChangedName());
		if (file.exists()) {
			file.delete();
		}
	}

	private Attachment buildCourseThumbnailAttachment(MultipartFile thumbnail, Member loginUser, HttpSession session) {
		if (thumbnail == null || thumbnail.isEmpty() || loginUser == null) {
			return null;
		}

		String changeName = FileRenamePolicy.saveFile(thumbnail, session, "resources/course-thumbnail/");
		if (changeName == null || changeName.isBlank()) {
			return null;
		}

		String originalName = thumbnail.getOriginalFilename();
		if (originalName == null || originalName.isBlank()) {
			originalName = changeName;
		}

		Attachment attachment = new Attachment();
		attachment.setOriginalName(XssDefencePolicy.defence(originalName));
		attachment.setChangedName(changeName);
		attachment.setFilePath("resources/course-thumbnail/");
		attachment.setFileSize((int) thumbnail.getSize());
		attachment.setType(VideoDurationPolicy.extractExtension(originalName, changeName));
		attachment.setVideoDuration(null);
		attachment.setMemberId(loginUser.getMemberId());
		return attachment;
	}


    //리스트들을 띄우는 코드
    @GetMapping("list")
    public ModelAndView selectCourseList(@RequestParam(value = "keyword", required = false) String keyword,
                                         @RequestParam(value = "sort", defaultValue = "latest") String sort,
						 				 @RequestParam(value = "mineOnly", defaultValue = "false") boolean mineOnly,
                                         ModelAndView mv) {
        if (!"oldest".equals(sort)) {
                sort = "latest";
        }

        mv.addObject("keyword", keyword)
          .addObject("sort", sort)
		  .addObject("mineOnly", mineOnly)
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
		    @RequestParam(value = "mineOnly", defaultValue = "false") boolean mineOnly,
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
		Integer memberId = (loginUser != null) ? loginUser.getMemberId() : null;
        boolean isAdmin = loginUser != null && "S".equals(loginUser.getRole());
		boolean mineOnlyFilter = mineOnly && loginUser != null;

        return courseService.selectCourseList(currentPage,
                                              courseLimit,
                                              keyword,
                                              sort,
					      					  memberId,
                                              departmentId,
                                              positionId,
						  					  isAdmin,
						  					  mineOnlyFilter);
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
    public ModelAndView selectChapter(@RequestParam("chapterId") int chapterId, ModelAndView mv, HttpSession session) {
    	Chapter chapter = courseService.selectChapter(chapterId);
		ArrayList<Assignment> assignmentList = assignmentService.selectAssignmentListByChapterId(chapterId);

		// 영상 첨부파일 조회
		Attachment videoAttachment = null;
		if (chapter != null && chapter.getVideoFileId() > 0) {
			videoAttachment = courseService.selectVideoAttachmentByChapterId(chapterId);
		}

		// 수강자의 기존 진도 조회 (로그인 + 수강 중인 경우)
		ChapterProgress existingProgress = null;
		int enrollmentId = 0;
		Member loginUser = (Member) session.getAttribute("loginUser");
		if (loginUser != null && chapter != null) {
			enrollmentId = courseService.selectEnrollmentId(loginUser.getMemberId(), chapter.getCourseId());
			if (enrollmentId > 0) {
				existingProgress = courseService.selectChapterProgress(enrollmentId, chapterId);
			}
		}

    	mv.addObject("chapter", chapter)
		  .addObject("assignmentList", assignmentList)
		  .addObject("videoAttachment", videoAttachment)
		  .addObject("existingProgress", existingProgress)
		  .addObject("enrollmentId", enrollmentId)
    	  .setViewName("course/chapterDetailView");
    	
    	return mv;
    }
    
    //코스 추가 페이지로 이동
    @GetMapping("addCourseView")
    public ModelAndView addForm(ModelAndView mv) {
    	mv.addObject("deptOptions", courseService.selectDepartmentOptions())
    	  .addObject("positionOptions", courseService.selectPositionOptions())
    	  .setViewName("course/courseAdd");
    	return mv;
    }
    
    //코스를 데이터베이스에 추가하는 코드 (완료)
    @PostMapping("addCourse")
	public String addCourse(Course c,
						@RequestParam(value = "thumbnail", required = false) MultipartFile thumbnail,
						@RequestParam(value = "targetRulesJson", required = false) String targetRulesJson,
						@RequestParam(value = "targetType", defaultValue = "전체") String targetType,
						@RequestParam(value = "targetValue", required = false) String targetValue,
						Model model,
						HttpSession session) {
		Member loginUser = (Member) session.getAttribute("loginUser");
		if (loginUser == null) {
			model.addAttribute("errorMsg", "로그인이 필요합니다.");
			return "common/errorPage";
		}
		c.setMemberId(loginUser.getMemberId());
    	
    	String replaceTitle = XssDefencePolicy.defence(c.getCourseTitle());
    	String replaceDescription = XssDefencePolicy.defence(c.getDescription());
    	
    	c.setCourseTitle(replaceTitle);
    	c.setDescription(replaceDescription);

		Attachment thumbnailAttachment = buildCourseThumbnailAttachment(thumbnail, loginUser, session);
		if (thumbnailAttachment != null) {
			int attachmentResult = courseService.addAttachment(thumbnailAttachment);
			if (attachmentResult <= 0) {
				model.addAttribute("errorMsg", "썸네일 저장에 실패했습니다.");
				return "common/errorPage";
			}
			c.setFileId(thumbnailAttachment.getFileId());
		} else {
			c.setFileId(0);
		}

		List<Map<String, String>> targetRules = parseTargetRules(targetRulesJson, targetType, targetValue);
    	
		int result = courseService.addCourse(c, targetRules);
    	
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
    public ModelAndView addChapterForm(int courseId, ModelAndView mv, HttpSession session) {
		Member loginUser = (Member) session.getAttribute("loginUser");
		Course course = courseService.selectCourse(courseId);
		if (!canManageCourse(loginUser, course)) {
			mv.addObject("errorMsg", "챕터를 등록할 권한이 없습니다.")
			  .setViewName("common/errorPage");
			return mv;
		}

        int nextOrder = courseService.nextOrder(courseId);

    	mv.addObject("courseId", courseId)
    	.addObject("nextOrder", nextOrder)
    	  .setViewName("course/chapterAdd");
    	return mv;
    }
    
    //챕터를 데이터베이스에 추가하는 코드
    @PostMapping("addChapter")
    public String addChapter(Chapter ch, @RequestParam(value="video", required=false) MultipartFile video, Model model, HttpSession session) {
		Member loginUser = (Member)session.getAttribute("loginUser");
		if (loginUser == null) {
			model.addAttribute("errorMsg", "로그인이 필요합니다.");
			return "common/errorPage";
		}

		Course course = courseService.selectCourse(ch.getCourseId());
		if (!canManageCourse(loginUser, course)) {
			model.addAttribute("errorMsg", "챕터를 등록할 권한이 없습니다.");
			return "common/errorPage";
		}
    	
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
	public ModelAndView updateForm(ModelAndView mv, @RequestParam("courseId") int courseId, HttpSession session) {
		Member loginUser = (Member) session.getAttribute("loginUser");
		Course c = courseService.selectCourse(courseId);
		if (!canManageCourse(loginUser, c)) {
			mv.addObject("errorMsg", "강의를 수정할 권한이 없습니다.")
			  .setViewName("common/errorPage");
			return mv;
		}
		
		ArrayList<Map<String, String>> targetRules = normalizeTargetRulesForView(courseService.selectCourseTargetRules(courseId));
		Attachment thumbnailAttachment = courseService.selectAttachmentByFileId(c.getFileId());

		mv.addObject("c", c)
		  .addObject("deptOptions", courseService.selectDepartmentOptions())
		  .addObject("positionOptions", courseService.selectPositionOptions())
		  .addObject("thumbnailAttachment", thumbnailAttachment)
		  .addObject("targetRules", targetRules)
		  .setViewName("course/courseUpdate");
		return mv;
	}
    
	//코스 수정하기
	@PostMapping("updateCourse")
	public String updateCourse(Course c,
						@RequestParam(value = "thumbnail", required = false) MultipartFile thumbnail,
						@RequestParam(value = "targetRulesJson", required = false) String targetRulesJson,
						@RequestParam(value = "targetType", defaultValue = "전체") String targetType,
						@RequestParam(value = "targetValue", required = false) String targetValue,
						Model model,
						HttpSession session) {
    	
		Member loginUser = (Member)session.getAttribute("loginUser");
		Course existingCourse = courseService.selectCourse(c.getCourseId());
		if (existingCourse == null) {
			model.addAttribute("errorMsg", "강의 정보를 찾을 수 없습니다.");
			return "common/errorPage";
		}
		if (!canManageCourse(loginUser, existingCourse)) {
			model.addAttribute("errorMsg", "강의를 수정할 권한이 없습니다.");
			return "common/errorPage";
		}

		// 작성자 ID는 서버 기준으로 고정
		c.setMemberId(existingCourse.getMemberId());
		
    	String replaceTitle = XssDefencePolicy.defence(c.getCourseTitle());
    	String replaceDescription = XssDefencePolicy.defence(c.getDescription());
    	
	    c.setCourseId(existingCourse.getCourseId());
    	c.setCourseTitle(replaceTitle);
    	c.setDescription(replaceDescription);
		c.setFileId(existingCourse.getFileId());

		Attachment oldThumbnailAttachment = null;
		Attachment newThumbnailAttachment = buildCourseThumbnailAttachment(thumbnail, loginUser, session);
		if (newThumbnailAttachment != null) {
			if (existingCourse.getFileId() > 0) {
				newThumbnailAttachment.setFileId(existingCourse.getFileId());
				oldThumbnailAttachment = courseService.selectAttachmentByFileId(existingCourse.getFileId());
				int attachmentResult = courseService.updateAttachment(newThumbnailAttachment);
				if (attachmentResult <= 0) {
					model.addAttribute("errorMsg", "썸네일 수정에 실패했습니다.");
					return "common/errorPage";
				}
			} else {
				int attachmentResult = courseService.addAttachment(newThumbnailAttachment);
				if (attachmentResult <= 0) {
					model.addAttribute("errorMsg", "썸네일 저장에 실패했습니다.");
					return "common/errorPage";
				}
				c.setFileId(newThumbnailAttachment.getFileId());
			}
		}

		List<Map<String, String>> targetRules = parseTargetRules(targetRulesJson, targetType, targetValue);

		int result = courseService.updateCourse(c, targetRules);
    	
    	if(result > 0) {
			if (oldThumbnailAttachment != null
					&& oldThumbnailAttachment.getChangedName() != null
					&& newThumbnailAttachment != null
					&& newThumbnailAttachment.getChangedName() != null
					&& !oldThumbnailAttachment.getChangedName().equals(newThumbnailAttachment.getChangedName())) {
				deletePhysicalFile(session, oldThumbnailAttachment);
			}
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
		ArrayList<Attachment> attachmentsToDelete = new ArrayList<>();
		
		if(!canManageCourse(loginUser, c)) {
			model.addAttribute("errorMsg", "강의를 삭제할 권한이 없습니다.");
			return "common/errorPage";
		}

		ArrayList<Chapter> chapterList = courseService.selectChapterList(courseId);
		if (c != null && c.getFileId() > 0) {
			Attachment thumbnailAttachment = courseService.selectAttachmentByFileId(c.getFileId());
			if (thumbnailAttachment != null) {
				attachmentsToDelete.add(thumbnailAttachment);
			}
		}

		for (Chapter chapter : chapterList) {
			if (chapter.getVideoFileId() > 0) {
				Attachment videoAttachment = courseService.selectAttachmentByFileId(chapter.getVideoFileId());
				if (videoAttachment != null) {
					attachmentsToDelete.add(videoAttachment);
				}
			}
		}
		
		int result = courseService.deleteCourse(courseId);
		
		if(result > 0) {
			for (Attachment attachment : attachmentsToDelete) {
				deletePhysicalFile(session, attachment);
			}
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
		
		if(!canManageCourse(loginUser, c)) {
			model.addAttribute("errorMsg", "챕터를 삭제할 권한이 없습니다.");
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
		Attachment originAt = courseService.selectAttachmentByFileId(originCh.getVideoFileId());
		
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

	
	// 챕터 시청 진도 저장 (Ajax)
	@ResponseBody
	@PostMapping("saveProgress")
	public Map<String, Object> saveProgress(
			@RequestParam("chapterId") int chapterId,
			@RequestParam(value = "enrollmentId", defaultValue = "0") int enrollmentId,
			@RequestParam("watchedSeconds") int watchedSeconds,
			@RequestParam("lastPositionSeconds") int lastPositionSeconds,
			@RequestParam("videoDuration") int videoDuration,
			HttpSession session) {

		Map<String, Object> result = new HashMap<>();
		Member loginUser = (Member) session.getAttribute("loginUser");

		if (loginUser == null) {
			result.put("success", false);
			result.put("message", "로그인이 필요합니다.");
			return result;
		}

		if ("S".equals(loginUser.getRole())) {
			result.put("success", false);
			result.put("message", "관리자 계정은 진도 저장 대상이 아닙니다.");
			return result;
		}

		Chapter chapter = courseService.selectChapter(chapterId);
		if (chapter == null) {
			result.put("success", false);
			result.put("message", "챕터 정보를 찾을 수 없습니다.");
			return result;
		}

		if (enrollmentId <= 0) {
			enrollmentId = courseService.selectEnrollmentId(loginUser.getMemberId(), chapter.getCourseId());
		}

		if (enrollmentId <= 0) {
			result.put("success", false);
			result.put("message", "수강 정보가 없어 진도를 저장할 수 없습니다.");
			return result;
		}

		// 진도는 단조 증가해야 하므로 기존 저장값보다 작은 요청은 무시(최댓값 유지)
		ChapterProgress existing = courseService.selectChapterProgress(enrollmentId, chapterId);
		if (existing != null) {
			watchedSeconds = Math.max(watchedSeconds, existing.getWatchedSeconds());
		}

		double chapCompRate = (videoDuration > 0)
				? Math.min(((double) watchedSeconds / videoDuration) * 100, 100.0)
				: 0.0;
		if (existing != null) {
			chapCompRate = Math.max(chapCompRate, existing.getChapCompRate());
		}
		chapCompRate = Math.round(chapCompRate * 100.0) / 100.0;
		String isCompleted = chapCompRate >= 90.0 ? "Y" : "N";
		if (existing != null && "Y".equals(existing.getIsCompleted())) {
			isCompleted = "Y";
		}

		int rows = courseService.upsertChapterProgress(enrollmentId, chapterId,
				watchedSeconds, lastPositionSeconds, chapCompRate, isCompleted);

		result.put("success", rows > 0);
		result.put("watchedSeconds", watchedSeconds);
		result.put("chapCompRate", chapCompRate);
		result.put("isCompleted", isCompleted);
		return result;
	}


	
	/*************************************************/
	
	@ResponseBody
	@PostMapping("avgAssignmentSubmissionRate")
	public double avgAssignmentSubmissionRate(@RequestParam("chapterId") int chapterId) {
		Chapter chapter =
			    courseService.selectChapter(chapterId);
		System.out.println(chapter);

		return chapter.getAvgAssignmentSubmissionRate();
	}
}
