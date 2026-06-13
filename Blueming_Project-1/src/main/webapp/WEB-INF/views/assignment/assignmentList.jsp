<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>과제 제출 현황</title>
<style>
/* ===== 전체 ===== */
body{
    background:#f5f7fb;
    margin:0;
    padding:0;
    font-family:"맑은 고딕", sans-serif;
}

/* ===== 본문 ===== */
.outer{
    margin-left:250px;
    width:calc(100vw - 250px);
    min-height:100vh;
    padding:30px;
    box-sizing:border-box;
}

/* ===== 제목 ===== */
.outer h2{
    text-align:center;
    font-size:30px;
    font-weight:700;
    color:#2d3748;
    margin-bottom:25px;
}

/* ===== 검색 영역 ===== */
#search-area{
    width:100%;
    background:white;
    border-radius:15px;
    padding:20px;
    margin-bottom:25px;
    box-shadow:0 2px 10px rgba(0,0,0,.08);
    box-sizing:border-box;
}

#search-area form{
    display:flex;
    justify-content:center;
    align-items:center;
    gap:10px;
    flex-wrap:wrap;
}

#search-area select{
    width:120px;
    height:42px;
    border:1px solid #dce3ea;
    border-radius:10px;
    padding:0 10px;
    outline:none;
}

#search-area input{
    width:450px;
    height:42px;
    border:1px solid #dce3ea;
    border-radius:10px;
    padding:0 15px;
    outline:none;
}

#search-area input:focus,
#search-area select:focus{
    border-color:#4fd1c5;
}

#search-area button{
    width:90px;
    height:42px;
    border:none;
    border-radius:10px;
    background:#4fd1c5;
    color:white;
    font-weight:600;
    cursor:pointer;
}

#search-area button:hover{
    background:#38b2ac;
}

/* ===== 테이블 ===== */
.list-area{
    width:100%;
    background:white;
    border-radius:15px;
    overflow:hidden;
    box-shadow:0 2px 10px rgba(0,0,0,.08);
    table-layout:fixed;
}

/* ===== 헤더 ===== */
.list-area thead th{
    background:#4fd1c5;
    color:white;
    height:55px;
    border:none;
    text-align:center;
    vertical-align:middle;
    font-size:14px;
    font-weight:600;
}

/* ===== 정렬 버튼 ===== */
.sort-btn{
    color:white;
    text-decoration:none;
    font-weight:600;
}

.sort-btn:hover{
    color:white;
    text-decoration:none;
}

.sort-active{
    background:rgba(255,255,255,.25);
    padding:4px 10px;
    border-radius:15px;
}

/* ===== 본문 ===== */
.list-area tbody td{
    height:55px;
    border-top:1px solid #eef2f7;
    text-align:center;
    vertical-align:middle;
    font-size:14px;
}

/* ===== 행 Hover ===== */
.list-area tbody tr.data-row{
    transition:.2s;
}

.list-area tbody tr.data-row:hover{
    background:#f0fbfa;
    cursor:pointer;
}

/* ===== 점수 ===== */
.score-text{
    color:#e53e3e;
    font-weight:700;
    font-size:15px;
}

.score-empty{
    color:#999;
}

/* ===== 컬럼 줄바꿈 방지 ===== */
.list-area th,
.list-area td{
    white-space:nowrap;
    overflow:hidden;
    text-overflow:ellipsis;
}

/* ===== 페이징 ===== */
.paging-area{
    margin-top:25px;
}

.pagination{
    justify-content:center;
    margin:0;
}

.pagination .page-item{
    margin:0 4px;
    list-style:none;
}

.pagination .page-link{
    width:38px;
    height:38px;
    display:flex;
    align-items:center;
    justify-content:center;
    border:none;
    border-radius:50%;
    background:white;
    color:#555;
    text-decoration:none;
    box-shadow:0 1px 4px rgba(0,0,0,.08);
}

.pagination .page-link:hover{
    background:#e8fffd;
    color:#4fd1c5;
}

.pagination .page-item.active .page-link{
    background:#4fd1c5;
    color:white;
}

.pagination .page-item.disabled .page-link{
    color:#ccc;
    background:#f7f7f7;
    cursor:not-allowed;
}

/* ===== 빈 데이터 ===== */
.list-area tbody td[colspan]{
    height:100px;
    color:#888;
    font-size:15px;
}
</style>
</head>
<body>
	
<jsp:include page="../common/mainMenubar.jsp" />
	
<div class="outer">

   <h2><i class="fi fi-sr-document"></i> 과제 채점 현황</h2>

    <div id="search-area">
        <form action="${pageContext.request.contextPath}/assignment/admin/list" method="get">
            <%-- 검색창을 눌러도 정렬 상태가 유지되도록 숨은 필드 추가 --%>
            <input type="hidden" name="sort" value="${sort}">
            <input type="hidden" name="order" value="${order}">

            <select name="condition">
                <option value="name" <c:if test="${condition eq 'name'}">selected</c:if>>이름</option>
                <option value="department" <c:if test="${condition eq 'department'}">selected</c:if>>부서</option>
                <option value="position" <c:if test="${condition eq 'position'}">selected</c:if>>직급</option>
            </select>
            
            <input type="search" name="keyword" value="${keyword}" placeholder="검색어를 입력하세요" maxlength="100">
            <button type="submit">검색</button>
        </form>
    </div>

    <table class="list-area table">
        <thead>
            <tr>
                <%-- 정렬 버튼들이 자연스럽게 녹아들도록 스타일을 입혔으며, 정렬 시 1페이지(cpage=1)로 리셋되도록 수정 --%>
                <c:set var="baseQuery" value="condition=${condition}&keyword=${keyword}&cpage=1" />
                <th>
                    <a class="sort-btn ${sort eq 'memberId' ? 'sort-active' : ''}"
                       href="?sort=memberId&order=${sort eq 'memberId' and order eq 'asc' ? 'desc' : 'asc'}&${baseQuery}">
                        사번 <c:choose><c:when test="${sort eq 'memberId' and order eq 'asc'}">▲</c:when><c:when test="${sort eq 'memberId' and order eq 'desc'}">▼</c:when><c:otherwise>↕</c:otherwise></c:choose>
                    </a>
                </th>
                <th>
                    <a class="sort-btn ${sort eq 'loginId' ? 'sort-active' : ''}"
                       href="?sort=loginId&order=${sort eq 'loginId' and order eq 'asc' ? 'desc' : 'asc'}&${baseQuery}">
                        아이디 <c:choose><c:when test="${sort eq 'loginId' and order eq 'asc'}">▲</c:when><c:when test="${sort eq 'loginId' and order eq 'desc'}">▼</c:when><c:otherwise>↕</c:otherwise></c:choose>
                    </a>
                </th>
                <th>
                    <a class="sort-btn ${sort eq 'name' ? 'sort-active' : ''}"
                       href="?sort=name&order=${sort eq 'name' and order eq 'asc' ? 'desc' : 'asc'}&${baseQuery}">
                        이름 <c:choose><c:when test="${sort eq 'name' and order eq 'asc'}">▲</c:when><c:when test="${sort eq 'name' and order eq 'desc'}">▼</c:when><c:otherwise>↕</c:otherwise></c:choose>
                    </a>
                </th>
                <th>
                    <a class="sort-btn ${sort eq 'departmentId' ? 'sort-active' : ''}"
                       href="?sort=departmentId&order=${sort eq 'departmentId' and order eq 'asc' ? 'desc' : 'asc'}&${baseQuery}">
                        부서 <c:choose><c:when test="${sort eq 'departmentId' and order eq 'asc'}">▲</c:when><c:when test="${sort eq 'departmentId' and order eq 'desc'}">▼</c:when><c:otherwise>↕</c:otherwise></c:choose>
                    </a>
                </th>
                <th>
                    <a class="sort-btn ${sort eq 'positionId' ? 'sort-active' : ''}"
                       href="?sort=positionId&order=${sort eq 'positionId' and order eq 'asc' ? 'desc' : 'asc'}&${baseQuery}">
                        직급 <c:choose><c:when test="${sort eq 'positionId' and order eq 'asc'}">▲</c:when><c:when test="${sort eq 'positionId' and order eq 'desc'}">▼</c:when><c:otherwise>↕</c:otherwise></c:choose>
                    </a>
                </th>
                <th>
                    <a class="sort-btn ${sort eq 'assignmentTitle' ? 'sort-active' : ''}"
                       href="?sort=assignmentTitle&order=${sort eq 'assignmentTitle' and order eq 'asc' ? 'desc' : 'asc'}&${baseQuery}">
                        과제명 <c:choose><c:when test="${sort eq 'assignmentTitle' and order eq 'asc'}">▲</c:when><c:when test="${sort eq 'assignmentTitle' and order eq 'desc'}">▼</c:when><c:otherwise>↕</c:otherwise></c:choose>
                    </a>
                </th>
                <th>
                    <a class="sort-btn ${sort eq 'startDate' ? 'sort-active' : ''}"
                       href="?sort=startDate&order=${sort eq 'startDate' and order eq 'asc' ? 'desc' : 'asc'}&${baseQuery}">
                        시작일 <c:choose><c:when test="${sort eq 'startDate' and order eq 'asc'}">▲</c:when><c:when test="${sort eq 'startDate' and order eq 'desc'}">▼</c:when><c:otherwise>↕</c:otherwise></c:choose>
                    </a>
                </th>
                <th>
                    <a class="sort-btn ${sort eq 'dueDate' ? 'sort-active' : ''}"
                       href="?sort=dueDate&order=${sort eq 'dueDate' and order eq 'asc' ? 'desc' : 'asc'}&${baseQuery}">
                        마감일 <c:choose><c:when test="${sort eq 'dueDate' and order eq 'asc'}">▲</c:when><c:when test="${sort eq 'dueDate' and order eq 'desc'}">▼</c:when><c:otherwise>↕</c:otherwise></c:choose>
                    </a>
                </th>
                <th>
                    <a class="sort-btn ${sort eq 'score' ? 'sort-active' : ''}"
                       href="?sort=score&order=${sort eq 'score' and order eq 'asc' ? 'desc' : 'asc'}&${baseQuery}">
                        점수 <c:choose><c:when test="${sort eq 'score' and order eq 'asc'}">▲</c:when><c:when test="${sort eq 'score' and order eq 'desc'}">▼</c:when><c:otherwise>↕</c:otherwise></c:choose>
                    </a>
                </th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${ empty list }">
                    <tr>
                        <td colspan="9" style="height:100px; color:#888;">조회된 과제 제출 현황이 없습니다.</td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="a" items="${list}">
                        <%-- 데이터가 존재할 때만 클릭을 허용하도록 class="data-row" 부여 --%>
                        <tr class="data-row" data-member="${a.memberId}" data-assignment="${a.assignmentId}">
                            <td>${a.memberId}</td>
                            <td>${a.loginId}</td>
                            <td>${a.name}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${a.departmentId eq 'D01'}">인사팀</c:when>
                                    <c:when test="${a.departmentId eq 'D02'}">개발팀</c:when>
                                    <c:when test="${a.departmentId eq 'D03'}">디자인팀</c:when>
                                    <c:when test="${a.departmentId eq 'D04'}">영업팀</c:when>
                                    <c:when test="${a.departmentId eq 'D05'}">마케팅팀</c:when>
                                    <c:when test="${a.departmentId eq 'D06'}">운영팀</c:when>
                                    <c:when test="${a.departmentId eq 'D07'}">품질관리팀</c:when>
                                    <c:when test="${a.departmentId eq 'D08'}">전략기획팀</c:when>
                                    <c:otherwise>부서없음</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${a.positionId eq 'P01'}">사원</c:when>
                                    <c:when test="${a.positionId eq 'P02'}">주임</c:when>
                                    <c:when test="${a.positionId eq 'P03'}">대리</c:when>
                                    <c:when test="${a.positionId eq 'P04'}">과장</c:when>
                                    <c:when test="${a.positionId eq 'P05'}">차장</c:when>
                                    <c:when test="${a.positionId eq 'P06'}">부장</c:when>
                                    <c:otherwise>직급없음</c:otherwise>
                                </c:choose>
                            </td>
                            <td>${a.assignmentTitle}</td>
                            <td>${a.startDate}</td>
                            <td>${a.dueDate}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${empty a.score}">
                                        <span class="score-empty">미채점</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="score-text">${a.score}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

    <%-- 페이징 영역 (Notice 디자인 - 민트색 서클 매칭) --%>
    <div class="paging-area">
        <ul class="pagination justify-content-center">
            
            <%-- 이전 버튼 --%>
            <c:choose>
                <c:when test="${pi.currentPage eq 1}">
                    <li class="page-item disabled"><a class="page-link">&lt;</a></li>
                </c:when>
                <c:otherwise>
                    <li class="page-item">
                        <a class="page-link" href="?cpage=${pi.currentPage-1}&condition=${condition}&keyword=${keyword}&sort=${sort}&order=${order}">&lt;</a>
                    </li>
                </c:otherwise>
            </c:choose>

            <%-- 페이지 숫자 번호 --%>
            <c:forEach var="p" begin="${pi.startPage}" end="${pi.endPage}">
                <c:choose>
                    <c:when test="${p eq pi.currentPage}">
                        <li class="page-item active"><a class="page-link">${p}</a></li>
                    </c:when>
                    <c:otherwise>
                        <li class="page-item">
                            <a class="page-link" href="?cpage=${p}&condition=${condition}&keyword=${keyword}&sort=${sort}&order=${order}">${p}</a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <%-- 다음 버튼 --%>
            <c:choose>
                <c:when test="${pi.currentPage eq pi.maxPage or pi.maxPage eq 0}">
                    <li class="page-item disabled"><a class="page-link">&gt;</a></li>
                </c:when>
                <c:otherwise>
                    <li class="page-item">
                        <a class="page-link" href="?cpage=${pi.currentPage+1}&condition=${condition}&keyword=${keyword}&sort=${sort}&order=${order}">&gt;</a>
                    </li>
                </c:otherwise>
            </c:choose>
            
        </ul>
    </div>

</div>

<%-- 스크립트 단 처리 --%>
<script>
    $(function() {
        // 공지사항 페이지처럼 오직 .data-row 가 들어간 실데이터 tr 행에만 안전하게 클릭 이벤트 부여
        $(".list-area>tbody>tr.data-row").click(function() {
            let memberId = $(this).data("member");
            let assignmentId = $(this).data("assignment");
            
            location.href = "${pageContext.request.contextPath}/assignment/admin/detail?memberId=" + memberId + "&assignmentId=" + assignmentId;
        });
    });
</script>

</body>
</html>