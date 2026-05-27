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
    
    .table thead th {
        cursor: pointer;
        background-color: #f8f9fa;
        user-select: none;
    }
</style>
</head>
<body>
    <jsp:include page="../common/menubar.jsp"/>

    <div class="outer">
        <br>
        <h2>사원 인사정보 관리</h2>
        <br><br>

        <div id="search-area" align="center">
            <form id="search-form" action="/blueming/memberlist/search" method="post">
                <select name="condition">
                    <option value="memberId" ${requestScope.condition == 'memberId' ? 'selected' : ''}>사원번호</option>
                    <option value="deptId" ${requestScope.condition == 'deptId' ? 'selected' : ''}>부서</option>
                    <option value="positionId" ${requestScope.condition == 'positionId' ? 'selected' : ''}>직급</option>
                    <option value="name" ${requestScope.condition == 'name' ? 'selected' : ''}>이름</option>
                </select>

                <input type="search" name="keyword" value="${requestScope.keyword}">
                
                <input type="hidden" name="sortColumn" value="${requestScope.sortColumn}">
                <input type="hidden" name="sortOrder" value="${requestScope.sortOrder}">

                <button type="submit">검색</button>
            </form>
        </div>

        <br><br>

        <table class="table table-bordered table-sm">
            <thead>
                <tr>
                    <th onclick="clickSort('MEMBER_ID')">사원번호 ${requestScope.sortColumn == 'MEMBER_ID' ? (requestScope.sortOrder == 'ASC' ? '▲' : '▼') : ''}</th>
                    <th onclick="clickSort('DEPARTMENT_ID')">부서 ${requestScope.sortColumn == 'DEPARTMENT_ID' ? (requestScope.sortOrder == 'ASC' ? '▲' : '▼') : ''}</th>
                    <th onclick="clickSort('POSITION_ID')">직급 ${requestScope.sortColumn == 'POSITION_ID' ? (requestScope.sortOrder == 'ASC' ? '▲' : '▼') : ''}</th>
                    <th onclick="clickSort('NAME')">이름 ${requestScope.sortColumn == 'NAME' ? (requestScope.sortOrder == 'ASC' ? '▲' : '▼') : ''}</th>
                    <th onclick="clickSort('HIRE_DATE')">입사일 ${requestScope.sortColumn == 'HIRE_DATE' ? (requestScope.sortOrder == 'ASC' ? '▲' : '▼') : ''}</th>
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
                <c:if test="${requestScope.pi.currentPage > 1}">
                    <a href="javascript:void(0);" onclick="pageMove(1)">처음</a>
                    <a href="javascript:void(0);" onclick="pageMove(${requestScope.pi.currentPage - 1})">이전</a>
                </c:if>

                <c:forEach var="p" begin="${requestScope.pi.startPage}" end="${requestScope.pi.endPage}">
                    <c:choose>
                        <c:when test="${p == requestScope.pi.currentPage}">
                            <span style="color: red; font-weight: bold; margin: 0 5px;">${p}</span>
                        </c:when>
                        <c:otherwise>
                            <a href="javascript:void(0);" onclick="pageMove(${p})" style="margin: 0 5px;">${p}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>

                <c:if test="${requestScope.pi.currentPage < requestScope.pi.maxPage}">
                    <a href="javascript:void(0);" onclick="pageMove(${requestScope.pi.currentPage + 1})">다음</a>
                    <a href="javascript:void(0);" onclick="pageMove(${requestScope.pi.maxPage})">마지막</a>
                </c:if>
            </c:if>
        </div>
    </div>

    <form id="actionForm" action="/blueming/memberlist/search" method="post">
        <input type="hidden" name="cpage" id="formCpage" value="${requestScope.pi.currentPage != null ? requestScope.pi.currentPage : 1}">
        <input type="hidden" name="condition" value="${requestScope.condition}">
        <input type="hidden" name="keyword" value="${requestScope.keyword}">
        <input type="hidden" name="sortColumn" id="formSortColumn" value="${requestScope.sortColumn}">
        <input type="hidden" name="sortOrder" id="formSortOrder" value="${requestScope.sortOrder}">
    </form>
    <form id="detailForm" action="/blueming/memberlist/detail" method="post">
   		 <input type="hidden" name="memberId" id="detailMemberId" value="">
	</form>

    <script>

	    function goDetail(memberId) {
	        document.getElementById("detailMemberId").value = memberId;
	        document.getElementById("detailForm").submit();
	    }

        // 💡 페이징 번호 클릭 제어 함수
        function pageMove(page) {
            document.getElementById("formCpage").value = page;
            document.getElementById("actionForm").submit();
        }

        // 💡 헤더 클릭 시 오름차순 / 내림차순 토글 기능 함수
        function clickSort(column) {
            let currentColumn = "${requestScope.sortColumn}";
            let currentOrder = "${requestScope.sortOrder}";
            
            if(!currentColumn) currentColumn = "MEMBER_ID";
            if(!currentOrder) currentOrder = "ASC";
            
            let nextOrder = "ASC";
            // 동일한 컬럼 클릭 시 차순 반전 토글
            if(column === currentColumn) {
                nextOrder = (currentOrder === "ASC") ? "DESC" : "ASC";
            } else {
                // 새로운 컬럼 클릭 시 오름차순 정렬 우선 시작
                nextOrder = "ASC";
            }
            
            // 전송용 폼에 데이터 세팅 후 submit
            document.getElementById("formSortColumn").value = column;
            document.getElementById("formSortOrder").value = nextOrder;
            document.getElementById("formCpage").value = "1"; // 정렬 조건 바꿀 땐 1페이지로 리셋팅
            
            document.getElementById("actionForm").submit();
        }
    </script>
</body>
</html>