<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<jsp:include page="../common/mainMenubar.jsp" />

<div class="outer">
		
		<br>
		<h2 align="center">공지사항 작성</h2>
		<br>
		
	
		<form id="enroll-form" action="/blueming/notice/insert" method="post">

			
			<input type="hidden" name="memberId" 
				   value="${ sessionScope.loginUser.memberId }"> 
			
 			<table class="table">
				<tr>
					<th>제목</th>
					<td>
						<input type="text" name="noticeTitle" required>
					</td>
				</tr>
				<tr>
					<th>내용</th>
					<td>
						<textarea name="content" required></textarea>
					</td>
				</tr>
			</table>

			<br><br>

			<div align="center">
				<button type="submit" class="btn btn-primary btn-sm">등록하기</button>
				<button type="reset" class="btn btn-secondary btn-sm">초기화</button>
				<button type="button" class="btn btn-secondary btn-sm"
						onclick="history.back();">뒤로가기</button>
				<!-- history.back() : 이전 페이지로 돌아가게 해주는 메소드 속성 -->
			</div>
			
		</form>
		
		<br><br>
		
	</div>
	
	<br><br>



</body>
</html>