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
    
    
    		<form id="enroll-form" action="/blueming/member/insert" method="post">

			<table>
				<tr>
					<th>* 아이디</th>
					<td>
						<input type="text" name="loginId" maxlength="12" required>
					</td>
					
				</tr>
				
				
			</table>

			<br><br>

			<div align="left">
				<button type="submit" class="btn btn-primary btn-sm" disabled>다음</button>
				
				
			</div>

		</form>

</body>
</html>