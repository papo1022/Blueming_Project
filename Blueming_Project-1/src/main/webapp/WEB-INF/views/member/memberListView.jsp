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
    <jsp:include page="../common/mainMenubar.jsp"/>

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
                <input type="search" name="keyword" id="keyword" value="${requestScope.keyword}" maxlength="100">
                <input type="hidden" name="sortColumn" value="${requestScope.sortColumn}">
                <input type="hidden" name="sortOrder" value="${requestScope.sortOrder}">
                <button type="submit" class="btn btn-primary">검색</button>
                <button type="button" class="btn btn-secondary" onclick="resetSearch()">초기화</button>
            </form>
        </div>

        <div style="width: 100%; max-width: 1000px; display: flex; justify-content: flex-end; margin-bottom: 10px;">
            <button type="button" class="btn btn-success" onclick="goEnrollForm();" style="font-weight: bold;">
                + 사원 추가
            </button>
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
                                    <td><c:out value="${member.deptName}" /></td>
                                    <td><c:out value="${member.positionName}" /></td>
                                    <td><c:out value="${member.name}" /></td>
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
function clickSort(columnName) {
    let form = document.getElementById('actionForm');
    document.getElementById('sortColumn').value = columnName;
    
    let currentOrder = document.getElementById('sortOrder').value;
    document.getElementById('sortOrder').value = (currentOrder === 'ASC') ? 'DESC' : 'ASC';
    
    document.getElementById('cpage').value = 1;
    form.submit();
}

function pageMove(page) {
    let actionForm = document.getElementById('actionForm');
    if (!actionForm) {
        console.error("actionForm을 찾을 수 없습니다!");
        return;
    }
    document.getElementById('cpage').value = page;
    actionForm.submit();
}

function goDetail(mId) {
    let f = document.createElement("form");
    f.method = "get";
    f.action = "${pageContext.request.contextPath}/memberlist/detail";

    let params = {
        "memberId" : mId,
        "cpage" : "${pi.currentPage}",
        "condition" : "${condition}",
        "keyword" : "${keyword}",
        "sortColumn" : "${sortColumn}",
        "sortOrder" : "${sortOrder}"
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

function resetSearch() {
    location.href = "${pageContext.request.contextPath}/memberlist";
}

function goEnrollForm() {
    // 🌟 404 에러를 유발하던 insertForm 대신, 컨트롤러 맵핑 경로인 enrollForm으로 정확히 변경!
    location.href = "${pageContext.request.contextPath}/memberlist/insertForm";
}
</script>
</body>
</html>