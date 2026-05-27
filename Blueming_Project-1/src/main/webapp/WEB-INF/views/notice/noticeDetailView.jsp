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
                <td>15</td>

                <th>조회수</th>
                <td>128</td>
            </tr>

            <tr>
                <th>작성자</th>
                <td>관리자</td>

                <th>작성일</th>
                <td>2026-05-27</td>
            </tr>

            <tr>
                <th>제목</th>
                <td colspan="3">
                    시스템 점검 안내
                </td>
            </tr>

            <tr>
                <th>내용</th>
                <td colspan="3">

                    <div class="content-box">

                        안녕하세요.

                        2026년 5월 30일 새벽 2시부터 4시까지
                        서버 안정화 작업 및 시스템 점검이 진행될 예정입니다.

                        점검 시간 동안 일부 서비스 이용이 제한될 수 있습니다.

                        이용에 불편을 드려 죄송합니다.

                        감사합니다.

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