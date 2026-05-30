<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"
    uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>blueming</title>
<style>
    .outer {
        width : 90%;
        margin : 0 auto;
    }
</style>
</head>
<body>

    <jsp:include page="../common/mainMenubar.jsp" />

    <div class="outer">

        <br>
        <h2 align="center">챕터 상세조회</h2>
        <br>

        <table id="detail-area" class="table">
            <tr>
                <th>챕터명</th>
                <td>${ requestScope.chapter.chapterTitle }</td>
            </tr>
            <tr>
                <th>올린 날짜</th>
                <td>${ requestScope.chapter.createDate }</td>
            </tr>
            <tr>
                <th>업데이트 날짜</th>
                <td>${ requestScope.chapter.updatedDate}</td>
            </tr>
        </table>

        <!-- 관리자에게만 보이는 버튼-->
        <div align="center">
            <button class="btn btn-warning" onclick="">
                챕터 수정
            </button>
            <button class="btn btn-danger" onclick="">
                챕터 삭제
            </button>
            <br><br>
        </div>

        <h2 align="center">챕터 통계 </h2>
        <!-- 여기에 통계가 들어감 암 그렇고 말고 -->

    </div>

    <script>
    </script>
</body>
</html>