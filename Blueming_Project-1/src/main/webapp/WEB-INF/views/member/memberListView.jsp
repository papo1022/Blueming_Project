<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사원 인사정보 관리</title>
<style>
    .table tbody tr {
        cursor: pointer;
    }
    
    .table tbody tr:hover {
        background-color: #f5f5f5;
    }
</style>
</head>
<body>
    <jsp:include page="../common/menubar.jsp"/>

    <div class="outer">
        <br>
        <h2>사원 인사정보 관리</h2>
        <br>

        <br><br>

        <div id="search-area" align="center">

            <form id="search-form" action="/blueming/memberlist/search" method="get">

                <select name="condition">
                    <option value="memberId" ${requestScope.condition == 'memberId' ? 'selected' : ''}>사원번호</option>
                    <option value="deptId" ${requestScope.condition == 'deptId' ? 'selected' : ''}>부서</option>
                    <option value="positionId" ${requestScope.condition == 'positionId' ? 'selected' : ''}>직급</option>
                    <option value="name" ${requestScope.condition == 'name' ? 'selected' : ''}>이름</option>
                </select>

                <input type="search" name="keyword" value="${requestScope.keyword}">

                <button type="submit">검색</button>

            </form>

        </div>

        <br><br>

        <table class="table table-bordered table-sm">
            <thead>
                <tr>
                    <th>사원번호</th>
                    <th>부서</th>
                    <th>직급</th>
                    <th>이름</th>
                    <th>입사일</th>
                </tr>
            </thead>
 
            <tbody>
                <c:choose>
                    <c:when test="${empty requestScope.list}">
                        <tr align="center">
                            <td colspan="5">조회된 사원 정보가 없습니다.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="member" items="${requestScope.list}">
                            <tr align="center" onclick="goDetail(${member.memberId})">
                                <td>${member.memberId}</td>
                                <td>${member.deptId}</td>
                                <td>${member.positionId}</td>
                                <td>${member.name}</td>
                                <td>
                                    <fmt:formatDate value="${member.hireDate}" pattern="yyyy-MM-dd"/>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>

        </table>

        <br><br>
        <div align="center">
            <c:if test="${not empty requestScope.pi}">
                
                <c:choose>
                    <c:when test="${not empty requestScope.keyword}">
                        <c:set var="pageUrl" value="/blueming/memberlist/search?condition=${requestScope.condition}&keyword=${requestScope.keyword}&cpage=" />
                    </c:when>
                    <c:otherwise>
                        <c:set var="pageUrl" value="/blueming/memberlist?cpage=" />
                    </c:otherwise>
                </c:choose>

                <c:if test="${requestScope.pi.currentPage > 1}">
                    <a href="${pageUrl}1">처음</a>
                    <a href="${pageUrl}${requestScope.pi.currentPage - 1}">이전</a>
                </c:if>

                <c:forEach var="p" begin="${requestScope.pi.startPage}" end="${requestScope.pi.endPage}">
                    <c:choose>
                        <c:when test="${p == requestScope.pi.currentPage}">
                            <span style="color: red; font-weight: bold; margin: 0 5px;">${p}</span>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageUrl}${p}" style="margin: 0 5px;">${p}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>

                <c:if test="${requestScope.pi.currentPage < requestScope.pi.maxPage}">
                    <a href="${pageUrl}${requestScope.pi.currentPage + 1}">다음</a>
                    <a href="${pageUrl}${requestScope.pi.maxPage}">마지막</a>
                </c:if>
            </c:if>
        </div>

    </div>

    <script>
        function goDetail(memberId) {
            location.href = "/blueming/memberlist/detail?memberId=" + memberId;
        }
    </script>
</body>
</html>