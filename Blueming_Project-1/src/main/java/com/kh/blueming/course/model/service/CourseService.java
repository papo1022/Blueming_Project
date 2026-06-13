package com.kh.blueming.course.model.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.blueming.attachment.model.vo.Attachment;
import com.kh.blueming.assignment.model.service.AssignmentService;
import com.kh.blueming.chapter.model.vo.Chapter;
import com.kh.blueming.chapter.model.vo.ChapterProgress;
import com.kh.blueming.course.model.dao.CourseDao;
import com.kh.blueming.course.model.vo.Course;

@Service
public class CourseService {

    @Autowired
    private SqlSessionTemplate sqlSession;

    @Autowired
    private CourseDao courseDao;

	@Autowired
	private AssignmentService assignmentService;
    
	public ArrayList<Course> selectCourseList(int currentPage,
											  int courseLimit,
											  String keyword,
											  String sort,
									  		  Integer memberId,
											  String departmentId,
											  String positionId,
											  boolean isAdmin,
											  boolean mineOnly) {
		return courseDao.selectCourseList(sqlSession,
										  currentPage,
										  courseLimit,
										  keyword,
										  sort,
									  	  memberId,
										  departmentId,
										  positionId,
									  	  isAdmin,
									  	  mineOnly);
    }
    
    
	public Course selectCourse(int courseId) {
		return courseDao.selectCourse(sqlSession, courseId);
	}
	
	public Attachment selectAttachmentByFileId(int fileId) {
		if (fileId <= 0) {
			return null;
		}
		return courseDao.selectAttachmentByFileId(sqlSession, fileId);
	}
	
	public ArrayList<Chapter> selectChapterList(int courseId, Integer memberId, boolean isAdmin) {
		return courseDao.selectChapterList(sqlSession, courseId, memberId, isAdmin);
	}

	/** 내부 처리용(삭제 등) — 수강률 분기 불필요 */
	public ArrayList<Chapter> selectChapterList(int courseId) {
		return courseDao.selectChapterList(sqlSession, courseId, null, true);
	}
	
	public Chapter selectChapter(int chapterId) {
		return courseDao.selectChapter(sqlSession, chapterId);
	}

	public ArrayList<Map<String, Object>> selectDepartmentOptions() {
		return courseDao.selectDepartmentOptions(sqlSession);
	}

	public ArrayList<Map<String, Object>> selectPositionOptions() {
		return courseDao.selectPositionOptions(sqlSession);
	}

	public ArrayList<Map<String, Object>> selectCourseTargetRules(int courseId) {
		return courseDao.selectCourseTargetRules(sqlSession, courseId);
	}

	@Transactional
	public int addAttachment(Attachment at) {
		if (at == null) {
			return 0;
		}
		return courseDao.addAttachment(sqlSession, at);
	}

	@Transactional
	public int updateAttachment(Attachment at) {
		if (at == null || at.getFileId() <= 0) {
			return 0;
		}
		return courseDao.updateAttachment(sqlSession, at);
	}
	
	@Transactional
	public int addCourse(Course c, String targetType, String targetValue) {
		ArrayList<Map<String, String>> rules = new ArrayList<>();
		Map<String, String> rule = new HashMap<>();
		rule.put("targetType", targetType);
		rule.put("targetValue", targetValue);
		rules.add(rule);
		return addCourse(c, rules);
	}

	@Transactional
	public int addCourse(Course c, List<Map<String, String>> targetRules) {

		int result1 = courseDao.addCourse(sqlSession, c);
		if (result1 <= 0) {
			return 0;
		}

		List<Map<String, String>> normalizedRules = normalizeTargetRules(targetRules);
		int insertedRules = 0;
		for (Map<String, String> rule : normalizedRules) {
			insertedRules += courseDao.insertCourseTarget(sqlSession,
					c.getCourseId(),
					rule.get("targetType"),
					rule.get("targetValue"));
		}

		if (insertedRules <= 0) {
			return 0;
		}

		courseDao.insertEnrollmentByCourseTargets(sqlSession, c.getCourseId());
		return 1;
	}

	@Transactional
	public int syncEnrollmentByMember(int memberId) {
		if (memberId <= 0) {
			return 0;
		}
		return courseDao.syncEnrollmentByMember(sqlSession, memberId);
	}

	public int nextOrder(int courseId) {
		return courseDao.nextOrder(sqlSession, courseId);
	}

	@Transactional
	public int addChapter(Chapter ch, Attachment at, int cnt) {
		
		int result1 = 1;
		int result2 = 0;
		int result3 = 0;
		if(cnt > 0) {
			result1 = courseDao.addAttachment(sqlSession, at);
			ch.setVideoFileId(at.getFileId());
			result2 = courseDao.addChapterVideo(sqlSession, ch);
		} else {
			result2 = courseDao.addChapter(sqlSession, ch);
		}
		if (result1 > 0 && result2 > 0) {
			result3 = courseDao.updateTotalHoursInMinutes(sqlSession, ch.getCourseId());
		}
		
		return result1 * result2 * result3;
	}

	@Transactional
	public int updateCourse(Course c, String targetType, String targetValue) {
		ArrayList<Map<String, String>> rules = new ArrayList<>();
		Map<String, String> rule = new HashMap<>();
		rule.put("targetType", targetType);
		rule.put("targetValue", targetValue);
		rules.add(rule);
		return updateCourse(c, rules);
	}

	@Transactional
	public int updateCourse(Course c, List<Map<String, String>> targetRules) {
		int result1 = courseDao.updateCourse(sqlSession, c);
		if (result1 <= 0) {
			return 0;
		}

		courseDao.deleteCourseTargetsByCourseId(sqlSession, c.getCourseId());
		List<Map<String, String>> normalizedRules = normalizeTargetRules(targetRules);
		int insertedRules = 0;
		for (Map<String, String> rule : normalizedRules) {
			insertedRules += courseDao.insertCourseTarget(sqlSession,
					c.getCourseId(),
					rule.get("targetType"),
					rule.get("targetValue"));
		}

		if (insertedRules <= 0) {
			return 0;
		}

		courseDao.insertEnrollmentByCourseTargets(sqlSession, c.getCourseId());
		return 1;
	}

	private List<Map<String, String>> normalizeTargetRules(List<Map<String, String>> targetRules) {
		ArrayList<Map<String, String>> normalized = new ArrayList<>();
		if (targetRules == null) {
			targetRules = new ArrayList<>();
		}

		for (Map<String, String> rule : targetRules) {
			if (rule == null) {
				continue;
			}
			String rawType = rule.get("targetType");
			String type = normalizeTargetType(rawType);
			String value = rule.get("targetValue");
			if (value != null) {
				value = value.trim();
				if (value.isBlank()) {
					value = null;
				}
			}

			// COURSE_TARGET 제약조건(전체/부서/직급, TARGET_VALUE 길이 3) 범위로 안전 변환
			if ("DEPT_POS".equalsIgnoreCase(rawType) && value != null && value.contains("|")) {
				String[] parts = value.split("\\|");
				if (parts.length == 2) {
					String deptId = parts[0].trim();
					String posId = parts[1].trim();
					if (!deptId.isBlank()) {
						Map<String, String> deptRule = new HashMap<>();
						deptRule.put("targetType", "부서");
						deptRule.put("targetValue", deptId);
						normalized.add(deptRule);
					}
					if (!posId.isBlank()) {
						Map<String, String> posRule = new HashMap<>();
						posRule.put("targetType", "직급");
						posRule.put("targetValue", posId);
						normalized.add(posRule);
					}
					continue;
				}
			}

			if (("부서".equals(type) || "직급".equals(type)) && value == null) {
				continue;
			}
			if ("전체".equals(type)) {
				value = null;
			}

			Map<String, String> normalizedRule = new HashMap<>();
			normalizedRule.put("targetType", type);
			normalizedRule.put("targetValue", value);
			normalized.add(normalizedRule);
		}

		if (normalized.isEmpty()) {
			Map<String, String> defaultRule = new HashMap<>();
			defaultRule.put("targetType", "전체");
			defaultRule.put("targetValue", null);
			normalized.add(defaultRule);
		}

		return normalized;
	}

	private String normalizeTargetType(String targetType) {
		if (targetType == null || targetType.isBlank()) {
			return "전체";
		}
		String type = targetType.trim().toUpperCase();
		switch (type) {
			case "전체":
			case "ALL":
			case "DEPT_ALL":
			case "POS_ALL":
				return "전체";
			case "부서":
			case "DEPT":
			case "DEPARTMENT":
				return "부서";
			case "직급":
			case "POS":
			case "POSITION":
				return "직급";
			case "DEPT_POS":
				return "DEPT_POS";
			default:
				return "전체";
		}
	}

	@Transactional
	public int deleteCourse(int courseId) {
		Course course = courseDao.selectCourse(sqlSession, courseId);
		assignmentService.deleteAssignmentsByCourseId(courseId);
		courseDao.deleteChapterProgressByCourseId(sqlSession, courseId);
		courseDao.deleteEnrollmentByCourseId(sqlSession, courseId);
		courseDao.deleteCourseTargetsByCourseId(sqlSession, courseId);
		
		ArrayList<Chapter> chapterList = courseDao.selectChapterList(sqlSession, courseId, null, true);
		courseDao.deleteAllChapter(sqlSession, courseId);
		
		for(Chapter ch : chapterList) {
			if(ch.getVideoFileId() > 0) {
				int attachmentResult = courseDao.deleteAttachment(sqlSession, ch.getVideoFileId());
				if (attachmentResult <= 0) {
					return 0;
				}
			}
		}
		
		int result3 = courseDao.deleteCourse(sqlSession, courseId);
		if (result3 <= 0) {
			return 0;
		}

		if (result3 > 0 && course != null && course.getFileId() > 0) {
			int attachmentResult = courseDao.deleteAttachment(sqlSession, course.getFileId());
			if (attachmentResult <= 0) {
				return 0;
			}
		}
		
		return 1;
		
	}
	
	@Transactional
	public int deleteChapter(int chapterId) {
		assignmentService.deleteAssignmentsByChapterId(chapterId);
		
		Chapter ch = courseDao.selectChapter(sqlSession, chapterId);
		
		int result1 = 1;
		
		int result2 = courseDao.deleteChapter(sqlSession, chapterId);
		
		if(ch.getVideoFileId() > 0) {
			result1 = courseDao.deleteAttachment(sqlSession, ch.getVideoFileId());
		}
		
		return result1 * result2;
	}

	@Transactional
	public int updateChapter(Chapter ch, Attachment at, int cnt) {
		int result1 = 1;
		int result2 = 1;
		int result3 = 1;
		
		//신규추가
		if (cnt == 0) {
			result1 = courseDao.addAttachment(sqlSession, at);
			ch.setVideoFileId(at.getFileId());
			result2 = courseDao.updateChapterVideo(sqlSession, ch);
			result3 = courseDao.updateTotalHoursInMinutes(sqlSession, ch.getCourseId());
			
			System.out.printf("%d %d %d", result1, result2, result3);
		}
		
		//업데이트
		if(cnt == 1) {
			result1 = courseDao.updateAttachment(sqlSession, at);
			ch.setVideoFileId(at.getFileId());
			result2 = courseDao.updateChapterVideo(sqlSession, ch);
			result3 = courseDao.updateTotalHoursInMinutes(sqlSession, ch.getCourseId());
			
			System.out.printf("%d %d %d", result1, result2, result3);
		}
		
		//그대로
		if (cnt == 2) {
			result1 = courseDao.updateChapter(sqlSession, ch);
		}
		
		if (cnt == 3) {
			result1 = courseDao.deleteChapterVideo(sqlSession, ch);
		}
		
		return result1 * result2 * result3;
	}

	
	@Transactional
	public int deleteAttachment(Chapter ch) {
		return courseDao.deleteAttachment(sqlSession, ch.getVideoFileId());
	}

	public Attachment selectVideoAttachmentByChapterId(int chapterId) {
		return courseDao.selectVideoAttachmentByChapterId(sqlSession, chapterId);
	}

	public int selectEnrollmentId(int memberId, int courseId) {
		return courseDao.selectEnrollmentId(sqlSession, memberId, courseId);
	}

	public ChapterProgress selectChapterProgress(int enrollmentId, int chapterId) {
		return courseDao.selectChapterProgress(sqlSession, enrollmentId, chapterId);
	}

	@Transactional
	public int upsertChapterProgress(int enrollmentId, int chapterId, int watchedSeconds,
			                          int lastPositionSeconds, double chapCompRate, String isCompleted) {
		Map<String, Object> map = new HashMap<>();
		map.put("enrollmentId", enrollmentId);
		map.put("chapterId", chapterId);
		map.put("watchedSeconds", watchedSeconds);
		map.put("lastPositionSeconds", lastPositionSeconds);
		map.put("chapCompRate", chapCompRate);
		map.put("isCompleted", isCompleted);
		return courseDao.upsertChapterProgress(sqlSession, map);
	}

	
	@Transactional
	public int updateCourseStatus() {
		return courseDao.updateCourseStatus(sqlSession);
	}
	
	@Transactional
	public int reorderChapters(int courseId, int[] chapterIds, int[] chapterOrders) {
		if (courseId <= 0 || chapterIds == null || chapterOrders == null || chapterIds.length != chapterOrders.length) {
			return 0;
		}

		for (int i = 0; i < chapterIds.length; i++) {
			Chapter ch = new Chapter();
			ch.setCourseId(courseId);
			ch.setChapterId(chapterIds[i]);
			ch.setChapterOrder(chapterOrders[i]);
			if (courseDao.orderChapter(sqlSession, ch) <= 0) {
				return 0;
			}
		}

		return 1;
	}
}
