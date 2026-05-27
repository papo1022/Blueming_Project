<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h2>비밀번호 찾기</h2>
    
    
    		<form id="enroll-form" action="/myweb/member/insert" method="post">

			<table>
				<tr>
					<th>* 아이디</th>
					<td>
						<input type="text" name="userId" maxlength="12" required>
					</td>
					
				</tr>
				
				
			</table>

			<br><br>

			<div align="left">
				<button type="submit" class="btn btn-primary btn-sm" disabled>다음</button>
				<!-- 아이디 중복확인이 정확히 들어가기 전에는 회원가입버튼을 클릭하지 못하게 막음 -->
				
			</div>

		</form>

</body>
</html>