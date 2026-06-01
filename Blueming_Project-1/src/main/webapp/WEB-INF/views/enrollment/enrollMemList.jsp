<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>수강 정보 관리</title>
<style>
    /* 기존 레이아웃 스타일 */
    .outer { display: flex; flex-direction: column; min-height: 70vh; padding: 20px; align-items: center; }
    .table-container { flex: 1; width: 100%; max-width: 800px; }
    .table { width: 100%; border-collapse: collapse; margin-top: 20px; }
    .table tbody tr { cursor: pointer; }
    .table tbody tr:hover { background-color: #f5f5f5; }
    .table th, .table td { padding: 10px; border: 1px solid #ddd; text-align: center; }

    /* 정렬 링크 스타일 (밑줄 제거 및 검정색 고정) */
    .sort-link {
        text-decoration: none;
        color: black;
        cursor: pointer;
        display: block; /* 클릭 영역 확대 */
    }

    /* 페이징바 스타일 */
    .pagination-wrapper { display: flex; justify-content: center; margin-top: 30px; padding-bottom: 20px; }
    .pagination-wrapper a, .pagination-wrapper span { display: inline-block; padding: 5px 12px; margin: 0 3px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; text-decoration: none; color: #333; }
    .disabled-btn { color: #ccc !important; cursor: default; }
</style>
</head>
<body>
    <jsp:include page="../common/menubar.jsp"/>
    
    <div class="outer">
        <h2>수강 정보 관리</h2>
        
        <form action="/blueming/enrollment/list" method="post" style="margin-bottom: 20px;">
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
                    <tr>
                        <th><a href="javascript:void(0);" onclick="sortList('COURSE_TITLE')" class="sort-link">강의명 ↓</a></th>
                        <th><a href="javascript:void(0);" onclick="sortList('START_DATE')" class="sort-link">시작일 ↓</a></th>
                        <th><a href="javascript:void(0);" onclick="sortList('END_DATE')" class="sort-link">종료일 ↓</a></th>
                        <th>상태</th>
                    </tr>
                </thead>
                <tbody>
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
                </tbody>
            </table>
        </div>

        <div class="pagination-wrapper">
            <c:if test="${not empty pi}">
                <c:choose>
                    <c:when test="${pi.currentPage > 1}">
                        <a href="javascript:void(0);" onclick="movePage(1)">처음</a>
                        <a href="javascript:void(0);" onclick="movePage(${pi.currentPage - 1})">이전</a>
                    </c:when>
                    <c:otherwise><span class="disabled-btn">처음</span><span class="disabled-btn">이전</span></c:otherwise>
                </c:choose>
                <c:forEach var="p" begin="${pi.startPage}" end="${pi.endPage}">
                    <c:choose>
                        <c:when test="${p == pi.currentPage}"><span style="color: red; font-weight: bold; border-color: red;">${p}</span></c:when>
                        <c:otherwise><a href="javascript:void(0);" onclick="movePage(${p})">${p}</a></c:otherwise>
                    </c:choose>
                </c:forEach>
                <c:choose>
                    <c:when test="${pi.currentPage < pi.maxPage}">
                        <a href="javascript:void(0);" onclick="movePage(${pi.currentPage + 1})">다음</a>
                        <a href="javascript:void(0);" onclick="movePage(${pi.maxPage})">마지막</a>
                    </c:when>
                    <c:otherwise><span class="disabled-btn">다음</span><span class="disabled-btn">마지막</span></c:otherwise>
                </c:choose>
            </c:if>
        </div>
    </div>

    <form id="pagingForm" action="/blueming/enrollment/list" method="post" style="display:none;">
        <input type="hidden" name="condition" value="${condition}">
        <input type="hidden" name="keyword" value="${keyword}">
        <input type="hidden" name="cpage" id="cpage">
        <input type="hidden" name="sortCol" id="sortCol" value="${sortCol}">
        <input type="hidden" name="sortOrder" id="sortOrder" value="${sortOrder}">
    </form>

    <form id="detailForm" action="/blueming/enrollment/detail" method="post">
        <input type="hidden" name="courseId" id="detailCourseId">
    </form>

    <script>
        function sortList(colName) {
            let currentSortCol = "${sortCol}";
            let currentSortOrder = "${sortOrder}";
            let nextOrder = (currentSortCol === colName && currentSortOrder === 'ASC') ? 'DESC' : 'ASC';
            
            document.getElementById('sortCol').value = colName;
            document.getElementById('sortOrder').value = nextOrder;
            document.getElementById('cpage').value = 1; // 정렬 시 1페이지로 초기화
            document.getElementById('pagingForm').submit();
        }
        function movePage(page) {
            document.getElementById("cpage").value = page;
            document.getElementById("pagingForm").submit();
        }
        function goDetail(cId) {
            document.getElementById("detailCourseId").value = cId;
            document.getElementById("detailForm").submit();
        }
        
  
        function resetSearch() {
            // 1. 화면에 보이는 검색창의 값을 강제로 비움
            document.querySelector("input[name='keyword']").value = "";
            
            // 2. 검색 조건(select)을 기본값으로 선택 (필요시)
            document.querySelector("select[name='condition']").selectedIndex = 0;
            
            // 3. 페이징 폼 내부의 히든 필드들도 비우거나 초기화
            document.getElementById('cpage').value = 1;
            document.getElementById('sortCol').value = "COURSE_ID";
            document.getElementById('sortOrder').value = "DESC";
            
            // 4. 검색용 폼이 아닌, 페이지/검색 정보를 담고 있는 'pagingForm'을 제출
            // 이때 pagingForm 내부의 keyword 히든 필드도 비워줘야 합니다!
            document.querySelector("#pagingForm input[name='keyword']").value = "";
            document.querySelector("#pagingForm input[name='condition']").value = "course";
            
            document.getElementById('pagingForm').submit();
        }

    </script>
</body>
</html>