<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사원 상세정보</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/member/memberList.css">
<link rel="stylesheet" href="https://cdn-uicons.flaticon.com/uicons-regular-rounded/css/uicons-regular-rounded.css">
<link rel="stylesheet" href="https://cdn-uicons.flaticon.com/uicons-solid-rounded/css/uicons-solid-rounded.css">

</head>
<body>
	<jsp:include page="../common/mainMenubar.jsp"/>

	<div class="container">
		<div class="content-wrapper">

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

				<div class="row">
					<div class="label">사원번호</div>
					<div class="value"><c:out value="${member.memberId}" /></div>
				</div>
				
				<div class="row">
					<div class="label">로그인ID</div>
					<div class="value"><c:out value="${member.loginId}" /></div>
				</div>
				<div class="row">
					<div class="label">이름</div>
					<div class="value"><c:out value="${member.name}" /></div>
				</div>
				<div class="row">
					<div class="label">이메일</div>
					<div class="value"><c:out value="${member.email}" /></div>
				</div>
				<div class="row">
					<div class="label">연락처</div>
					<div class="value"><c:out value="${member.phone}" /></div>
				</div>
				<div class="row">
					<div class="label">주소</div>
					<div class="value"><c:out value="${member.address}" /></div>
				</div>
				<div class="row">
					<div class="label">부서</div>
					<div class="value"><c:out value="${member.deptName}" /></div>
				</div>
				<div class="row">
					<div class="label">직급</div>
					<div class="value"><c:out value="${member.positionName}" /></div>
				</div>
				<div class="row">
					<div class="label">권한코드</div>
					<div class="value"><c:out value="${roleName}" /></div>
				</div>

				<%-- 입사일 및 상태 --%>
				<div class="row">
					<div class="label">입사일</div>
					<div class="value"><fmt:formatDate value="${member.hireDate}" pattern="yyyy-MM-dd"/></div>
				</div>
				<div class="row last-row">
					<div class="label">상태</div>
					<div class="value">
						<c:choose>
							<c:when test="${member.status == 'Y'}">재직</c:when>
							<c:when test="${member.status == 'R'}">휴직</c:when>
							<c:when test="${member.status == 'N'}">퇴사</c:when>
						</c:choose>
					</div>
				</div>

				<%-- 추가 정보 (휴직/퇴사일) --%>
				<c:if test="${member.status == 'R' or member.status == 'N'}">
					<div class="row">
						<div class="label">${member.status == 'R' ? '휴직기간' : '퇴사일'}</div>
						<div class="value">
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
		
		<div class="row btn-row">
		<div class="value btn-group">
			<button class="btn1" onclick="document.getElementById('editForm').submit()">수정</button>
			<button class="btn2" onclick="goMemberList();">목록</button>
		</div>

		<form id="editForm" action="${pageContext.request.contextPath}/memberlist/updateForm" method="post">
			<input type="hidden" name="memberId" value="<c:out value='${member.memberId}' />">
		</form>
		</div>
		
		
		</div>
		
		
		
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