<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 목록</title>

<style>

    body{
        font-family: Arial, sans-serif;
        background-color: #f5f6fa;
        margin: 0;
        padding: 30px;
    }

    .notice-wrap{
        width: 1000px;
        margin: auto;
        background-color: white;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.08);
    }

    .notice-title{
        font-size: 28px;
        font-weight: bold;
        margin-bottom: 20px;
    }

    table{
        width: 100%;
        border-collapse: collapse;
    }

    thead{
        background-color: #2f3542;
        color: white;
    }

    th, td{
        padding: 14px;
        text-align: center;
        border-bottom: 1px solid #ddd;
    }

    tbody tr:hover{
        background-color: #f1f2f6;
        cursor: pointer;
    }

</style>

</head>
<body>

    <div class="notice-wrap">

        <div class="notice-title">
            공지사항
        </div>
        
        <form action="enrollForm" method="get">
            <c:choose>
                <c:when test="${not empty sessionScope.loginMember 
                    and sessionScope.loginMember.role eq 'S'}">
                    <button>글쓰기</button>
                </c:when>
            </c:choose>
            
        </form>

        <table>
            <thead>
                <tr>
                    <th width="10%">번호</th>
                    <th width="45%">제목</th>
                    <th width="15%">작성자</th>
                    <th width="10%">조회수</th>
                    <th width="20%">작성일</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty requestScope.list}">
                        <tr>
                            <td colspan=5>
                                조회된 게시글이 없습니다.
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="n" items="${requestScope.list}">
                           <tr>
                                <td width="10%">${n.noticeId}</td>
                                <td width="45%">${n.noticeTitle}</td>
                                <td width="15%">${n.memberId}</td>
                                <td width="10%">${n.count}</td>
                                <td width="20%">${n.createdDate}</td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</body>
</html>