<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 강의 목록</title>
</head>
<body>

<h3>내 강의 목록</h3>



<table>
    <tr>
        <th>강의명</th>
        <th>시작일</th>
        <th>종료일</th>
    </tr>

    <c:forEach var="c" items="${courseList}">
        <tr>
            <td>${c.courseTitle}</td>
            <td>${c.startDate}</td>
            <td>${c.endDate}</td>
        </tr>
    </c:forEach>
</table>

</body>
</html>