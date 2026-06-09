<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>

/* ===== 전체 ===== */
body{
    background:#f5f6f8;
    margin:0;
    padding:0;
}

/* ===== 본문 ===== */
.outer{
    margin-left:250px;
    padding:20px 30px;
}

/* ===== 제목 ===== */
.outer h2{
    text-align:center;
    font-weight:700;
    margin-bottom:15px;
}

/* ===== 검색영역 ===== */
#search-area{
    text-align:center;
    margin-bottom:10px;
}

#search-area form{
    display:inline-flex;
    align-items:center;
    gap:8px;
}

#search-area select{
    height:40px;
    border:1px solid #ddd;
    border-radius:20px;
    padding:0 15px;
}

#search-area input{
    width:320px;
    height:40px;
    border:1px solid #ddd;
    border-radius:20px;
    padding:0 15px;
}

#search-area button{
    height:40px;
    border-radius:20px;
}

/* ===== 글작성 버튼 ===== */
.write-btn-area{
    width:95%;
    margin:0 auto 8px auto;
    text-align:right;
}

/* ===== 게시글 테이블 ===== */
.list-area{
    width:95%;
    margin:auto;
    background:white;
    border-radius:15px;
    overflow:hidden;
    box-shadow:0 2px 8px rgba(0,0,0,0.08);
}

/* ===== 헤더 ===== */
.list-area thead th{
    text-align:center;
    height:50px;
    border:none;
    background:#fafafa;
    font-size:14px;
}

/* ===== 본문 ===== */
.list-area tbody td{
    height:45px;
    padding:8px 12px;
    vertical-align:middle;
    border-top:1px solid #f0f0f0;
    font-size:14px;
}

.list-area tbody tr:hover{
    background:#f8fbff;
    cursor:pointer;
}

/* ===== 번호 배지 ===== */
.notice-badge{
    background:#4fd1c5;
    color:white;
    border-radius:15px;
    padding:5px 12px;
    font-size:12px;
    font-weight:bold;
}

/* ===== 페이징 ===== */
.paging-area{
    margin-left:250px;
    margin-top:10px;
}

.pagination{
    margin-top:0;
    margin-bottom:0;
}

.pagination .page-link{
    border:none;
    background:none;
    color:#666;
}

.pagination .page-item.active .page-link{
    background:#4fd1c5;
    color:white;
    border-radius:50%;
    width:35px;
    height:35px;
    line-height:22px;
}

/* ===== 공백 제거 ===== */
br{
    display:none;
}

.list-area th,
.list-area td{
    text-align:center;
    vertical-align:middle;
}

</style>
</head>
<body>
	
	<jsp:include page="../common/mainMenubar.jsp" />
	
<div class="outer">

    <h2 align="center">공지사항</h2>
    <br>
		


		<br><br>

		<!-- 검색창을 만들 부분 -->
		<div id="search-area" align="center">
		
			
			
			<form action="/blueming/notice/search" method="get">
				
				<!-- 검색 시 검색 조건과 검색어를 입력받고 검색버튼을 클릭함!! -->
				<select name="condition">
					<option value="title">제목</option>
					<option value="content">내용</option>
				</select>
				
				<input type="search" name="keyword" value="${ requestScope.keyword }">
				<!-- 
					- EL 구문은 꺼내올 응답데이터가 없다면 오류도 안내고 출력도 안하고 만다!!
					- 그래서 boardListView.jsp 에서 일반게시글 목록 조회 와 일반게시글 검색 화면
					  둘 다 재활용이 가능해진다!!
				-->
				
				<button type="submit" class="btn btn-secondary btn-sm">검색</button>
				
			</form>
			
			<!-- 
				- 검색조건 (condition) 에 대한 select, option 유지 구문 작성 - js 
				- 단, 검색 결과에대한 응답화면일 경우에만 실행되야하는 코드임!!
				  (즉, 응답데이터로 condition 또는 keyword 가 넘어온 경우에만 코드 실행)	
			-->
			<c:if test="${ not empty requestScope.condition }">
				<!-- 응답데이터로 condition 이 넘어온 경우 -->
				<script>
					$(function() {
						
						// 검색창의 select 태그의 자식들 중 option 태그들 중
						// value 속성값이 응답데이터의 condition 과 일치하는 놈을 찾아
						// selected 속성을 부여하겠다. (true)
						$("#search-area option[value=${ requestScope.condition }]").prop("selected", true);
					});
				</script>
			</c:if>
		
		</div>

		<!-- 관리자만 보이는 글작성 버튼으로 배치 -->
		<c:if test="${ (not empty sessionScope.loginUser) and (sessionScope.loginUser.loginId eq 'admin') }">
			<div class="write-btn-area">
				<a href="/blueming/notice/enrollForm" class="btn btn-secondary btn-sm">
					글작성
				</a>
	
				<br><br>
			</div>
		</c:if>

		<table class="list-area table">
			<thead>
				<tr>
					<th>글번호</th>
					<th>글제목</th>
					<th>작성자</th>
					<th>조회수</th>
					<th>작성일</th>
				</tr>
			</thead>
			<tbody>
			
				<c:choose>
				
					<c:when test="${ empty requestScope.list }">
						<!-- case1. 조회된 공지사항이 없다면 -->
						<tr>
							<th colspan="5">
								조회된 공지사항이 없습니다.
							</th>
						</tr>
					</c:when>
					<c:otherwise>
						
						<!-- case2. 조회된 공지사항들이 있다면 -->
						<c:forEach var="n" items="${ requestScope.list }">
							
							<tr>
								<td>${ n.noticeId }</td>
								<td>${ n.noticeTitle }</td>
								<td>    <c:choose>
							        <c:when test="${n.memberId == 1}">
							            시스템 관리자
							        </c:when>
							        <c:otherwise>
							            ${n.memberId}
							        </c:otherwise>
							    </c:choose>
			    				</td>
								<td>${ n.count }</td>
								<td>${ n.createdDate }</td>
							</tr>
							
						</c:forEach>
						
					</c:otherwise>
					
				</c:choose>
				
			</tbody>
		</table>

		<br><br>

	</div>

	<br><br>
	
	<script>
		$(function() {
			
			// 게시글 1개를 나타내는 tr 요소에 클릭이벤트 부여
			// > 해당 게시글 번호에 해당하는 게시글 상세보기 요청
			$(".list-area>tbody>tr").click(function() {
				
				// console.log("클릭됨!!");
				// console.log($(this).children().eq(0).text());
				
				// 방금 클릭당한 글번호를 뽑아서 변수에 담기
				let nno = $(this).children().eq(0).text();
				// > 글번호가 Primary Key 제약조건이기 때문에 전달값으로 넘길 것!!
				
				// 쿼리스트링 방식 적용
				// location.href = "/myweb/notice/detail?nno=" + nno;
				// > href 로 요청을 보내면 GET 방식이므로
				//   내가 필요하다면 요청 시 전달값을 쿼리스트링으로 직접 명시해서 보낸다.
				
				// Path Variable 방식 적용
				location.href ="/blueming/notice/detail/" + nno;
				// > 요청 url 주소 사이에 글번호를 마치 url 주소의 일부인것 마냥 같이 보낸다.
				
			});
			
		});
	</script>
	
			<div class="paging-area">
		
			<ul class="pagination justify-content-center">
			
			  <c:choose>
			  	<c:when test="${ requestScope.pi.currentPage eq 1 }">
			  		<!-- 1 번 페이지일 경우 -->
			  		<li class="page-item disabled">
					 <a class="page-link">&lt;</a>
					</li>
			  	</c:when>
			  	<c:otherwise>
			  	
			  		<c:choose>
			  			<c:when test="${ empty requestScope.condition }">
			  				<!-- 일반 목록 조회일 경우 -->
			  				<li class="page-item">
							  <a class="page-link" href="/blueming/notice/list?cpage=${ requestScope.pi.currentPage - 1 }">&lt;</a>
							</li>
			  			</c:when>
			  			<c:otherwise>
			  				<!-- 검색 목록 조회일 경우 -->
			  				<li class="page-item">
							  <a class="page-link" href="/blueming/notice/search?condition=${ requestScope.condition }&keyword=${ requestScope.keyword }&cpage=${ requestScope.pi.currentPage - 1 }">Previous</a>
							</li>
			  			</c:otherwise>
			  			
			  		</c:choose>
			  	</c:otherwise>	
			  </c:choose>	
			  		
			  <c:forEach var="p" begin="${ requestScope.pi.startPage }"
			  					 end="${ requestScope.pi.endPage }" step="1">
			  	
			  	<c:choose>
			  		<c:when test="${ requestScope.pi.currentPage eq p }">
			  			<!-- 
			  				현재 보고 있는 페이지라면 파란색으로 보이게끔 
			  				이 페이지로는 다시 이동 못하게끔 href 속성을 지워줌!!
			  			-->
			  			<li class="page-item active"><a class="page-link">${ p }</a></li>
			  		</c:when>
			  		<c:otherwise>
			  		
			  			<c:choose>
			  				<c:when test="${ empty requestScope.condition }">
			  					<!-- 응답데이터로 condition 이 안넘어왔다면 (그냥 목록 조회일 경우) -->
					  			<li class="page-item">
					  				<a class="page-link" href="/blueming/notice/list?cpage=${ p }">${ p }</a>
					  			</li>
			  				</c:when>
			  				<c:otherwise>
			  					<!-- 검색 결과를 보여줘야 할 경우 -->
			  					<li class="page-item">
					  				<a class="page-link" href="/blueming/notice/search?condition=${ requestScope.condition }&keyword=${ requestScope.keyword }&cpage=${ p }">${ p }</a>
					  			</li>
			  				</c:otherwise>
			  			</c:choose>
			  		
			  			
			  		</c:otherwise>
			  	</c:choose>				 
			  						 
			  </c:forEach>
			  
			  <c:choose>
			  	<c:when test="${ requestScope.pi.currentPage eq requestScope.pi.maxPage }">
				  <li class="page-item disabled">
				  	<a class="page-link">&gt;</a>
				  </li>
			  	</c:when>
			  	<c:otherwise>
			  	
			  		<c:choose>
			  			<c:when test="${ empty requestScope.condition }">
			  				<!-- 일반 목록 조회일 경우 -->
			  				<li class="page-item">
								<a class="page-link" href="/blueming/notice/list?cpage=${ requestScope.pi.currentPage + 1 }">&gt;</a>
							</li>
			  			</c:when>
			  			<c:otherwise>
			  				<!-- 검색 결과 조회일 경우 -->
			  				<li class="page-item">
								<a class="page-link" href="/blueming/notice/search?condition=${ requestScope.condition }&keyword=${ requestScope.keyword }&cpage=${ requestScope.pi.currentPage + 1 }">Next</a>
							</li>
			  			</c:otherwise>
			  		</c:choose>
			  	</c:otherwise>
			  </c:choose>
			  
			</ul>
			
		</div>


</body>
</html>