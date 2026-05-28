package com.kh.blueming.attachment.model.vo;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter 
@ToString
public class Attachment {
	private int fileId;
	private String originalName;
	private String changeName;
	private String filePath;
	private int fileSize;
	private String type;
	private int videoDuration;
	private int memberId;
	private String status;
	private Date uploadDate;
}
