<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사원 인사정보 관리</title>
<style>
    html, body { height: 100%; margin: 0; }
    .outer { display: flex; flex-direction: column; min-height: 80vh; padding: 20px; align-items: center; }
    .table-container { flex: 1; width: 100%; max-width: 1000px; }
    .table tbody tr td:not(:last-child) { cursor: pointer; }
    .table tbody tr:hover { background-color: #f5f5f5; }
    .table thead th { cursor: pointer; background-color: #f8f9fa; user-select: none; }
    .pagination-wrapper { display: flex; justify-content: center; margin-top: 20px; padding-bottom: 20px; }
    .pagination-wrapper a, .pagination-wrapper span { display: inline-block; padding: 5px 12px; margin: 0 3px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; text-decoration: none; color: #333; }
    .disabled-btn { color: #ccc !important; }
</style>
</head>
<body>
    <jsp:include page="../common/menubar.jsp"/>

    <div class="outer">
        <h2>사원 인사정보 관리</h2>
        
        <div id="search-area" align="center" style="margin-bottom: 20px;">
            <form id="search-form" action="${pageContext.request.contextPath}/memberlist" method="get">
                <select name="condition" id="condition">
                    <option value="memberId" ${requestScope.condition == 'memberId' ? 'selected' : ''}>사원번호</option>
                    <option value="deptId" ${requestScope.condition == 'deptId' ? 'selected' : ''}>부서</option>
                    <option value="positionId" ${requestScope.condition == 'positionId' ? 'selected' : ''}>직급</option>
                    <option value="name" ${requestScope.condition == 'name' ? 'selected' : ''}>이름</option>
                    <option value="status" ${requestScope.condition == 'status' ? 'selected' : ''}>상태</option>
                </select>
                <input type="search" name="keyword" id="keyword" value="${requestScope.keyword}">
                <input type="hidden" name="sortColumn" value="${requestScope.sortColumn}">
                <input type="hidden" name="sortOrder" value="${requestScope.sortOrder}">
                <button type="submit" class="btn btn-primary">검색</button>
                <button type="button" class="btn btn-secondary" onclick="resetSearch()">초기화</button>
            </form>
        </div>

        <div class="table-container">
            <table class="table table-bordered table-sm">
                <thead>
                    <tr>
                        <th onclick="clickSort('MEMBER_ID')">사원번호 ${requestScope.sortColumn == 'MEMBER_ID' ? (requestScope.sortOrder == 'ASC' ? '▲' : '▼') : ''}</th>
                        <th onclick="clickSort('DEPARTMENT_ID')">부서 ${requestScope.sortColumn == 'DEPARTMENT_ID' ? (requestScope.sortOrder == 'ASC' ? '▲' : '▼') : ''}</th>
                        <th onclick="clickSort('POSITION_ID')">직급 ${requestScope.sortColumn == 'POSITION_ID' ? (requestScope.sortOrder == 'ASC' ? '▲' : '▼') : ''}</th>
                        <th onclick="clickSort('NAME')">이름 ${requestScope.sortColumn == 'NAME' ? (requestScope.sortOrder == 'ASC' ? '▲' : '▼') : ''}</th>
                        <th onclick="clickSort('STATUS')">상태 ${requestScope.sortColumn == 'STATUS' ? (requestScope.sortOrder == 'ASC' ? '▲' : '▼') : ''}</th>
                        <th onclick="clickSort('HIRE_DATE')">입사일 ${requestScope.sortColumn == 'HIRE_DATE' ? (requestScope.sortOrder == 'ASC' ? '▲' : '▼') : ''}</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty requestScope.list}">
                            <tr><td colspan="6" align="center">조회된 사원 정보가 없습니다.</td></tr>
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
                                            <c:when test="${member.status == 'Y'}"><span style="color: green; font-weight: bold;">재직</span></c:when>
                                            <c:when test="${member.status == 'R'}"><span style="color: orange; font-weight: bold;">휴직</span></c:when>
                                            <c:when test="${member.status == 'N'}"><span style="color: red; font-weight: bold;">퇴사</span></c:when>
                                        </c:choose>
                                    </td>
                                    <td><fmt:formatDate value="${member.hireDate}" pattern="yyyy-MM-dd"/></td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <div class="pagination-wrapper">
            <c:if test="${not empty requestScope.pi}">
                <c:choose>
                    <c:when test="${requestScope.pi.currentPage > 1}">
                        <a href="javascript:void(0);" onclick="pageMove(1)">처음</a>
                        <a href="javascript:void(0);" onclick='pageMove("${requestScope.pi.currentPage - 1}")'>이전</a>
                    </c:when>
                    <c:otherwise><span class="disabled-btn">처음</span><span class="disabled-btn">이전</span></c:otherwise>
                </c:choose>
                <c:forEach var="p" begin="${requestScope.pi.startPage}" end="${requestScope.pi.endPage}">
                    <c:choose>
                        <c:when test="${p == requestScope.pi.currentPage}"><span style="color: red; font-weight: bold;">${p}</span></c:when>
                        <c:otherwise><a href="javascript:void(0);" onclick='pageMove("${p}")'>${p}</a></c:otherwise>
                    </c:choose>
                </c:forEach>
                <c:choose>
                    <c:when test="${requestScope.pi.currentPage < requestScope.pi.maxPage}">
                        <a href="javascript:void(0);" onclick='pageMove("${requestScope.pi.currentPage + 1}")'>다음</a>
                        <a href="javascript:void(0);" onclick='pageMove("${requestScope.pi.maxPage}")'>마지막</a>
                    </c:when>
                    <c:otherwise><span class="disabled-btn">다음</span><span class="disabled-btn">마지막</span></c:otherwise>
                </c:choose>
            </c:if>
        </div>
    </div>
		
   

	<form id="actionForm" action="${pageContext.request.contextPath}/memberlist" method="get" style="display:none;">
    <input type="hidden" name="cpage" id="cpage">
    <input type="hidden" name="sortColumn" id="sortColumn" value="${requestScope.sortColumn}">
    <input type="hidden" name="sortOrder" id="sortOrder" value="${requestScope.sortOrder}">
    
    <input type="hidden" name="condition" value="${requestScope.condition}">
    <input type="hidden" name="keyword" value="${requestScope.keyword}">
</form>

<script>
//JSP 하단의 스크립트 수정
function clickSort(columnName) {
    // 폼 객체 가져오기
    let form = document.getElementById('actionForm');
    
    // 정렬값 갱신
    document.getElementById('sortColumn').value = columnName;
    
    // 기존 순서 확인
    let currentOrder = document.getElementById('sortOrder').value;
    document.getElementById('sortOrder').value = (currentOrder === 'ASC') ? 'DESC' : 'ASC';
    
    // 페이지를 1로 초기화하여 검색 결과를 처음부터 보여줌
    document.getElementById('cpage').value = 1;
    
    form.submit();
}

function pageMove(page) {
    // 폼 객체 확인
    let actionForm = document.getElementById('actionForm');
    if (!actionForm) {
        console.error("actionForm을 찾을 수 없습니다!");
        return;
    }
    
    // 값 세팅
    document.getElementById('cpage').value = page;
    
    // 로그 확인
    console.log("제출할 폼의 cpage 값: " + document.getElementById('cpage').value);
    
    // 폼 제출 (강제)
    actionForm.submit();
}

 // 상세 보기 버튼 클릭 시 실행할 함수
    // 추천 방식: 폼 전송 말고 URL 이동
function goDetail(memberId) {
    location.href = "${pageContext.request.contextPath}/memberlist/detail?memberId=" + memberId;
}


function resetSearch() {
    // 검색 폼의 action URL로 이동하되, 파라미터 없이 보냄
    location.href = "${pageContext.request.contextPath}/memberlist";
}
</script>
</body>
</html>