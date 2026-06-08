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
           <td>상태 : </td>
<td>
    <c:choose>
        <c:when test="${c.status == 'W' || c.STATUS == 'W'}"><span >예정</span></c:when>
        <c:when test="${c.status == 'Y' || c.STATUS == 'Y'}"><span >진행중</span></c:when>
        <c:when test="${c.status == 'N' || c.STATUS == 'N'}"><span >종료</span></c:when>
        <c:otherwise>
            ${not empty c.status ? c.status : c.STATUS}
        </c:otherwise>
    </c:choose>
</td>
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
        <th><a href="javascript:void(0);" onclick="sortDetail('CHAP_COMP_RATE')" class="sort-link">이수율 </a></th>
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
                    <td>${item.deptName}</td>
					<td>${item.positionName}</td>
					<td>${item.name}</td>
					<td>
    <div style="display:flex; align-items:center; gap:8px;">

        <span style="width:45px;">
            ${item.chapCompRate}%
        </span>

        <div style="
            width:80px;
            height:10px;
            background:#e9ecef;
            border-radius:5px;
            overflow:hidden;">

            <div style="
                width:${item.chapCompRate}%;
                height:100%;
                background:
				${item.chapCompRate < 30 ? '#dc3545'
				 : item.chapCompRate < 70 ? '#ffc107'
				 : '#28a745'};
                transition:width .3s;">
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

        <c:choose>
        <c:when test="${pi.currentPage <= 1}">
            <button disabled>이전</button>
        </c:when>
        <c:otherwise>
            <button onclick="pagingSubmit(${pi.currentPage - 1})">
                이전
            </button>
        </c:otherwise>
    </c:choose>

    <c:forEach var="p" begin="${pi.startPage}" end="${pi.endPage}">
        <c:choose>
            <c:when test="${p eq pi.currentPage}">
                <button disabled>${p}</button>
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
            <button onclick="pagingSubmit(${pi.currentPage + 1})">
                다음
            </button>
        </c:otherwise>
    </c:choose>

        </div>
    </div>
    <br>
    
  <div align="center" style="margin-top: 20px; margin-bottom: 20px;">
    <button type="button" class="btn btn-secondary" onclick="goList();">목록으로</button>
</div>


    
   <form id="pagingForm" action="${pageContext.request.contextPath}/enrollment/enrollMemDetail" method="post" style="display:none;">
    <input type="hidden" name="courseId" value="${courseId}">
    
    <input type="hidden" name="detailCpage" id="cpage" value="${pi.currentPage}">
    
    <input type="hidden" name="sortCol" id="sortCol" value="${sortCol}">
    <input type="hidden" name="sortOrder" id="sortOrder" value="${sortOrder}">
    <input type="hidden" name="deptFilter" id="deptFilterHidden" value="${deptFilter}">
    
    <input type="hidden" name="cpage" value="${cpage}"> 
    <input type="hidden" name="condition" value="${listCondition}">
    <input type="hidden" name="keyword" value="${listKeyword}">
</form>

<script>
    // 2. 정렬 함수 추가
   // 페이징 함수 수정

// 페이징 함수 수정
function pagingSubmit(page) {
    document.getElementById('cpage').value = page;
    
    // 상세 페이지의 pagingForm은 이제 condition과 keyword를 input으로 가지고 있어야 합니다.
    // 폼이 제출될 때 이 값들이 함께 서버로 갑니다.
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

// 부서 필터 함수
function filterByDept() {
    let deptId = document.getElementById('deptFilter').value;
    document.getElementById('deptFilterHidden').value = deptId;
    document.getElementById('cpage').value = 1; // 필터 변경 시 1페이지로
    document.getElementById('pagingForm').submit();
}

    
    
 // 목록 페이지(enrollMemList.jsp)의 goDetail 함수
    function goDetail(cId) {
        let f = document.createElement("form");
        f.setAttribute("method", "post");
        f.setAttribute("action", "${pageContext.request.contextPath}/enrollment/enrollMemDetail");
        
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
        
        let params = {
            "condition": "${listCondition}",
            "keyword": "${listKeyword}",
            "sortCol": "${listSortCol}",
            "sortOrder": "${listSortOrder}",
            "cpage": "${cpage}",
            "fromDetail": "Y" // 🌟 [핵심 추가] 상세페이지에서 온 진짜 요청임을 증명하는 토큰
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
        
        return false;
    }
    
</script>
</body>
</html>