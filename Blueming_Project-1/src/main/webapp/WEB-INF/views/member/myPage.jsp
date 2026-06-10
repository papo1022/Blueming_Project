<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="//cdn.jsdelivr.net/npm/alertifyjs@1.14.0/build/alertify.min.js"></script>

<!-- CSS -->
<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.14.0/build/css/alertify.min.css"/>
<!-- Default theme -->
<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.14.0/build/css/themes/default.min.css"/>
<!-- Semantic UI theme -->
<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.14.0/build/css/themes/semantic.min.css"/>

<!-- 부트스트랩 -->
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">

<!-- 간단한 동작들을 정의해둔 JS 파일 -->
<!-- 온라인 방식 -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<!-- Popper JS -->
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>

	
	<div class="outer">
	
		<br>
		<h2 align="center">마이페이지</h2>
		<br>

		<!-- 
			* 내 정보 수정 기능 구현
			
			- 변경할 이름, 전화번호, 이메일, 주소를 입력받은 후 정보변경 버튼을 클릭하는 순간
			
			http://localhost:8006/myweb/member/update 로 POST 방식으로 요청
		-->
		<form id="mypage-form" action="/blueming/member/update" method="post">

			<!--
				* 마이페이지에서 보여질, 수정될 내용들

				- 아이디, 이름, 전화번호, 이메일, 주소
				- 단, 아이디는 수정 안되게끔 막기!!
				  (아이디는 회원 식별 용도의 데이터임 - 불변성)
				- 또한 비밀번호는 조회 X, 여기에서 수정 X
				  (비밀번호 변경 기능은 별도로 뺄 예정)
			-->

			<table>
				<tr>
					<th>* 아이디</th>
					<td>
						<input type="text" name="loginId" maxlength="12" readonly
							  			   value="${ sessionScope.loginUser.loginId }" required>
					</td>
					<td>
					</td>
				</tr>
				<tr>
					<th>* 이름</th>
					<td>
						<input type="text" name="name" maxlength="6" 
										   value="${ sessionScope.loginUser.name }" required>
					</td>
					<td></td>
				</tr>
				<tr>
					<th>&nbsp;&nbsp;&nbsp;전화번호</th>
					<td>
						<input type="text" name="phone" 
										   value="${ sessionScope.loginUser.phone }" placeholder="- 포함해서 입력">
					</td>
					<td></td>
				</tr>
				<tr>
					<th>&nbsp;&nbsp;&nbsp;이메일</th>
					<td>
						<input type="email" name="email"
											value="${ sessionScope.loginUser.email }">
					</td>
					<td></td>
				</tr>
				<tr>
					<th>&nbsp;&nbsp;&nbsp;주소</th>
					<td>
						<input type="text" name="address"
										   value="${ sessionScope.loginUser.address }">
					</td>
					<td></td>
				</tr>
			</table>

			<br><br>

			<div align="center">
				<button type="button"
					        class="btn btn-primary btn-sm"
					        data-toggle="modal"
					        data-target="#updateInfoModal">
					    정보변경
				</button>
				<button type="button"
						class="btn btn-warning btn-sm"
						data-toggle="modal" data-target="#updatePwdForm">비밀번호변경</button>
				
			</div>

		</form>

		<br><br>

	</div>

	<br><br>
	

	
	<!-- 비번변경용 모달창 -->
	<!-- The Modal -->
	<div class="modal" id="updatePwdForm">
	  <div class="modal-dialog">
	    <div class="modal-content">
	
	      <!-- Modal Header -->
	      <div class="modal-header">
	        <h4 class="modal-title">비밀번호 변경</h4>
	        <button type="button" class="close" data-dismiss="modal">&times;</button>
	      </div>
	
	      <!-- Modal body -->
	      <div class="modal-body" align="center">
	        
	        <!-- 
	        	* 비밀번호 변경 기능 구현
	        	
	        	- 사용자가 현재 비밀번호, 변경할 비밀번호, 변경할 비밀번호 재입력을 입력하고 나서
	        	  비밀번호 변경 버튼을 클릭 시
	        	  
	        	  http://localhost:8006/myweb/member/updatePwd 로 POST 방식으로 요청
	        -->
	        <form action="/blueming/member/updatePwd" method="post">
	        	
	        	<!-- 
	        		* 비밀번호 변경 시 입력받아야 되는 것들
	        		- 현재 비밀번호, 변경할 비밀번호, 변경할 비밀번호 재입력
	        		- 누구의 비번을 변경할건지 해당 회원의 아이디도 필요하긴 함!!
	        		  (아이디를 input type="hidden" 을 통해 눈에 보이지 않게 같이 몰래 넘기는 것)
	        	-->
	        	
	        	<input type="hidden" name=loginId value="${ loginUser.loginId }">
	        	
	        	<table>
	        		<tr>
	        			<th>현재 비밀번호</th>
	        			<td>
	        				<input type="password" name="loginPwd" required>
	        			</td>
	        		</tr>
	        		<tr>
	        			<th>변경할 비밀번호</th>
	        			<td>
	        				<input type="password" name="updatePwd" required>
	        			</td>
	        		</tr>
	        		<tr>
	        			<th>변경할 비밀번호 재입력</th>
	        			<td>
	        				<input type="password" name="checkPwd" required>
	        			</td>
	        		</tr>
	        	</table>
	        	
	        	<br><br>
	        	
	        	<div align="center">
	        		<button type="submit" class="btn btn-secondary btn-sm"
	        				onclick="return validatePwd();">
	        			비밀번호 변경
	        		</button>
	        	</div>
	        	
	        </form>

	        
	        <script>
	        	// 변경할 비밀번호 유효성 검사용 함수
	        	// > 변경할 비밀번호와 변경할 비밀번호 재입력이 일치할 경우 true, 아닐 경우 false 반환
	        	function validatePwd() {
	        		
	        		// 우선 변경할 비밀번호와 변경할 비밀번호 재입력값을 변수에 담아오기
	        		let updatePwd = $("input[name=updatePwd]").val();
	        		let checkPwd = $("input[name=checkPwd]").val();
	        		
	        		// console.log(updatePwd, checkPwd);
	        		
	        		// 두 값이 일치하면 기본이벤트를 살리고, 두 값이 일치하지 않으면 기본이벤트를 제거할 것
	        		if(updatePwd != checkPwd) {
	        			
	        			alertify.alert("비밀번호가 일치하지 않습니다.");
	        			
	        			return false;
	        		}
	        		
	        		return true;
	        	}
	        </script>
	        
	      </div>
	
	    </div>
	  </div>
	</div>
					        <!-- 정보 변경 확인 모달 -->
				<div class="modal fade" id="updateInfoModal">
				    <div class="modal-dialog modal-dialog-centered">
				        <div class="modal-content">
				
				            <!-- 헤더 -->
				            <div class="modal-header">
				                <h5 class="modal-title">정보 변경 확인</h5>
				                <button type="button" class="close" data-dismiss="modal">
				                    &times;
				                </button>
				            </div>
				
				            <!-- 내용 -->
				            <div class="modal-body text-center">
				                입력한 정보로 변경하시겠습니까?
				            </div>
				
				            <!-- 버튼 -->
				            <div class="modal-footer">
				                <button type="button"
				                        class="btn btn-secondary"
				                        data-dismiss="modal">
				                    취소
				                </button>
				
				                <button type="button"
				                        class="btn btn-primary"
				                        onclick="submitMyPageForm();">
				                    확인
				                </button>
				            </div>
				
				        </div>
				    </div>
				</div>
				<script>
    function submitMyPageForm() {
        document.getElementById("mypage-form").submit();
    }
</script>
</body>
</html>