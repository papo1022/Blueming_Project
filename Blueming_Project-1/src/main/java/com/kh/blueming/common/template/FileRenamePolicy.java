package com.kh.blueming.common.template;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpSession;

public class FileRenamePolicy {
	
	//파일명을 수정하고 수정명을 리턴함
	public static String saveFile(MultipartFile upfile, HttpSession session
								, String path) {
		
		//원래 이름
		String originName = upfile.getOriginalFilename();
		
		//난수 구하기
		String currentTime = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
		
		int ranNum = (int)(Math.random() * 90000 + 10000);
		
		//확장자 구하기
		String ext = originName.substring(originName.lastIndexOf("."));
		
		String changeName = currentTime + ranNum + ext;
		
		//업로드 하고자 하는 서버 폴더 경로 알아내기 (resources/board_upfiles)
		//applicationScope 내장객체로부터 저장할 경로 알아내기
		//session으로부터 얻어낼 수 있음
		String savePath = session.getServletContext()
									.getRealPath(path);
		// 앞의 /는 webapp 폴더를 나타내고, 뒤 /는 해당 폴더의 내부
		
		//경로와 수정파일 합체 후 파일 업로드
		try {
			upfile.transferTo(new File(savePath + changeName));
		} catch (IllegalStateException | IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return changeName;
	}
}
