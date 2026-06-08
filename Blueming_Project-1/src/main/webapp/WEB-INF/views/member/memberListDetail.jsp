<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사원 상세정보</title>
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
                <%-- 1. 기본 정보 출력 (반복문 활용) --%>
                <c:set var="items" value="사원번호:${member.memberId},이름:${member.name},로그인ID:${member.loginId},이메일:${member.email},연락처:${member.phone},주소:${member.address},부서:${member.deptName},직급:${member.positionName}" />
                <c:forEach var="item" items="${fn:split(items, ',')}">
                    <div class="detail-row">
                        <div class="detail-label">${fn:split(item, ':')[0]}</div>
                        <div class="detail-value">${fn:split(item, ':')[1]}</div>
                    </div>
                </c:forEach>

                <%-- 2. 입사일 및 상태 --%>
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
                
                <%-- 3. 추가 정보 (휴직/퇴사일) --%>
                <c:if test="${member.status == 'R' or member.status == 'N'}">
                    <div class="detail-row">
                        <div class="detail-label">${member.status == 'R' ? '휴직기간' : '퇴사일'}</div>
                        <div class="detail-value">
                            <c:choose>
                                <c:when test="${member.status == 'R'}">
                                    ${fn:substring(member.leaveStartDate,0,4)}-${fn:substring(member.leaveStartDate,4,6)}-${fn:substring(member.leaveStartDate,6,8)} 
                                    ~ ${fn:substring(member.leaveEndDate,0,4)}-${fn:substring(member.leaveEndDate,4,6)}-${fn:substring(member.leaveEndDate,6,8)}
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
            <button class="btn btn-secondary" onclick="location.href='${pageContext.request.contextPath}/memberlist'">목록</button>
        </div>

        <form id="editForm" action="/blueming/memberlist/updateForm" method="post">
            <input type="hidden" name="memberId" value="${member.memberId}">
        </form>
    </div> 
</body>
</html>