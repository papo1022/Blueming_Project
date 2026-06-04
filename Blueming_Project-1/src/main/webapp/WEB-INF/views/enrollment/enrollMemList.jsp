<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>수강 정보 관리</title>
<style>
    .outer { display: flex; flex-direction: column; min-height: 70vh; padding: 20px; align-items: center; }
    .table-container { flex: 1; width: 100%; max-width: 800px; }
    .table { width: 100%; border-collapse: collapse; margin-top: 20px; }
    .table tbody tr { cursor: pointer; }
    .table tbody tr:hover { background-color: #f5f5f5; }
    .table th, .table td { padding: 10px; border: 1px solid #ddd; text-align: center; }
    .sort-link { text-decoration: none; color: black; cursor: pointer; display: block; }
    .pagination-wrapper { display: flex; justify-content: center; margin-top: 30px; padding-bottom: 20px; }
    .pagination-wrapper a, .pagination-wrapper span { display: inline-block; padding: 5px 12px; margin: 0 3px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; text-decoration: none; color: #333; }
    .disabled-btn { color: #ccc !important; cursor: default; }
</style>
</head>
<body>
    <jsp:include page="../common/menubar.jsp"/>
    
    <div class="outer">
        <h2>수강 정보 관리</h2>
        
        <form action="${pageContext.request.contextPath}/enrollment/enrollMemList" method="post" style="margin-bottom: 20px;">
            <select name="condition">
                <option value="course" ${condition == 'course' ? 'selected' : ''}>강의명</option>
            </select>
            <input type="text" name="keyword" value="${keyword}">
            <button type="submit">검색</button>
            <button type="button" onclick="resetSearch()">초기화</button>
        </form>

        <div class="table-container">
            <table class="table table-bordered">
                <thead>
                    <th><a href="javascript:void(0);" onclick="sortList('COURSE_TITLE')" class="sort-link">강의명 </a></th>
					<th><a href="javascript:void(0);" onclick="sortList('START_DATE')" class="sort-link">시작일 </a></th>
					<th><a href="javascript:void(0);" onclick="sortList('END_DATE')" class="sort-link">종료일 </a></th>
					<th><a href="javascript:void(0);" onclick="sortList('STATUS')" class="sort-link">상태 </a></th>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty list}">
                            <tr><td colspan="4">조회된 수강 정보가 없습니다.</td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="item" items="${list}">
                                <tr onclick="goDetail('${item.courseId}')">
                                    <td>${item.courseTitle}</td>
                                    <td>${item.startDate}</td>
                                    <td>${item.endDate}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.status == 'W'}"><span style="color: blue;">예정</span></c:when>
                                            <c:when test="${item.status == 'Y'}"><span style="color: green; font-weight: bold;">진행중</span></c:when>
                                            <c:when test="${item.status == 'N'}"><span style="color: gray;">종료</span></c:when>
                                            <c:otherwise>${item.status}</c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <%-- 페이징바 영역: 이 아래로 복사본이 있는지 확인하세요 --%>
        <div class="pagination-wrapper">
            <c:if test="${not empty pi}">
                <c:choose>
                    <c:when test="${pi.currentPage > 1}">
                        <a href="javascript:movePage(1)">처음</a>
                        <a href="javascript:movePage(${pi.currentPage - 1})">이전</a>
                    </c:when>
                    <c:otherwise>
                        <span class="disabled-btn">처음</span><span class="disabled-btn">이전</span>
                    </c:otherwise>
                </c:choose>

                <c:forEach var="p" begin="${pi.startPage}" end="${pi.endPage}">
                    <c:choose>
                        <c:when test="${p == pi.currentPage}">
                            <span style="color: red; font-weight: bold; border-color: red;">${p}</span>
                        </c:when>
                        <c:otherwise>
                            <a href="javascript:movePage(${p})">${p}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>

                <c:choose>
                    <c:when test="${pi.currentPage < pi.maxPage}">
                        <a href="javascript:movePage(${pi.currentPage + 1})">다음</a>
                        <a href="javascript:movePage(${pi.maxPage})">마지막</a>
                    </c:when>
                    <c:otherwise>
                        <span class="disabled-btn">다음</span><span class="disabled-btn">마지막</span>
                    </c:otherwise>
                </c:choose>
            </c:if>
        </div>
    </div>

    <form id="pagingForm" action="${pageContext.request.contextPath}/enrollment/enrollMemList" method="post" style="display:none;">
    <input type="hidden" name="condition" value="${condition}">
    <input type="hidden" name="keyword" value="${keyword}">
    
    <input type="hidden" name="sortCol" id="sortCol" value="${sortCol}">
    <input type="hidden" name="sortOrder" id="sortOrder" value="${sortOrder}">
    
    <input type="hidden" name="cpage" id="cpage" value="${pi.currentPage}">
</form>

    <script>
    function sortList(colName) {
        // 1. JSP 변수(${sortCol}) 대신, 실제 폼의 hidden input 값을 읽어옵니다.
        let currentSortCol = document.getElementById('sortCol').value;
        let currentSortOrder = document.getElementById('sortOrder').value;
        
        // 2. 새로운 정렬 방향 결정
        let nextOrder = (currentSortCol === colName && currentSortOrder === 'ASC') ? 'DESC' : 'ASC';
        
        // 3. 폼에 값 대입
        document.getElementById('sortCol').value = colName;
        document.getElementById('sortOrder').value = nextOrder;
        document.getElementById('cpage').value = 1; // 정렬 시 1페이지로 초기화
        
        // 4. 폼 제출
        document.getElementById('pagingForm').submit();
    }
        function movePage(page) {
            document.getElementById("cpage").value = page;
            document.getElementById("pagingForm").submit();
        }
        function goDetail(cId) {
            let f = document.createElement("form");
            f.setAttribute("method", "post");
            f.setAttribute("action", "${pageContext.request.contextPath}/enrollment/detail");
            let i = document.createElement("input");
            i.setAttribute("type", "hidden");
            i.setAttribute("name", "courseId");
            i.setAttribute("value", cId);
            f.appendChild(i);
            document.body.appendChild(f);
            f.submit();
        }
        function resetSearch() {
            location.href = "${pageContext.request.contextPath}/enrollment/enrollMemList";
        }
    </script>
</body>
</html>	