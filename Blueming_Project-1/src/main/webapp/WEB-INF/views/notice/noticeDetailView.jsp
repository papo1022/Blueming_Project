<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 상세조회</title>

<style>

    body{
        margin: 0;
        padding: 30px;
        background-color: #f5f6fa;
        font-family: Arial, sans-serif;
    }

    .detail-wrap{
        width: 1000px;
        margin: auto;
        background-color: white;
        border-radius: 12px;
        padding: 40px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.08);
    }

    .detail-title{
        font-size: 30px;
        font-weight: bold;
        margin-bottom: 30px;
    }

    table{
        width: 100%;
        border-collapse: collapse;
    }

    th{
        width: 150px;
        background-color: #f1f2f6;
        padding: 15px;
        border-bottom: 1px solid #ddd;
        text-align: center;
    }

    td{
        padding: 15px;
        border-bottom: 1px solid #ddd;
    }

    .content-box{
        min-height: 300px;
        line-height: 1.7;
        white-space: pre-wrap;
    }

    .btn-area{
        margin-top: 30px;
        text-align: center;
    }

    button{
        width: 120px;
        padding: 12px;
        border: none;
        border-radius: 6px;
        font-size: 15px;
        cursor: pointer;
        margin: 0 5px;
    }

    .list-btn{
        background-color: #57606f;
        color: white;
    }

    .edit-btn{
        background-color: #3742fa;
        color: white;
    }

    .delete-btn{
        background-color: #ff4757;
        color: white;
    }

</style>

</head>
<body>

    <div class="detail-wrap">

        <div class="detail-title">
            공지사항 상세조회
        </div>

        <table>

            <tr>
                <th>번호</th>
                <td>${n.noticeId}</td>

                <th>조회수</th>
                <td>${n.count}</td>
            </tr>

            <tr>
                <th>작성자</th>
                <td>${n.name}</td>

                <th>작성일</th>
                <td>${n.createdDate}</td>
            </tr>

            <tr>
                <th>제목</th>
                <td colspan="3">
                    ${n.noticeTitle}
                </td>
            </tr>

            <tr>
                <th>내용</th>
                <td colspan="3">

                    <div class="content-box">
                        ${n.content}
                    </div>

                </td>
            </tr>

        </table>

        <div class="btn-area">

            <button 
                class="list-btn"
                onclick="location.href='${pageContext.request.contextPath}/notice/list'"
            >
                목록가기
            </button>

            <button class="edit-btn">
                수정
            </button>

            <button class="delete-btn">
                삭제
            </button>

        </div>

    </div>

</body>
</html>