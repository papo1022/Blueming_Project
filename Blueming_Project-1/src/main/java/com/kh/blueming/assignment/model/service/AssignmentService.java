package com.kh.blueming.assignment.model.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;

import com.kh.blueming.attachment.model.vo.Attachment;
import com.kh.blueming.assignment.model.dao.AssignmentDao;
import com.kh.blueming.assignment.model.vo.Assignment;
import com.kh.blueming.common.template.FileRenamePolicy;
import com.kh.blueming.common.template.VideoDurationPolicy;

import jakarta.servlet.http.HttpSession;

@Service
public class AssignmentService {

    @Autowired
    private SqlSessionTemplate sqlSession;

    @Autowired
    private AssignmentDao assignmentDao;

    public ArrayList<Assignment> selectAssignmentList(int currentPage,
                                                      int assignmentLimit,
                                                      String keyword,
                                                      String targetType,
                                                      Integer memberId,
                                                      String departmentId,
                                                      String positionId,
                                                      boolean isAdmin,
                                                      boolean mineOnly) {
        return assignmentDao.selectAssignmentList(sqlSession,
                                                  currentPage,
                                                  assignmentLimit,
                                                  keyword,
                                                  targetType,
                                                  memberId,
                                                  departmentId,
                                                  positionId,
                                                  isAdmin,
                                                  mineOnly);
    }

    public ArrayList<Assignment> selectAssignmentListByChapterId(int chapterId) {
        return assignmentDao.selectAssignmentListByChapterId(sqlSession, chapterId);
    }

    public Assignment selectAssignment(int assignmentId) {
        return assignmentDao.selectAssignment(sqlSession, assignmentId);
    }

    @Transactional
    public int insertAssignment(Assignment assignment) {
        return assignmentDao.insertAssignment(sqlSession, assignment);
    }

    @Transactional
    public int updateAssignment(Assignment assignment) {
        return assignmentDao.updateAssignment(sqlSession, assignment);
    }

    @Transactional
    public int deleteAssignment(int assignmentId) {
        assignmentDao.deleteAssignmentSubmissionByAssignmentId(sqlSession, assignmentId);
        return assignmentDao.deleteAssignment(sqlSession, assignmentId);
    }

    @Transactional
    public int deleteAssignmentsByChapterId(int chapterId) {
        assignmentDao.deleteAssignmentSubmissionByChapterId(sqlSession, chapterId);
        assignmentDao.deleteAssignmentByChapterId(sqlSession, chapterId);
        return 1;
    }

    @Transactional
    public int deleteAssignmentsByCourseId(int courseId) {
        assignmentDao.deleteAssignmentSubmissionByCourseId(sqlSession, courseId);
        assignmentDao.deleteAssignmentByCourseId(sqlSession, courseId);
        return 1;
    }

    @Transactional
    public int submitAssignment(int assignmentId,
                                int memberId,
                                String content,
                                MultipartFile upfile,
                                HttpSession session) {
        Map<String, Object> lookupMap = new HashMap<>();
        lookupMap.put("assignmentId", assignmentId);
        lookupMap.put("memberId", memberId);

        Assignment latestSubmission = assignmentDao.selectLatestSubmissionInfo(sqlSession, lookupMap);

        Integer submissionId = null;
        Integer currentFileId = null;
        if (latestSubmission != null) {
            submissionId = latestSubmission.getSubmissionId();
            currentFileId = latestSubmission.getSubmittedFileId();
        }

        Integer fileId = currentFileId;
        Attachment oldAttachment = null;

        if (upfile != null && !upfile.isEmpty()) {
            if (currentFileId != null) {
                oldAttachment = assignmentDao.selectAttachmentByFileId(sqlSession, currentFileId);
            }

            Attachment attachment = new Attachment();
            String changedName = FileRenamePolicy.saveFile(upfile, session, "/resources/upload-submission/");

            String originalName = upfile.getOriginalFilename();
            if (originalName == null || originalName.isBlank()) {
                originalName = changedName;
            }
            String ext = VideoDurationPolicy.extractExtension(originalName, changedName);

            attachment.setOriginalName(originalName);
            attachment.setChangedName(changedName);
            attachment.setFilePath("/resources/upload-submission/");
            attachment.setFileSize((int) upfile.getSize());
            attachment.setType(ext);
            String contentType = upfile.getContentType();
            String realPath = session.getServletContext().getRealPath("/resources/upload-submission/");
                Integer videoDuration = VideoDurationPolicy.extractVideoDurationSeconds(
                    new File(realPath, changedName),
                    originalName,
                    contentType);
            attachment.setVideoDuration(videoDuration);
            attachment.setMemberId(memberId);
            attachment.setStatus("Y");

            int attachmentResult = assignmentDao.insertAttachment(sqlSession, attachment);
            if (attachmentResult < 1) {
                return 0;
            }
            fileId = attachment.getFileId();
        }

        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("assignmentId", assignmentId);
        paramMap.put("memberId", memberId);
        paramMap.put("content", content);
        paramMap.put("fileId", fileId);

        int result;
        if (submissionId != null) {
            paramMap.put("submissionId", submissionId);
            result = assignmentDao.updateAssignmentSubmission(sqlSession, paramMap);
        } else {
            result = assignmentDao.insertAssignmentSubmission(sqlSession, paramMap);
        }

        if (result < 1) {
            return 0;
        }

        if (upfile != null && !upfile.isEmpty() && currentFileId != null) {
            int deletedRows = assignmentDao.deleteAttachment(sqlSession, currentFileId);
            if (deletedRows < 1) {
                return 0;
            }

            if (oldAttachment != null && oldAttachment.getChangedName() != null && !oldAttachment.getChangedName().isBlank()) {
                String oldFilePath = oldAttachment.getFilePath();
                if (oldFilePath == null || oldFilePath.isBlank()) {
                    oldFilePath = "/resources/upload-submission/";
                }

                String normalizedPath = oldFilePath.startsWith("/") ? oldFilePath : "/" + oldFilePath;
                String oldRealPath = session.getServletContext().getRealPath(normalizedPath);
                if (oldRealPath == null || oldRealPath.isBlank()) {
                    oldRealPath = session.getServletContext().getRealPath("/resources/upload-submission/");
                }
                if (oldRealPath == null || oldRealPath.isBlank()) {
                    return 0;
                }

                File oldFile = new File(oldRealPath, oldAttachment.getChangedName());

                if (oldFile.exists() && !oldFile.delete()) {
                    return 0;
                }
            }
        }

        return result;
    }

}
