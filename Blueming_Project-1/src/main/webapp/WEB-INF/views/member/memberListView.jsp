<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사원 인사정보 관리</title>
<style>
    .table tbody tr td:not(:last-child) { cursor: pointer; }
    .table tbody tr:hover { background-color: #f5f5f5; }
    .table thead th { cursor: pointer; background-color: #f8f9fa; user-select: none; }
    .pagination-wrapper { display: table; width: 100%; max-width: 650px; margin: 20px auto; text-align: center; }
    .pagination-wrapper a, .pagination-wrapper span { display: inline-block; padding: 5px 10px; margin: 0 3px; border: 1px solid #ddd; border-radius: 4px; font-size: 13px; text-decoration: none; color: #333; }
    /* 사원 추가 버튼 스타일 */
    .btn-add-member { position: fixed; bottom: 30px; right: 30px; background-color: #007bff; color: white; padding: 15px 25px; border-radius: 50px; border: none; cursor: pointer; font-weight: bold; box-shadow: 0 4px 6px rgba(0,0,0,0.2); z-index: 1000; }
</style>
</head>
<body>
    <jsp:include page="../common/menubar.jsp"/>

    <div class="outer">
        <h2>사원 인사정보 관리</h2>
        
        <div id="search-area" align="center">
            <form id="search-form" action="/blueming/memberlist/search" method="post">
				<select name="condition" id="condition">
				    <option value="memberId" ${requestScope.condition == 'memberId' ? 'selected' : ''}>사원번호</option>
				    <option value="deptId" ${requestScope.condition == 'deptId' ? 'selected' : ''}>부서</option>
				    <option value="positionId" ${requestScope.condition == 'positionId' ? 'selected' : ''}>직급</option>
				    <option value="name" ${requestScope.condition == 'name' ? 'selected' : ''}>이름</option>
				    <option value="status" ${requestScope.condition == 'status' ? 'selected' : ''}>상태(재직/휴직/퇴사)</option>
    			</select>
                <input type="search" name="keyword" id="keyword" value="${requestScope.keyword}">
                
                <input type="hidden" name="sortColumn" value="${requestScope.sortColumn}">
                <input type="hidden" name="sortOrder" value="${requestScope.sortOrder}">

                <button type="submit" class="btn btn-primary">검색</button>
                <button type="button" class="btn btn-secondary" onclick="resetSearch()">초기화</button>
            </form>
        </div>

        <table class="table table-bordered table-sm">
            <thead>
                <tr>
                    <th onclick="clickSort('MEMBER_ID')">
                        사원번호 ${requestScope.sortColumn == 'MEMBER_ID' ? (requestScope.sortOrder == 'ASC' ? '▲' : '▼') : ''}
                    </th>

                    <th onclick="clickSort('DEPARTMENT_ID')">
                        부서 ${requestScope.sortColumn == 'DEPARTMENT_ID' ? (requestScope.sortOrder == 'ASC' ? '▲' : '▼') : ''}
                    </th>

                    <th onclick="clickSort('POSITION_ID')">
                        직급 ${requestScope.sortColumn == 'POSITION_ID' ? (requestScope.sortOrder == 'ASC' ? '▲' : '▼') : ''}
                    </th>

                    <th onclick="clickSort('NAME')">
                        이름 ${requestScope.sortColumn == 'NAME' ? (requestScope.sortOrder == 'ASC' ? '▲' : '▼') : ''}
                    </th>

                    <th onclick="clickSort('STATUS')">
                        상태 ${requestScope.sortColumn == 'STATUS' ? (requestScope.sortOrder == 'ASC' ? '▲' : '▼') : ''}
                    </th>

                    <th onclick="clickSort('HIRE_DATE')">
                        입사일 ${requestScope.sortColumn == 'HIRE_DATE' ? (requestScope.sortOrder == 'ASC' ? '▲' : '▼') : ''}
                    </th>

                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
    <c:choose>
        <c:when test="${empty requestScope.list}">
            <tr align="center">
                <td colspan="7">조회된 사원 정보가 없습니다.</td>
            </tr>
        </c:when>

        <c:otherwise>
            <c:forEach var="member" items="${requestScope.list}">
                <tr align="center" onclick='goDetail("${member.memberId}")'>

                    <td>${member.memberId}</td>

                    <td>${member.deptName}</td>

                    <td>${member.positionName}</td>

                    <td>${member.name}</td>

                    <td>
                        <c:choose>
                            <c:when test="${member.status == 'Y'}">
                                <span style="color: green; font-weight: bold;">재직</span>
                            </c:when>

                            <c:when test="${member.status == 'R'}">
                                <span style="color: orange; font-weight: bold;">휴직</span>
                            </c:when>

                            <c:when test="${member.status == 'N'}">
                                <span style="color: red; font-weight: bold;">퇴사</span>
                            </c:when>

                            <c:otherwise>
                                ${member.status}
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td>
                        <fmt:formatDate
                            value="${member.hireDate}"
                            pattern="yyyy-MM-dd"/>
                    </td>

                    <td>
                        <button
                            type="button"
                            class="btn btn-danger btn-sm"
                            onclick="event.stopPropagation(); deleteMember('${member.memberId}')">
                            삭제
                        </button>
                    </td>

                </tr>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</tbody>
</table>

<br><br>

<form id="goInsertForm"
      action="/blueming/memberlist/insertForm"
      method="post"
      style="display:none;">
</form>

<button type="button"
        class="btn-add-member"
        onclick="document.getElementById('goInsertForm').submit();">
    + 사원 추가
</button>

<div class="pagination-wrapper">

    <c:if test="${not empty requestScope.pi}">

        <div class="page-side-left">

            <c:choose>

                <c:when test="${requestScope.pi.currentPage > 1}">
                    <a href="javascript:void(0);" onclick="pageMove(1)">처음</a>

                    <a href="javascript:void(0);"
                       onclick='pageMove("${requestScope.pi.currentPage - 1}")'>
                        이전
                    </a>
                </c:when>

                <c:otherwise>
                    <span class="disabled-btn">처음</span>
                    <span class="disabled-btn">이전</span>
                </c:otherwise>

            </c:choose>

        </div>

        <div class="page-numbers">

            <c:forEach var="p"
                       begin="${requestScope.pi.startPage}"
                       end="${requestScope.pi.endPage}">

                <c:choose>

                    <c:when test="${p == requestScope.pi.currentPage}">
                        <span style="color: red;
                                     font-weight: bold;
                                     background-color: #fff1f0;
                                     border-color: #ffa39e;">
                            ${p}
                        </span>
                    </c:when>

                    <c:otherwise>
                        <a href="javascript:void(0);"
                           onclick='pageMove("${p}")'>
                            ${p}
                        </a>
                    </c:otherwise>

                </c:choose>

            </c:forEach>

        </div>

        <div class="page-side-right">

            <c:choose>

                <c:when test="${requestScope.pi.currentPage < requestScope.pi.maxPage}">
                    <a href="javascript:void(0);"
                       onclick='pageMove("${requestScope.pi.currentPage + 1}")'>
                        다음
                    </a>

                    <a href="javascript:void(0);"
                       onclick='pageMove("${requestScope.pi.maxPage}")'>
                        마지막
                    </a>
                </c:when>

                <c:otherwise>
                    <span class="disabled-btn">다음</span>
                    <span class="disabled-btn">마지막</span>
                </c:otherwise>

            </c:choose>

        </div>

    </c:if>

</div>

    <form id="actionForm" action="/blueming/memberlist/search" method="post">
        <input type="hidden" name="cpage" id="formCpage" value="1">
        <input type="hidden" name="condition" id="formCondition">
        <input type="hidden" name="keyword" id="formKeyword">
        <input type="hidden" name="sortColumn" id="formSortColumn" value="${requestScope.sortColumn}">
        <input type="hidden" name="sortOrder" id="formSortOrder" value="${requestScope.sortOrder}">
    </form>
    <form id="detailForm" action="/blueming/memberlist/detail" method="post"><input type="hidden" name="memberId" id="detailMemberId"></form>
    <form id="deleteForm" action="/blueming/memberlist/delete" method="post"><input type="hidden" name="memberId" id="deleteMemberId"></form>

    <script>
        // 1. 검색 상태 유지
        window.onload = () => {
            if(sessionStorage.getItem('cond')) document.getElementById('condition').value = sessionStorage.getItem('cond');
            if(sessionStorage.getItem('key')) document.getElementById('keyword').value = sessionStorage.getItem('key');
        };
        document.getElementById("search-form").onsubmit = () => {
            sessionStorage.setItem('cond', document.getElementById('condition').value);
            sessionStorage.setItem('key', document.getElementById('keyword').value);
        };

        // 2. 기능 구현
        function goDetail(id) { document.getElementById("detailMemberId").value = id; document.getElementById("detailForm").submit(); }
        function deleteMember(id) { if(confirm("정말 삭제하시겠습니까?")) { document.getElementById("deleteMemberId").value = id; document.getElementById("deleteForm").submit(); } }
        
        function pageMove(p) {
            syncForm();
            document.getElementById("formCpage").value = p;
            document.getElementById("actionForm").submit();
        }
        function clickSort(col) {
            syncForm();
            document.getElementById("formSortColumn").value = col;
            document.getElementById("formSortOrder").value = "${requestScope.sortOrder}" == 'ASC' ? 'DESC' : 'ASC';
            document.getElementById("actionForm").submit();
        }
        function syncForm() {
            document.getElementById("formCondition").value = document.getElementById('condition').value;
            document.getElementById("formKeyword").value = document.getElementById('keyword').value;
        }
        function resetSearch() { sessionStorage.clear(); location.href = "/blueming/memberlist"; }
    </script>
</body>
</html>