package com.kh.blueming.common.model.vo;

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
public class Attatchment {
	
    private int fileId;
    private String originalName;
    private String changedName;
    private String filePath;
    private long fileSize;
    private String type;
    private int memberId;
    private String status;
    private String uploadDate;

}
