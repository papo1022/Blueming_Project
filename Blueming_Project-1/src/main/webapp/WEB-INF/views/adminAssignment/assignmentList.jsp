<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>과제 제출 현황</title>

<style>

body{
    font-family:"맑은 고딕";
    background:#f5f7fa;
    margin:0;
    padding:30px;
}

.container{
    width:1200px;
    margin:auto;
}

h2{
    color:#333;
    margin-bottom:20px;
}

/* 검색영역 */

.search-box{
    background:white;
    padding:20px;
    border-radius:10px;
    box-shadow:0 2px 8px rgba(0,0,0,0.1);
    margin-bottom:20px;
}

.search-box select,
.search-box input{
    height:38px;
    padding:0 10px;
    border:1px solid #ddd;
    border-radius:5px;
}

.search-box button{
    height:38px;
    padding:0 20px;
    border:none;
    background:#4A90E2;
    color:white;
    border-radius:5px;
    cursor:pointer;
}

.search-box button:hover{
    background:#357ABD;
}

/* 테이블 */

.assignment-table{
    width:100%;
    border-collapse:collapse;
    background:white;
    box-shadow:0 2px 8px rgba(0,0,0,0.1);
}

.assignment-table th{
    background:#4A90E2;
    color:white;
    height:50px;
}

.assignment-table td{
    text-align:center;
    height:50px;
    border-bottom:1px solid #e5e5e5;
}

.assignment-table tr:hover{
    background:#f0f7ff;
    cursor:pointer;
}

.sort-link{
    color:white;
    text-decoration:none;
}

.sort-link:hover{
    text-decoration:underline;
}

.score{
    color:#E74C3C;
    font-weight:bold;
}

/* 페이징 */

.paging-area{
    margin-top:40px;
    text-align:center;
}

.paging-area a,
.paging-area span{

    display:inline-flex;
    justify-content:center;
    align-items:center;

    width:40px;
    height:40px;

    margin:0 4px;

    border:1px solid #ddd;
    border-radius:8px;

    background:white;
    color:#555;

    text-decoration:none;

    font-weight:600;

    transition:all .2s ease;
}

.paging-area a:hover{
    background:#4A90E2;
    color:white;
    border-color:#4A90E2;
    transform:translateY(-2px);
}

.paging-area .current{
    background:#4A90E2;
    color:white;
    border-color:#4A90E2;
}

.paging-area .move{
    width:auto;
    min-width:90px;
    padding:0 15px;
}

</style>

</head>
<body>

<jsp:include page="../common/mainMenubar.jsp" />

<div class="container">

    <h2>📚 과제 제출 현황</h2>

    <div class="search-box">

        <form action="${pageContext.request.contextPath}/adminAssignment/list"
              method="get">

            <select name="condition">

                <option value="name"
                    <c:if test="${condition eq 'name'}">selected</c:if>>
                    이름
                </option>

                <option value="department"
                    <c:if test="${condition eq 'department'}">selected</c:if>>
                    부서
                </option>

                <option value="position"
                    <c:if test="${condition eq 'position'}">selected</c:if>>
                    직급
                </option>

            </select>

            <input type="text"
                   name="keyword"
                   value="${keyword}"
                   placeholder="검색어 입력">

            <button type="submit">검색</button>

        </form>

    </div>

    <table class="assignment-table">

        <tr>

            <th>
                <a class="sort-link"
                   href="?sort=memberId&condition=${condition}&keyword=${keyword}&cpage=${pi.currentPage}">
                    사번
                </a>
            </th>

            <th>
                <a class="sort-link"
                   href="?sort=loginId&condition=${condition}&keyword=${keyword}&cpage=${pi.currentPage}">
                    아이디
                </a>
            </th>

            <th>
                <a class="sort-link"
                   href="?sort=name&condition=${condition}&keyword=${keyword}&cpage=${pi.currentPage}">
                    이름
                </a>
            </th>

            <th>
                <a class="sort-link"
                   href="?sort=departmentId&condition=${condition}&keyword=${keyword}&cpage=${pi.currentPage}">
                    부서
                </a>
            </th>

            <th>
                <a class="sort-link"
                   href="?sort=positionId&condition=${condition}&keyword=${keyword}&cpage=${pi.currentPage}">
                    직급
                </a>
            </th>

            <th>
                <a class="sort-link"
                   href="?sort=assignmentTitle&condition=${condition}&keyword=${keyword}&cpage=${pi.currentPage}">
                    과제명
                </a>
            </th>

            <th>
                <a class="sort-link"
                   href="?sort=startDate&condition=${condition}&keyword=${keyword}&cpage=${pi.currentPage}">
                    시작일
                </a>
            </th>

            <th>
                <a class="sort-link"
                   href="?sort=dueDate&condition=${condition}&keyword=${keyword}&cpage=${pi.currentPage}">
                    마감일
                </a>
            </th>

            <th>
                <a class="sort-link"
                   href="?sort=score&condition=${condition}&keyword=${keyword}&cpage=${pi.currentPage}">
                    점수
                </a>
            </th>

        </tr>

        <c:forEach var="a" items="${list}">

            <tr onclick="location.href='${pageContext.request.contextPath}/adminAssignment/detail?memberId=${a.memberId}&assignmentId=${a.assignmentId}'">

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

                <td class="score">
                    <c:choose>
                        <c:when test="${empty a.score}">
                            미채점
                        </c:when>
                        <c:otherwise>
                            ${a.score}
                        </c:otherwise>
                    </c:choose>
                </td>

            </tr>

        </c:forEach>

    </table>

    <div class="paging-area">

        <c:if test="${pi.currentPage ne 1}">
            <a class="move"
               href="?cpage=${pi.currentPage-1}&condition=${condition}&keyword=${keyword}&sort=${sort}">
                ◀ 이전
            </a>
        </c:if>

        <c:forEach var="p"
                   begin="${pi.startPage}"
                   end="${pi.endPage}">

            <c:choose>

                <c:when test="${p eq pi.currentPage}">
                    <span class="current">${p}</span>
                </c:when>

                <c:otherwise>
                    <a href="?cpage=${p}&condition=${condition}&keyword=${keyword}&sort=${sort}">
                        ${p}
                    </a>
                </c:otherwise>

            </c:choose>

        </c:forEach>

        <c:if test="${pi.currentPage ne pi.maxPage}">
            <a class="move"
               href="?cpage=${pi.currentPage+1}&condition=${condition}&keyword=${keyword}&sort=${sort}">
                다음 ▶
            </a>
        </c:if>

    </div>

</div>

</body>
</html>