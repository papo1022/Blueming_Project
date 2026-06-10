<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>강의 상세 및 수강생 현황</title>
    <style>
        .progress-bg { width: 100px; height: 10px; background: #eee; border-radius: 5px; display: inline-block; }
        .progress-bar { height: 100%; border-radius: 5px; }
        .paging-area button { margin: 0 5px; padding: 5px 10px; cursor: pointer; }
        .sort-link { text-decoration: none; color: black; font-weight: bold; }
    </style>
</head>
<body>
    <jsp:include page="../common/menubar.jsp"/>

    <div class="outer" align="center">
        <h2><c:out value="${c.COURSE_TITLE}" /> 강의 상세 정보</h2>
        
        <div>
            기간: <c:out value="${c.START_DATE}" /> ~ <c:out value="${c.END_DATE}" /> | 
            상태 : 
            <c:choose>
                <c:when test="${c.status == 'W' || c.STATUS == 'W'}"><span>예정</span></c:when>
                <c:when test="${c.status == 'Y' || c.STATUS == 'Y'}"><span>진행중</span></c:when>
                <c:when test="${c.status == 'N' || c.STATUS == 'N'}"><span>종료</span></c:when>
                <c:otherwise>
                    <c:out value="${not empty c.status ? c.status : c.STATUS}" />
                </c:otherwise>
            </c:choose>
        </div>
        
        <br>
        <div style="margin: 20px 0;" align="left">
            <select id="deptFilter" onchange="filterByDept()">
			    <option value="">전체 부서</option>
			    <c:forEach var="dept" items="${deptList}">
                    <option value="<c:out value='${dept.DEPARTMENT_ID}' />" <c:if test="${deptFilter eq dept.DEPARTMENT_ID}">selected</c:if>>
			            <c:out value="${dept.DEPARTMENT_NAME}" />
			        </option>
			    </c:forEach>
			</select>
        </div>

        <table class="table table-bordered">
            <thead>
                <tr>
                    <th><a href="javascript:void(0);" onclick="sortDetail('DEPARTMENT_NAME')" class="sort-link">부서 </a></th>
                    <th><a href="javascript:void(0);" onclick="sortDetail('POSITION_NAME')" class="sort-link">직급 </a></th>
                    <th><a href="javascript:void(0);" onclick="sortDetail('NAME')" class="sort-link">이름 </a></th>
                    <th><a href="javascript:void(0);" onclick="sortDetail('CHAP_COMP_RATE')" class="sort-link">이수율 </a></th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty enrollList}">
                        <tr>
                            <td colspan="4" align="center" style="padding: 20px;">
                                해당 조건의 수강생이 없습니다.
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="item" items="${enrollList}">
                            <tr>
                                <td><c:out value="${item.deptName}" /></td>
                                <td><c:out value="${item.positionName}" /></td>
                                <td><c:out value="${item.name}" /></td>
                                <td>
                                    <div style="display:flex; align-items:center; gap:8px;">
                                        <span style="width:45px;">
                                            <c:out value="${item.chapCompRate}" />%
                                        </span>
                                        <div style="width:80px; height:10px; background:#e9ecef; border-radius:5px; overflow:hidden;">
                                            <div style="width:<c:out value='${item.chapCompRate}' />%; height:100%; background:${item.chapCompRate < 30 ? '#dc3545' : item.chapCompRate < 70 ? '#ffc107' : '#28a745'}; transition:width .3s;"></div>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

        <div class="paging-area">
            <c:choose>
                <c:when test="${pi.currentPage <= 1}">
                    <button disabled>이전</button>
                </c:when>
                <c:otherwise>
                    <button onclick="pagingSubmit(${pi.currentPage - 1})">이전</button>
                </c:otherwise>
            </c:choose>

            <c:forEach var="p" begin="${pi.startPage}" end="${pi.endPage}">
                <c:choose>
                    <c:when test="${p eq pi.currentPage}">
                        <button disabled style="font-weight:bold; color:red;">${p}</button>
                    </c:when>
                    <c:otherwise>
                        <button onclick="pagingSubmit(${p})">${p}</button>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <c:choose>
                <c:when test="${pi.currentPage >= pi.maxPage}">
                    <button disabled>다음</button>
                </c:when>
                <c:otherwise>
                    <button onclick="pagingSubmit(${pi.currentPage + 1})">다음</button>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <br>
    
    <div align="center" style="margin-top: 20px; margin-bottom: 20px;">
        <button type="button" class="btn btn-secondary" onclick="goList();">목록으로</button>
    </div>

    <form id="pagingForm" action="${pageContext.request.contextPath}/enrollment/enrollMemDetail" method="get" style="display:none;">
        <input type="hidden" name="courseId" value="<c:out value='${courseId}' />">
        <input type="hidden" name="detailCpage" id="cpage" value="${pi.currentPage}">
        <input type="hidden" name="sortCol" id="sortCol" value="<c:out value='${sortCol}' />">
        <input type="hidden" name="sortOrder" id="sortOrder" value="<c:out value='${sortOrder}' />">
        <input type="hidden" name="deptFilter" id="deptFilterHidden" value="<c:out value='${deptFilter}' />">
        
        <input type="hidden" name="cpage" value="${cpage}"> 
        <input type="hidden" name="condition" value="<c:out value='${listCondition}' />">
        <input type="hidden" name="keyword" value="<c:out value='${listKeyword}' />">
        <input type="hidden" name="listSortCol" value="<c:out value='${listSortCol}' />">
        <input type="hidden" name="listSortOrder" value="<c:out value='${listSortOrder}' />">
    </form>

<script>
function pagingSubmit(page) {
    document.getElementById('cpage').value = page;
    document.getElementById('pagingForm').submit();
}

function sortDetail(colName) {
    let currentSortCol = document.getElementById('sortCol').value;
    let currentSortOrder = document.getElementById('sortOrder').value;
    let nextOrder = (currentSortCol === colName && currentSortOrder === 'ASC') ? 'DESC' : 'ASC';
    
    document.getElementById('sortCol').value = colName;
    document.getElementById('sortOrder').value = nextOrder;
    document.getElementById('cpage').value = 1;
    document.getElementById('pagingForm').submit();
}

function filterByDept() {
    let deptId = document.getElementById('deptFilter').value;
    document.getElementById('deptFilterHidden').value = deptId;
    document.getElementById('cpage').value = 1; 
    document.getElementById('pagingForm').submit();
}

function goList() {
    let f = document.createElement("form");
    f.setAttribute("method", "get"); // 🌟 목록 복귀도 안전하게 GET으로 처리
    f.setAttribute("action", "${pageContext.request.contextPath}/enrollment/enrollMemList");
    
    // 🛡️ 스크립트 내부 인젝션 방어용 데이터 격리 매핑
    let params = {
        "condition": "<c:out value='${listCondition}' />",
        "keyword": "<c:out value='${listKeyword}' />",
        "sortCol": "<c:out value='${listSortCol}' />",
        "sortOrder": "<c:out value='${listSortOrder}' />",
        "cpage": "${cpage}"
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
</script>
</body>
</html>