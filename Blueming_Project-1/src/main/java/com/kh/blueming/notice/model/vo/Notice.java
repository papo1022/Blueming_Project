package com.kh.blueming.notice.model.vo;

import java.sql.Date;




public class Notice {
	
	private int noticeId;					//	NOTICE_ID	NUMBER
	private String noticeTitle;			//	NOTICE_TITLE	VARCHAR2(50 BYTE)
	private String content;				//	CONTENT	VARCHAR2(2000 BYTE)
	private int memberId;				//	MEMBER_ID	NUMBER
	private int count;					//	COUNT	NUMBER
	private Date createdDate;			//	CREATED_DATE	DATE
	private Date updatedDate;			//	UPDATED_DATE	DATE
	private int fileIdNumber;			//	FILE_ID	NUMBER
	private String Status; 				//	STATUS	VARCHAR2(1 BYTE)
	
	
	public Notice() {}
	

	
	
	public Notice(int noticeId, String noticeTitle, String content, int memberId, int count, Date createdDate,
			Date updatedDate, int fileIdNumber, String status) {
		super();
		this.noticeId = noticeId;
		this.noticeTitle = noticeTitle;
		this.content = content;
		this.memberId = memberId;
		this.count = count;
		this.createdDate = createdDate;
		this.updatedDate = updatedDate;
		this.fileIdNumber = fileIdNumber;
		this.Status = status;
	}

	
	
	public int getNoticeId() {
		return noticeId;
	}
	public void setNoticeId(int noticeId) {
		this.noticeId = noticeId;
	}
	public String getNoticeTitle() {
		return noticeTitle;
	}
	public void setNoticeTitle(String noticeTitle) {
		this.noticeTitle = noticeTitle;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public int getMemberId() {
		return memberId;
	}
	public void setMemberId(int memberId) {
		this.memberId = memberId;
	}
	public int getCount() {
		return count;
	}
	public void setCount(int count) {
		this.count = count;
	}
	public Date getCreatedDate() {
		return createdDate;
	}
	public void setCreatedDate(Date createdDate) {
		this.createdDate = createdDate;
	}
	public Date getUpdatedDate() {
		return updatedDate;
	}
	public void setUpdatedDate(Date updatedDate) {
		this.updatedDate = updatedDate;
	}
	public int getFileIdNumber() {
		return fileIdNumber;
	}
	public void setFileIdNumber(int fileIdNumber) {
		this.fileIdNumber = fileIdNumber;
	}
	public String getStatus() {
		return Status;
	}
	public void setStatus(String status) {
		Status = status;
	}
	
	@Override
	public String toString() {
		return "Notice [noticeId=" + noticeId + ", noticeTitle=" + noticeTitle + ", content=" + content + ", memberId="
				+ memberId + ", count=" + count + ", createdDate=" + createdDate + ", updatedDate=" + updatedDate
				+ ", fileIdNumber=" + fileIdNumber + ", Status=" + Status + "]";
	}


}