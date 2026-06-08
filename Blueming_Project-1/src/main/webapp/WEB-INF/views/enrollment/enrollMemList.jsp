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
    <jsp:include page="../common/mainMenubar.jsp"/>
    
    <div class="outer">
        <h2>수강 정보 관리</h2>
        
        <form id="searchForm" action="${pageContext.request.contextPath}/enrollment/enrollMemList" method="post">
            <select name="condition" id="searchCondition">
                <option value="course">강의명</option>
            </select>
        
            <input type="text" name="keyword" value="${keyword}" id="searchKeyword">
        
            <button type="submit">검색</button>
            <button type="button" onclick="clearSearchInput();">초기화</button>
        </form>

        <div class="table-container">
            <table class="table table-bordered">
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

    <form id="pagingForm" action="${pageContext.request.contextPath}/enrollment/enrollMemList" method="post">
        <input type="hidden" name="condition" value="${condition}">
        <input type="hidden" name="keyword" value="${keyword}">
        <input type="hidden" name="sortCol" id="sortCol" value="${sortCol}">
        <input type="hidden" name="sortOrder" id="sortOrder" value="${sortOrder}">
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

    function goDetail(cId) {
        let f = document.createElement("form");
        f.method = "post";
        f.action = "${pageContext.request.contextPath}/enrollment/enrollMemDetail";

        let params = {
            "courseId" : cId,
            "cpage" : "${pi.currentPage}", // 목록의 원래 페이지 번호
            "condition" : "${condition}",
            "keyword" : "${keyword}",
            
            // ❌ [기존 폼에 있던 것] "sortCol" : "${sortCol}" ◀ 이걸 그대로 보내면 상세 정렬이 목록 정렬로 덮어씌워집니다!
            // 🌟 [수정] 목록에서 쓰던 정렬 컬럼 정보는 이름을 바꾸어 안전하게 대피시킵니다.
            "listSortCol" : "${sortCol}",   
            "listSortOrder" : "${sortOrder}"
            
            // 여기에 "sortCol": "DEPARTMENT_NAME"을 직접 적어서 보내거나, 
            // 아예 안 보내야 컨트롤러의 defaultValue="DEPARTMENT_NAME"이 깨끗하게 작동합니다.
        };

        for(let key in params){
            let input = document.createElement("input");
            input.type = "hidden";
            input.name = key;
            input.value = params[key];
            f.appendChild(input);
        }

        document.body.appendChild(f);
        f.submit();
    }
  
    // 🌟 [완성] 현재 페이지 번호는 완벽하게 사수하면서 기존 좀비 검색어만 싹 청소하여 새로고침하는 로직입니다.
    function clearSearchInput() {
        // 1. 화면의 검색창 비우기
        document.getElementById("searchKeyword").value = "";
        document.getElementById("searchCondition").selectedIndex = 0;
        
        // 2. 폼 객체를 정확하게 찾아옵니다. (id 지정 완료)
        let f = document.getElementById("searchForm");
        
        // 3. 현재 보고 있는 페이지 번호(cpage)를 빈 검색어와 함께 세트로 제출하기 위해 히든 태그로 심어줍니다.
        let pageInput = document.createElement("input");
        pageInput.type = "hidden";
        pageInput.name = "cpage";
        pageInput.value = "${pi.currentPage}"; 
        f.appendChild(pageInput);
        
        // 4. 깨끗하게 비워진 상태로 서버에 재요청! 
        // 서버 측 페이징 정보(pi)와 하단 페이징 히든 바구니들이 전부 검색어 없는 상태로 리프레시됩니다.
        f.submit(); 
    }
    </script>
</body>
</html>