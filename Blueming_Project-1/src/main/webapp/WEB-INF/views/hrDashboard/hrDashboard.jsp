<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>인사 대시보드 - 수강 현황</title>
<style>
    /* 앞서 정의한 테이블 디자인과 동일 */
    .progress-table { width: 100%; border-collapse: collapse; margin: 20px 0; font-size: 14px; text-align: left;}
    .progress-table th { background-color: #4A6572; color: white; padding: 12px 15px; border: 1px solid #dbdbdb; text-align: center; }
    .progress-table td { padding: 12px 15px; border: 1px solid #dbdbdb; }
    .progress-table tbody tr:nth-of-type(even) { background-color: #f8f9fa; }
    .progress-table tbody tr:hover { background-color: #f1f3f5; }
    .text-center { text-align: center; }
    .text-right { text-align: right; }
    .fw-bold { font-weight: bold; }
    .completed { color: #2b8a3e; font-weight: bold; }
</style>
</head>
<body>
	
    <h2>사원별 교육 이수율 현황</h2>

    <table class="progress-table">
        <thead>
            <tr>
                <th>이름</th>
                <th>부서</th>
                <th>직급</th>
                <th>이메일</th>
                <th>이수율</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${empty progressList}">
                    <tr>
                        <td colspan="5" class="text-center">조회된 데이터가 없습니다.</td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="item" items="${progressList}">
					    <tr>
					        <td><c:out value="${item.name}"/></td>
					        <td><c:out value="${item.departmentName}"/></td> 
					        <td><c:out value="${item.positionName}"/></td>   
					        <td><c:out value="${item.email}"/></td>
					        <td><c:out value="${item.progressRate}"/>%</td>  
					    </tr>
					</c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

</body>
</html>