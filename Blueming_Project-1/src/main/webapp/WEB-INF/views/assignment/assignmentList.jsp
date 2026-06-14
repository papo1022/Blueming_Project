<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>과제 제출 현황</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/assignment/assignmentList.css">
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
            <input type="hidden" name="assignmentId" value="${assignmentId}">

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
                <c:set var="baseQuery" value="condition=${condition}&keyword=${keyword}&assignmentId=${assignmentId}&cpage=1" />
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
                        <a class="page-link" href="?cpage=${pi.currentPage-1}&condition=${condition}&keyword=${keyword}&assignmentId=${assignmentId}&sort=${sort}&order=${order}">&lt;</a>
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
                            <a class="page-link" href="?cpage=${p}&condition=${condition}&keyword=${keyword}&assignmentId=${assignmentId}&sort=${sort}&order=${order}">${p}</a>
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
                        <a class="page-link" href="?cpage=${pi.currentPage+1}&condition=${condition}&keyword=${keyword}&assignmentId=${assignmentId}&sort=${sort}&order=${order}">&gt;</a>
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