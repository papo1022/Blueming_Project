<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
	body {
		margin: 0;
		height: 100vh;

		display: flex;
		justify-content: center; /* 가로 가운데 */
		align-items: center;     /* 세로 가운데 */
	}


</style>

</head>
<body>

		
	
	
		<!-- 로그인 관련 영역 -->
		<div class="login-area" align="center">
	
				
					
					<form id="login-form" action="/blueming/member/login" method="post"> 
			
						<table>
							<tr>
								<th>아이디</th>
								<td>
									<input type="text" name="userId" required value="${ cookie.saveId.value }">
									
								</td>
							</tr>
							<tr>
								<th>비밀번호</th>
								<td>
									<input type="password" name="userPwd" required>
								</td>
							</tr>
							<!-- 아이디 저장 -->
							<tr align="right">
								<th colspan="2">
									<!-- 1. 로그인 요청 시 아이디 저장 여부를 서버로 같이 넘기기 -->
									<input type="checkbox" id="saveId" name="saveId" value="y">
									<label for="saveId">아이디 저장</label>
								</th>
							</tr>
							<tr align="center">
								<th colspan="2">
									<button type="submit" class="btn btn-secondary btn-sm">로그인</button>
								</th>
							</tr>
								</tr>
							<tr align="center">
								<th colspan="2">
									<button type="button" class="btn btn-secondary btn-sm" 
														onclick="enrollpage1()">사원ID 찾기</button>
									<button type="button" class="btn btn-secondary btn-sm"
														onclick="enrollpage2()">사원PWD 찾기</button>
								</th>
							</tr>
							
						</table>
			
					</form>	
					<script>
					function enrollPage1() {
						
						// 사원ID 찾기 
						location.href = "/blueming/member/enrollForm1";
						
					}
				</script>
				<script>
					function enrollPage2() {
						
						// 사원PWD 찾기
						location.href = "/blueming/member/enrollForm2";
						
					}
				</script>	
			
		</div>
	
		<br clear="both"> <!-- float 속성 해제 -->
		<br>
	
		
		
		<script>
			$(function() {
				
				// 3. 쿠키가 있다면 요소에 아이디 저장을 표현해주기
				
				// 쿠키값들 중에서 saveId 에 대한 밸류값을 불러오기
				// > 쿠키에 담긴 값 또한 EL 구문 형식으로 불러올 수 있다!!
				let saveId = "${ cookie.saveId.value }"; 
				
				// console.log(saveId); // "admin" / ""
				
				if(saveId != "") {
					// > 쿠키에 저장된 아이디가 있다면
					
					$("#saveId").prop("checked", true);
				}
				
			});
		</script>
</body>
</html>