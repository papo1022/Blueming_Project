<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사원 인사정보 관리</title>
<style>
    .table tbody tr {
        cursor: pointer;
    }
    
    .table tbody tr:hover {
        background-color: #f5f5f5;
    }
    
    .table thead th {
        cursor: pointer;
        background-color: #f8f9fa;
        user-select: none;
    }

    /* 💡 페이징 바 양끝 정렬 및 고정 스타일 정의 */
    .pagination-wrapper {
        display: table;
        width: 100%;
        max-width: 600px;
        margin: 20px auto;
        text-align: center;
    }
    .page-side-left {
        display: table-cell;
        width: 25%;
        text-align: left;
        vertical-align: middle;
    }
    .page-numbers {
        display: table-cell;
        width: 50%;
        text-align: center;
        vertical-align: middle;
    }
    .page-side-right {
        display: table-cell;
        width: 25%;
        text-align: right;
        vertical-align: middle;
    }
    
    /* 페이징 버튼 기본 공통 디자인 */
    .pagination-wrapper a, .pagination-wrapper span {
        display: inline-block;
        padding: 5px 10px;
        margin: 0 3px;
        text-decoration: none;
        color: #333;
        border: 1px solid #ddd;
        border-radius: 4px;
        font-size: 13px;
    }
    /* 비활성화 상태의 양끝 버튼 디자인 */
    .pagination-wrapper .disabled-btn {
        color: #bbb;
        background-color: #f8f9fa;
        border-color: #eee;
        cursor: not-allowed;
        pointer-events: none; /* 클릭 방지 */
    }
    
    .btn-add-member {
        position: fixed; bottom: 30px; right: 30px;
        background-color: #007bff; color: white; padding: 15px 25px;
        border-radius: 50px; border: none; cursor: pointer;
        font-weight: bold; box-shadow: 0 4px 6px rgba(0,0,0,0.2);
        z-index: 1000;
    }
</style>
</head>
<body>
    <jsp:include page="../common/menubar.jsp"/>

    <div class="outer">
        <br>
        <h2>사원 인사정보 관리</h2>
        <br><br>

        <div id="search-area" align="center">
            <form id="search-form" action="/blueming/memberlist/search" method="post">
				<select name="condition">
				    <option value="memberId" ${requestScope.condition == 'memberId' ? 'selected' : ''}>사원번호</option>
				    <option value="deptId" ${requestScope.condition == 'deptId' ? 'selected' : ''}>부서</option>
				    <option value="positionId" ${requestScope.condition == 'positionId' ? 'selected' : ''}>직급</option>
				    <option value="name" ${requestScope.condition == 'name' ? 'selected' : ''}>이름</option>
				    <option value="status" ${requestScope.condition == 'status' ? 'selected' : ''}>상태(재직/휴직/퇴사)</option>
    			</select>
                <input type="search" name="keyword" value="${requestScope.keyword}">
                
                <input type="hidden" name="sortColumn" value="${requestScope.sortColumn}">
                <input type="hidden" name="sortOrder" value="${requestScope.sortOrder}">

                <button type="submit" class="btn btn-primary">검색</button>
				<button type="button" class="btn btn-secondary" onclick="resetSearch()">초기화</button>
            </form>
        </div>

        <br><br>

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
                        <tr align="center">
                            <td colspan="6">조회된 사원 정보가 없습니다.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="member" items="${requestScope.list}">
						    <tr align="center" onclick="goDetail(${member.memberId})">
						        <td>${member.memberId}</td>
						        
						        <td>${member.deptName}</td>
						        <td>${member.positionName}</td>
						        
						        <td>${member.name}</td>
						        
						        <td>
						            <c:choose>
						                <c:when test="${member.status == 'Y'}"><span style="color: green; font-weight: bold;">재직</span></c:when>
						                <c:when test="${member.status == 'R'}"><span style="color: orange; font-weight: bold;">휴직</span></c:when>
						                <c:when test="${member.status == 'N'}"><span style="color: red; font-weight: bold;">퇴사</span></c:when>
						                <c:otherwise>${member.status}</c:otherwise>
						            </c:choose>
						        </td>
						        
						        <td>
						            <fmt:formatDate value="${member.hireDate}" pattern="yyyy-MM-dd"/>
						        </td>
						    </tr>
						</c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

        <br><br>
        
        
        <form id="goInsertForm" action="/blueming/memberlist/insertForm" method="post" style="display:none;"><form></form>
	

			<button type="button" class="btn-add-member" onclick="document.getElementById('goInsertForm').submit();">
			    + 사원 추가
			</button>
        
        
        <div class="pagination-wrapper">
            <c:if test="${not empty requestScope.pi}">
                
                <div class="page-side-left">
                    <c:choose>
                        <c:when test="${requestScope.pi.currentPage > 1}">
                            <a href="javascript:void(0);" onclick="pageMove(1)">처음</a>
                            <a href="javascript:void(0);" onclick="pageMove(${requestScope.pi.currentPage - 1})">이전</a>
                        </c:when>
                        <c:otherwise>
                            <span class="disabled-btn">처음</span>
                            <span class="disabled-btn">이전</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="page-numbers">
                    <c:forEach var="p" begin="${requestScope.pi.startPage}" end="${requestScope.pi.endPage}">
                        <c:choose>
                            <c:when test="${p == requestScope.pi.currentPage}">
                                <span style="color: red; font-weight: bold; background-color: #fff1f0; border-color: #ffa39e;">${p}</span>
                            </c:when>
                            <c:otherwise>
                                <a href="javascript:void(0);" onclick="pageMove(${p})">${p}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </div>

                <div class="page-side-right">
                    <c:choose>
                        <c:when test="${requestScope.pi.currentPage < requestScope.pi.maxPage}">
                            <a href="javascript:void(0);" onclick="pageMove(${requestScope.pi.currentPage + 1})">다음</a>
                            <a href="javascript:void(0);" onclick="pageMove(${requestScope.pi.maxPage})">마지막</a>
                        </c:when>
                        <c:otherwise>
                            <span class="disabled-btn">다음</span>
                            <span class="disabled-btn">마지막</span>
                        </c:otherwise>
                    </c:choose>
                </div>
                
            </c:if>
        </div>
    </div>

    <form id="actionForm" action="/blueming/memberlist/search" method="post">
        <input type="hidden" name="cpage" id="formCpage" value="${requestScope.pi.currentPage != null ? requestScope.pi.currentPage : 1}">
        <input type="hidden" name="condition" id="formCondition" value="${requestScope.condition}">
        <input type="hidden" name="keyword" id="formKeyword" value="${requestScope.keyword}">
        <input type="hidden" name="sortColumn" id="formSortColumn" value="${requestScope.sortColumn}">
        <input type="hidden" name="sortOrder" id="formSortOrder" value="${requestScope.sortOrder}">
    </form>
    
    <form id="detailForm" action="/blueming/memberlist/detail" method="post">
         <input type="hidden" name="memberId" id="detailMemberId" value="">
    </form>

    <script>
        // 🎯 [추가] 화면이 새로고침되거나 로드될 때, 이전에 선택했던 검색 탭과 검색어를 복원합니다.
        window.addEventListener('DOMContentLoaded', function() {
            let savedCondition = sessionStorage.getItem('savedCondition');
            let savedKeyword = sessionStorage.getItem('savedKeyword');
            
            let searchForm = document.getElementById("search-form");
            
            // 저장된 값이 있다면 상단 검색창에 강제로 매핑
            if (savedCondition && searchForm.condition) {
                searchForm.condition.value = savedCondition;
            }
            if (savedKeyword !== null && searchForm.keyword) {
                searchForm.keyword.value = savedKeyword;
            }
        });

        // 🎯 [추가] 검색 폼이 제출(Submit)될 때 현재 선택된 탭 값을 브라우저 메모리에 저장합니다.
        document.getElementById("search-form").addEventListener("submit", function() {
            sessionStorage.setItem('savedCondition', this.condition.value);
            sessionStorage.setItem('savedKeyword', this.keyword.value);
        });

        function goDetail(memberId) {
            document.getElementById("detailMemberId").value = memberId;
            document.getElementById("detailForm").submit();
        }

        // 페이징 이동
        function pageMove(page) {
            let searchForm = document.getElementById("search-form");
            
            document.getElementById("formCpage").value = page;
            document.getElementById("formCondition").value = searchForm.condition.value;
            document.getElementById("formKeyword").value = searchForm.keyword.value;
            
            // 페이징 이동 시에도 값을 기억하도록 저장
            sessionStorage.setItem('savedCondition', searchForm.condition.value);
            sessionStorage.setItem('savedKeyword', searchForm.keyword.value);
            
            document.getElementById("actionForm").submit();
        }

        // 정렬 클릭
        function clickSort(column) {
            let currentColumn = "${requestScope.sortColumn}";
            let currentOrder = "${requestScope.sortOrder}";
            let searchForm = document.getElementById("search-form");
            
            if(!currentColumn) currentColumn = "MEMBER_ID";
            if(!currentOrder) currentOrder = "ASC";
            
            let nextOrder = "ASC";
            if(column === currentColumn) {
                nextOrder = (currentOrder === "ASC") ? "DESC" : "ASC";
            } else {
                nextOrder = "ASC";
            }
            
            document.getElementById("formCondition").value = searchForm.condition.value;
            document.getElementById("formKeyword").value = searchForm.keyword.value;
            
            document.getElementById("formSortColumn").value = column;
            document.getElementById("formSortOrder").value = nextOrder;
            document.getElementById("formCpage").value = "1";
            
            // 정렬 클릭 시에도 값을 기억하도록 저장
            sessionStorage.setItem('savedCondition', searchForm.condition.value);
            sessionStorage.setItem('savedKeyword', searchForm.keyword.value);
            
            document.getElementById("actionForm").submit();
        }
     
        function resetSearch() {
            // 1. 브라우저 세션 스토리지에 저장되어 있던 캐시 데이터 삭제
            sessionStorage.removeItem('savedCondition');
            sessionStorage.removeItem('savedKeyword');
            
            // 2. 상단 검색 폼 필드 비우기
            let searchForm = document.getElementById("search-form");
            if(searchForm) {
                searchForm.condition.value = "memberId"; // 기본 선택값으로 리셋
                searchForm.keyword.value = "";
            }
            
            // 3. 서버로 전송할 hidden 폼(actionForm)의 모든 검색/정렬 필드를 초기값으로 세팅
            document.getElementById("formCpage").value = "1";
            document.getElementById("formCondition").value = "";
            document.getElementById("formKeyword").value = "";
            document.getElementById("formSortColumn").value = "MEMBER_ID";
            document.getElementById("formSortOrder").value = "DESC"; // 최신 등록 사원순 정렬로 리셋
            
            // 4. 🎯 POST 방식으로 안전하게 폼 서브밋 실행 (405 에러 원천 차단)
            document.getElementById("actionForm").submit();
        }
    </script>
</body>
</html>