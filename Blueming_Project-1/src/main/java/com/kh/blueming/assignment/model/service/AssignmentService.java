package com.kh.blueming.assignment.model.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.kh.blueming.attachment.model.vo.Attachment;
import com.kh.blueming.assignment.model.dao.AssignmentDao;
import com.kh.blueming.assignment.model.vo.Assignment;
import com.kh.blueming.common.template.FileRenamePolicy;

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
                                                      boolean isAdmin) {
        return assignmentDao.selectAssignmentList(sqlSession,
                                                  currentPage,
                                                  assignmentLimit,
                                                  keyword,
                                                  targetType,
                                                  memberId,
                                                  departmentId,
                                                  positionId,
                                                  isAdmin);
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

        Map<String, Object> latestSubmission = assignmentDao.selectLatestSubmissionInfo(sqlSession, lookupMap);

        Integer submissionId = null;
        Integer currentFileId = null;
        if (latestSubmission != null) {
            Object submissionObj = latestSubmission.get("submissionId");
            Object fileObj = latestSubmission.get("fileId");

            if (submissionObj instanceof Number) {
                submissionId = ((Number) submissionObj).intValue();
            }
            if (fileObj instanceof Number) {
                currentFileId = ((Number) fileObj).intValue();
            }
        }

        Integer fileId = currentFileId;

        if (upfile != null && !upfile.isEmpty()) {
            Attachment attachment = new Attachment();
            String changedName = FileRenamePolicy.saveFile(upfile, session, "/resources/upload-submission/");

            String originalName = upfile.getOriginalFilename();
            if (originalName == null || originalName.isBlank()) {
                originalName = changedName;
            }
            int dotIndex = (originalName != null) ? originalName.lastIndexOf('.') : -1;
            String ext = (dotIndex >= 0) ? originalName.substring(dotIndex + 1) : "file";
            if (ext.length() > 10) {
                ext = ext.substring(0, 10);
            }

            attachment.setOriginalName(originalName);
            attachment.setChangedName(changedName);
            attachment.setFilePath("/resources/upload-submission/");
            attachment.setFileSize((int) upfile.getSize());
            attachment.setType(ext);
            attachment.setVideoDuration(0);
            attachment.setMemberId(memberId);
            attachment.setStatus("Y");

            int attachmentResult = assignmentDao.insertAttachment(sqlSession, attachment);
            if (attachmentResult < 1) {
                return 0;
            }
            fileId = attachment.getFileId();

            if (currentFileId != null) {
                assignmentDao.updateAttachmentStatusToN(sqlSession, currentFileId);
            }
        }

        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("assignmentId", assignmentId);
        paramMap.put("memberId", memberId);
        paramMap.put("content", content);
        paramMap.put("fileId", fileId);

        if (submissionId != null) {
            paramMap.put("submissionId", submissionId);
            return assignmentDao.updateAssignmentSubmission(sqlSession, paramMap);
        }

        return assignmentDao.insertAssignmentSubmission(sqlSession, paramMap);
    }

}
