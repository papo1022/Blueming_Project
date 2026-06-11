<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사원 상세정보</title>
<link rel="stylesheet" href="https://cdn-uicons.flaticon.com/uicons-regular-rounded/css/uicons-regular-rounded.css">
<link rel="stylesheet" href="https://cdn-uicons.flaticon.com/uicons-solid-rounded/css/uicons-solid-rounded.css">
<style>
    .detail-container { width: 600px; margin: 40px auto; border: 1px solid #ddd; padding: 30px; border-radius: 8px; }
    .detail-container h2 { text-align: center; margin-bottom: 30px; }
    .detail-row { display: flex; margin-bottom: 15px; border-bottom: 1px solid #eee; padding-bottom: 10px; }
    .detail-label { width: 30%; font-weight: bold; background-color: #f8f9fa; padding: 10px; }
    .detail-value { width: 70%; padding: 10px; }
    .btn-group { text-align: center; margin-top: 30px; }
    .btn { padding: 10px 20px; margin: 0 5px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; }
    .btn-primary { background-color: #007bff; color: white; }
    .btn-secondary { background-color: #6c757d; color: white; }
</style>
</head>
<body>
    <jsp:include page="../common/menubar.jsp"/>

	<div class="detail-container">
		<h2>사원 상세정보</h2>

		<c:choose>
			<c:when test="${empty member}">
				<p align="center">사원 정보를 찾을 수 없습니다.</p>
			</c:when>
			<c:otherwise>
				<c:choose>
					<c:when test="${member.role eq 'R'}"><c:set var="roleName" value="인사" /></c:when>
					<c:when test="${member.role eq 'S'}"><c:set var="roleName" value="강사" /></c:when>
					<c:otherwise><c:set var="roleName" value="사원" /></c:otherwise>
				</c:choose>

				<div class="detail-row">
					<div class="detail-label">사원번호</div>
					<div class="detail-value"><c:out value="${member.memberId}" /></div>
				</div>
				<div class="detail-row">
					<div class="detail-label">이름</div>
					<div class="detail-value"><c:out value="${member.name}" /></div>
				</div>
				<div class="detail-row">
					<div class="detail-label">로그인ID</div>
					<div class="detail-value"><c:out value="${member.loginId}" /></div>
				</div>
				<div class="detail-row">
					<div class="detail-label">이메일</div>
					<div class="detail-value"><c:out value="${member.email}" /></div>
				</div>
				<div class="detail-row">
					<div class="detail-label">연락처</div>
					<div class="detail-value"><c:out value="${member.phone}" /></div>
				</div>
				<div class="detail-row">
					<div class="detail-label">주소</div>
					<div class="detail-value"><c:out value="${member.address}" /></div>
				</div>
				<div class="detail-row">
					<div class="detail-label">부서</div>
					<div class="detail-value"><c:out value="${member.deptName}" /></div>
				</div>
				<div class="detail-row">
					<div class="detail-label">직급</div>
					<div class="detail-value"><c:out value="${member.positionName}" /></div>
				</div>
				<div class="detail-row">
					<div class="detail-label">권한코드</div>
					<div class="detail-value"><c:out value="${roleName}" /></div>
				</div>

				<%-- 입사일 및 상태 --%>
				<div class="detail-row">
					<div class="detail-label">입사일</div>
					<div class="detail-value"><fmt:formatDate value="${member.hireDate}" pattern="yyyy-MM-dd"/></div>
				</div>
				<div class="detail-row">
					<div class="detail-label">상태</div>
					<div class="detail-value">
						<c:choose>
							<c:when test="${member.status == 'Y'}">재직</c:when>
							<c:when test="${member.status == 'R'}">휴직</c:when>
							<c:when test="${member.status == 'N'}">퇴사</c:when>
						</c:choose>
					</div>
				</div>

				<%-- 추가 정보 (휴직/퇴사일) --%>
				<c:if test="${member.status == 'R' or member.status == 'N'}">
					<div class="detail-row">
						<div class="detail-label">${member.status == 'R' ? '휴직기간' : '퇴사일'}</div>
						<div class="detail-value">
							<c:choose>
								<c:when test="${member.status == 'R'}">
									<c:out value="${fn:substring(member.leaveStartDate,0,4)}-${fn:substring(member.leaveStartDate,4,6)}-${fn:substring(member.leaveStartDate,6,8)}" />
									~ 
									<c:out value="${fn:substring(member.leaveEndDate,0,4)}-${fn:substring(member.leaveEndDate,4,6)}-${fn:substring(member.leaveEndDate,6,8)}" />
								</c:when>
								<c:otherwise>
									<fmt:formatDate value="${member.retireDate}" pattern="yyyy-MM-dd"/>
								</c:otherwise>
							</c:choose>
						</div>
					</div>
				</c:if>
			</c:otherwise>
		</c:choose>

		<div class="btn-group">
			<button class="btn btn-primary" onclick="document.getElementById('editForm').submit()">수정</button>
			<button class="btn btn-secondary" onclick="goMemberList();">목록</button>
		</div>

		<form id="editForm" action="${pageContext.request.contextPath}/memberlist/updateForm" method="post">
			<input type="hidden" name="memberId" value="<c:out value='${member.memberId}' />">
		</form>
	</div>

<script>
function goMemberList() {
    let f = document.createElement("form");
    f.setAttribute("method", "post");
    f.setAttribute("action", "${pageContext.request.contextPath}/memberlist"); 
    
    // 🛡️ 스크립트 내부 주입 공격 방어를 위해 EL 데이터를 문자열 처리 및 트림 처리
    let params = {
        "cpage": "<c:out value='${listCpage}' />",         
        "condition": "<c:out value='${listCondition}' />", 
        "keyword": "<c:out value='${listKeyword}' />",     
        "sortColumn": "<c:out value='${listSortColumn}' />",
        "sortOrder": "<c:out value='${listSortOrder}' />"
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