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
    </style>
</head>
<body>
    <jsp:include page="../common/menubar.jsp"/>

    <div class="outer" align="center">
        <h2>${c.COURSE_TITLE} 강의 상세 정보</h2>
        
       
        
        <div>
            기간: ${c.START_DATE} ~ ${c.END_DATE} | 
            상태: <span style="color: ${c.STATUS == 'Y' ? 'green' : 'gray'}; font-weight: bold;">${c.STATUS_NAME}</span>
        </div>
        
        <br>
        <div style="margin: 20px 0;" align="left">
            <select id="deptFilter" onchange="filterByDept()">
			    <option value="">전체 부서</option>
			    <c:forEach var="dept" items="${deptList}">
			        <option value="${dept.DEPARTMENT_ID}" <c:if test="${deptFilter eq dept.DEPARTMENT_ID}">selected</c:if>>
			            ${dept.DEPARTMENT_NAME}
			        </option>
			    </c:forEach>
			</select>
        </div>

        <table class="table table-bordered">
            </table>

		

        <table class="table table-bordered">
            <thead>
<thead>
    <tr>
        <th><a href="javascript:void(0);" onclick="sortDetail('DEPT_NAME')" class="sort-link">부서 </a></th>
        <th><a href="javascript:void(0);" onclick="sortDetail('POSITION_NAME')" class="sort-link">직급 </a></th>
        <th><a href="javascript:void(0);" onclick="sortDetail('NAME')" class="sort-link">이름 </a></th>
        <th><a href="javascript:void(0);" onclick="sortDetail('PROGRESS')" class="sort-link">이수율 </a></th>
    </tr>
</thead>

<tbody>
    <c:choose>
        <%-- 리스트가 비어있는 경우 --%>
        <c:when test="${empty enrollList}">
            <tr>
                <td colspan="4" align="center" style="padding: 20px;">
                    해당 조건의 수강생이 없습니다.
                </td>
            </tr>
        </c:when>
        <%-- 리스트에 데이터가 있는 경우 --%>
        <c:otherwise>
            <c:forEach var="item" items="${enrollList}">
                <tr>
                    <td>${item.DEPT_NAME}</td>
                    <td>${item.POSITION_NAME}</td>
                    <td>${item.NAME}</td>
                    <td>
                        <div style="display: flex; align-items: center; gap: 8px;">
                            <span>${item.PROGRESS}%</span>
                            <div style="width: 100px; height: 10px; background: #eee; border-radius: 5px; overflow: hidden;">
                                <div style="width: ${item.PROGRESS}%; height: 100%; 
                                     background: ${item.PROGRESS == 100 ? '#28a745' : '#007bff'};">
                                </div>
                            </div>
                        </div>
                    </td>
                </tr>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</tbody>
        </table>

        <c:if test="${not empty enrollList}">
	   		 <div class="paging-area" align="center" style="margin-top: 30px;">
	        </div>
		</c:if>
            <button <c:if test="${pi.currentPage eq 1}">disabled</c:if> 
                    onclick="pagingSubmit(${pi.currentPage - 1})">이전</button>

            <c:forEach var="p" begin="${pi.startPage}" end="${pi.endPage}">
                <button <c:if test="${p eq pi.currentPage}">disabled "</c:if> 
                        onclick="pagingSubmit(${p})">${p}</button>
            </c:forEach>

            <button <c:if test="${pi.currentPage eq pi.maxPage}">disabled</c:if> 
                    onclick="pagingSubmit(${pi.currentPage + 1})">다음</button>
                    

        </div>
    </div>
    
    <form action="${pageContext.request.contextPath}/enrollment/enrollMemList" method="post">
    <c:if test="${not empty condition}">
        <input type="hidden" name="condition" value="${condition}">
    </c:if>
    <c:if test="${not empty keyword}">
        <input type="hidden" name="keyword" value="${keyword}">
    </c:if>
    <input type="hidden" name="sortCol" value="${sortCol}">
    <input type="hidden" name="sortOrder" value="${sortOrder}">
    
    <button type="submit" align="center">목록으로</button>
</form>


    
   <form id="pagingForm" action="${pageContext.request.contextPath}/enrollment/detail" method="post" style="display:none;">
    <input type="hidden" name="courseId" value="${courseId}">
    <input type="hidden" name="cpage" id="cpage" value="${pi.currentPage}">
    <input type="hidden" name="sortCol" id="sortCol" value="${sortCol}">
    <input type="hidden" name="sortOrder" id="sortOrder" value="${sortOrder}">
    <input type="hidden" name="deptFilter" id="deptFilterHidden" value="${deptFilter}">
</form>

<script>
    // 2. 정렬 함수 추가
   // 페이징 함수 수정
function pagingSubmit(page) {
    document.getElementById('cpage').value = page;
    // 필터 값을 유지하기 위해 hidden 필드에 현재 선택된 값을 담아둠
    // 이미 폼에 deptFilterHidden이 있으므로 그대로 제출하면 됨
    document.getElementById('pagingForm').submit();
}

// 정렬 함수 수정
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
 
        
        // hidden 필드에 값 할당
        document.getElementById('deptFilterHidden').value = deptId;
        
        // 폼 제출
        document.getElementById('pagingForm').submit();
    }
    
    
 // 목록 페이지(enrollMemList.jsp)의 goDetail 함수
    function goDetail(cId) {
        let f = document.createElement("form");
        f.setAttribute("method", "post");
        f.setAttribute("action", "${pageContext.request.contextPath}/enrollment/detail");
        
        // 기존 코드에 아래를 추가해서 검색 조건도 같이 보내야 합니다.
        let inputs = {
            "courseId": cId,
            "condition": "${condition}", // 검색 조건 추가
            "keyword": "${keyword}"     // 검색어 추가
        };
        
        for (let key in inputs) {
            let i = document.createElement("input");
            i.setAttribute("type", "hidden");
            i.setAttribute("name", key);
            i.setAttribute("value", inputs[key]);
            f.appendChild(i);
        }
        document.body.appendChild(f);
        f.submit();
    }
    function goList() {
        let f = document.createElement("form");
        f.setAttribute("method", "post");
        f.setAttribute("action", "${pageContext.request.contextPath}/enrollment/enrollMemList");
        
        // 1. 필요한 모든 데이터를 params 객체에 담습니다.
        // JSP에서 전달받은 모델값(${condition}, ${keyword} 등)이 여기에 들어갑니다.
        let params = {
            "condition": "${condition}",
            "keyword": "${keyword}",
            "sortCol": "${sortCol}",
            "sortOrder": "${sortOrder}"
        };
        
        // 2. params 객체를 돌면서 form에 input을 하나씩 추가합니다.
        for (let key in params) {
            // 값이 존재할 때만 보냅니다.
            if (params[key] && params[key] !== 'null' && params[key] !== '') {
                let i = document.createElement("input");
                i.setAttribute("type", "hidden");
                i.setAttribute("name", key);
                i.setAttribute("value", params[key]);
                f.appendChild(i);
            }
        }
        
        document.body.appendChild(f);
        f.submit();
    }
    
</script>
</body>
</html>