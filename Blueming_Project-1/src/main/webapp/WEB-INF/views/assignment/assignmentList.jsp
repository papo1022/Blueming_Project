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
    margin-bottom:25px;
}

/* ===== 검색영역 (Notice 스타일 적용) ===== */
#search-area{
    text-align:center;
    margin-bottom:20px;
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
    padding: 0 20px;
    border: none;
    background: #6c757d;
    color: white;
    font-size: 14px;
    cursor: pointer;
}

#search-area button:hover {
    background: #5a6268;
}

/* ===== 테이블 영역 (Notice 라운딩 카드 스타일 적용) ===== */
.list-area{
    width:95%;
    margin:auto;
    background:white;
    border-radius:15px;
    overflow:hidden;
    box-shadow:0 2px 8px rgba(0,0,0,0.08);
}

/* ===== 테이블 헤더 ===== */
.list-area thead th{
    text-align:center;
    height:50px;
    border:none;
    background:#fafafa;
    font-size:14px;
    padding: 0 10px;
}

/* ===== 정렬 버튼 (Notice 분위기에 맞춰 연한 회색/민트 포인트로 변경) ===== */
.sort-btn{
    color:#333;
    text-decoration:none;
    display:inline-flex;
    align-items:center;
    gap:4px;
    font-weight:600;
    padding:4px 8px;
    border-radius:12px;
    transition:.2s;
}

.sort-btn:hover{
    background:rgba(79, 209, 197, 0.1);
    color: #4fd1c5;
}

/* 현재 활성화된 정렬 강조 (Notice 민트색 배경 반영) */
.sort-active{
    background:rgba(79, 209, 197, 0.15);
    color: #4fd1c5;
}

/* ===== 테이블 본문 ===== */
.list-area tbody td{
    height:45px;
    padding:8px 12px;
    vertical-align:middle;
    border-top:1px solid #f0f0f0;
    font-size:14px;
}

/* 클릭 가능한 행 호버 스타일 효과 */
.list-area tbody tr.data-row:hover{
    background:#f8fbff;
    cursor:pointer;
}

/* ===== 점수 스타일 (미채점은 연하게, 점수는 강조) ===== */
.score-text{
    font-weight:bold;
    color:#e53e3e;
}
.score-empty{
    color:#aaa;
    font-size:13px;
}

/* ===== 페이징 (Notice 민트색 원형 스타일 적용) ===== */
.paging-area{
    margin-top:25px;
    text-align:center;
}

.pagination{
    margin-top:0;
    margin-bottom:0;
}

.pagination .page-link{
    border:none;
    background:none;
    color:#666;
    text-decoration: none;
    padding: 6px 12px;
    display: inline-block;
}

.pagination .page-item{
    display: inline-block;
    list-style: none;
}

.pagination .page-item.disabled .page-link{
    color: #ccc;
    cursor: not-allowed;
}

.pagination .page-item.active .page-link{
    background:#4fd1c5;
    color:white;
    border-radius:50%;
    width:35px;
    height:35px;
    line-height:22px;
    padding: 6px 0;
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

    <h2>📚 과제 채점 현황</h2>

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
            
            <input type="search" name="keyword" value="${keyword}" placeholder="검색어를 입력하세요">
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
                        사번 <c:choose><c:when test="${sort eq 'memberId' and order eq 'asc'}">▲</c:when><c:when test="${sort eq 'memberId' and order eq 'desc'}">▼</c:when><c:otherwise>⇅</c:otherwise></c:choose>
                    </a>
                </th>
                <th>
                    <a class="sort-btn ${sort eq 'loginId' ? 'sort-active' : ''}"
                       href="?sort=loginId&order=${sort eq 'loginId' and order eq 'asc' ? 'desc' : 'asc'}&${baseQuery}">
                        아이디 <c:choose><c:when test="${sort eq 'loginId' and order eq 'asc'}">▲</c:when><c:when test="${sort eq 'loginId' and order eq 'desc'}">▼</c:when><c:otherwise>⇅</c:otherwise></c:choose>
                    </a>
                </th>
                <th>
                    <a class="sort-btn ${sort eq 'name' ? 'sort-active' : ''}"
                       href="?sort=name&order=${sort eq 'name' and order eq 'asc' ? 'desc' : 'asc'}&${baseQuery}">
                        이름 <c:choose><c:when test="${sort eq 'name' and order eq 'asc'}">▲</c:when><c:when test="${sort eq 'name' and order eq 'desc'}">▼</c:when><c:otherwise>⇅</c:otherwise></c:choose>
                    </a>
                </th>
                <th>
                    <a class="sort-btn ${sort eq 'departmentId' ? 'sort-active' : ''}"
                       href="?sort=departmentId&order=${sort eq 'departmentId' and order eq 'asc' ? 'desc' : 'asc'}&${baseQuery}">
                        부서 <c:choose><c:when test="${sort eq 'departmentId' and order eq 'asc'}">▲</c:when><c:when test="${sort eq 'departmentId' and order eq 'desc'}">▼</c:when><c:otherwise>⇅</c:otherwise></c:choose>
                    </a>
                </th>
                <th>
                    <a class="sort-btn ${sort eq 'positionId' ? 'sort-active' : ''}"
                       href="?sort=positionId&order=${sort eq 'positionId' and order eq 'asc' ? 'desc' : 'asc'}&${baseQuery}">
                        직급 <c:choose><c:when test="${sort eq 'positionId' and order eq 'asc'}">▲</c:when><c:when test="${sort eq 'positionId' and order eq 'desc'}">▼</c:when><c:otherwise>⇅</c:otherwise></c:choose>
                    </a>
                </th>
                <th>
                    <a class="sort-btn ${sort eq 'assignmentTitle' ? 'sort-active' : ''}"
                       href="?sort=assignmentTitle&order=${sort eq 'assignmentTitle' and order eq 'asc' ? 'desc' : 'asc'}&${baseQuery}">
                        과제명 <c:choose><c:when test="${sort eq 'assignmentTitle' and order eq 'asc'}">▲</c:when><c:when test="${sort eq 'assignmentTitle' and order eq 'desc'}">▼</c:when><c:otherwise>⇅</c:otherwise></c:choose>
                    </a>
                </th>
                <th>
                    <a class="sort-btn ${sort eq 'startDate' ? 'sort-active' : ''}"
                       href="?sort=startDate&order=${sort eq 'startDate' and order eq 'asc' ? 'desc' : 'asc'}&${baseQuery}">
                        시작일 <c:choose><c:when test="${sort eq 'startDate' and order eq 'asc'}">▲</c:when><c:when test="${sort eq 'startDate' and order eq 'desc'}">▼</c:when><c:otherwise>⇅</c:otherwise></c:choose>
                    </a>
                </th>
                <th>
                    <a class="sort-btn ${sort eq 'dueDate' ? 'sort-active' : ''}"
                       href="?sort=dueDate&order=${sort eq 'dueDate' and order eq 'asc' ? 'desc' : 'asc'}&${baseQuery}">
                        마감일 <c:choose><c:when test="${sort eq 'dueDate' and order eq 'asc'}">▲</c:when><c:when test="${sort eq 'dueDate' and order eq 'desc'}">▼</c:when><c:otherwise>⇅</c:otherwise></c:choose>
                    </a>
                </th>
                <th>
                    <a class="sort-btn ${sort eq 'score' ? 'sort-active' : ''}"
                       href="?sort=score&order=${sort eq 'score' and order eq 'asc' ? 'desc' : 'asc'}&${baseQuery}">
                        점수 <c:choose><c:when test="${sort eq 'score' and order eq 'asc'}">▲</c:when><c:when test="${sort eq 'score' and order eq 'desc'}">▼</c:when><c:otherwise>⇅</c:otherwise></c:choose>
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