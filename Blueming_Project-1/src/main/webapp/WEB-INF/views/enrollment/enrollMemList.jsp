<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>수강 정보 관리</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/enrollMemList.css">
<link rel="stylesheet" href="https://cdn-uicons.flaticon.com/uicons-regular-rounded/css/uicons-regular-rounded.css">
<link rel="stylesheet" href="https://cdn-uicons.flaticon.com/uicons-solid-rounded/css/uicons-solid-rounded.css">

</head>
<body>
    <jsp:include page="../common/mainMenubar.jsp"/>
    
    <div class="outer">
       
        
        <form id="searchForm" action="${pageContext.request.contextPath}/enrollment/enrollMemList" method="get" class="search-con">
            <select name="condition" id="searchCondition" class="search-sel">
                <option value="course" ${condition == 'course' ? 'selected' : ''}>강의명</option>
            </select>
        
            <input type="text" name="keyword" value="<c:out value='${keyword}' />" id="searchKeyword" maxlength="100" class="input">
        
            <button type="submit" class="search-btn"><i class="fi fi-rr-search"></i></button>
            <button type="button" onclick="clearSearchInput();" class="reset"><i class="fi fi-rr-cross"></i></button>
            
        </form>

        <div class="table-container">
            <table class="list">
                <thead>
                    <tr>
                        <th><a href="javascript:void(0);" onclick="sortList('COURSE_TITLE')" class="sort-link">강의명 </a></th>
                        <th><a href="javascript:void(0);" onclick="sortList('START_DATE')" class="sort-link">시작일 </a></th>
                        <th><a href="javascript:void(0);" onclick="sortList('END_DATE')" class="sort-link">종료일 </a></th>
                        <th><a href="javascript:void(0);" onclick="sortList('STATUS')" class="sort-link">상태 </a></th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty list}">
                            <tr><td colspan="4">조회된 수강 정보가 없습니다.</td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="item" items="${list}">
                                <tr onclick="goDetail('<c:out value="${item.courseId}"/>')">
                                    <td><c:out value="${item.courseTitle}" /></td>
                                    <td><c:out value="${item.startDate}" /></td>
                                    <td><c:out value="${item.endDate}" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.status == 'W'}"><span style="color: blue;">예정</span></c:when>
                                            <c:when test="${item.status == 'Y'}"><span style="color: green; font-weight: bold;">진행중</span></c:when>
                                            <c:when test="${item.status == 'N'}"><span style="color: gray;">종료</span></c:when>
                                            <c:otherwise><c:out value="${item.status}" /></c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

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

    <form id="pagingForm" action="${pageContext.request.contextPath}/enrollment/enrollMemList" method="get">
        <input type="hidden" name="condition" value="<c:out value='${condition}' />">
        <input type="hidden" name="keyword" value="<c:out value='${keyword}' />">
        <input type="hidden" name="sortCol" id="sortCol" value="<c:out value='${sortCol}' />">
        <input type="hidden" name="sortOrder" id="sortOrder" value="<c:out value='${sortOrder}' />">
        <input type="hidden" name="cpage" id="cpage" value="${pi.currentPage}">
    </form>

    <script>
    function sortList(colName) {
        let currentSortCol = document.getElementById('sortCol').value;
        let currentSortOrder = document.getElementById('sortOrder').value;
        
        let nextOrder = (currentSortCol === colName && currentSortOrder === 'ASC') ? 'DESC' : 'ASC';
        
        document.getElementById('sortCol').value = colName;
        document.getElementById('sortOrder').value = nextOrder;
        document.getElementById('cpage').value = 1; 
        
        document.getElementById('pagingForm').submit();
    }

    function movePage(page) {
        document.getElementById("cpage").value = page;
        document.getElementById("pagingForm").submit();
    }

    // 🌟 [교정 완료] 불필요하게 쪼개져 덩그러니 남겨져 있던 잔여 유령 스크립트를 완벽하게 삭제했습니다.
    function goDetail(cId) {
        let f = document.createElement("form");
        f.setAttribute("method", "get"); 
        f.setAttribute("action", "${pageContext.request.contextPath}/enrollment/enrollMemDetail");
        
        let params = {
            "courseId" : cId,
            "cpage" : "${pi.currentPage}", 
            "condition" : "<c:out value='${condition}' />",
            "keyword" : "<c:out value='${keyword}' />",
            "listSortCol" : "<c:out value='${sortCol}' />",   
            "listSortOrder" : "<c:out value='${sortOrder}' />"
        };
        
        for (let key in params) {
            let val = params[key] ? params[key].trim() : "";
            if (val !== undefined && val !== null && val !== 'null' && val !== '') {
                let i = document.createElement("input");
                i.setAttribute("type", "hidden");
                i.setAttribute("name", key);
                i.setAttribute("value", val);
                f.appendChild(i);
            }
        }
        document.body.appendChild(f);
        f.submit();
    }
  
    function clearSearchInput() {
        document.getElementById("searchKeyword").value = "";
        document.getElementById("searchCondition").selectedIndex = 0;
        
        let f = document.getElementById("searchForm");
        
        let pageInput = document.createElement("input");
        pageInput.type = "hidden";
        pageInput.name = "cpage";
        pageInput.value = "${pi.currentPage}"; 
        f.appendChild(pageInput);
        
        f.submit(); 
    }
    </script>
</body>
</html>