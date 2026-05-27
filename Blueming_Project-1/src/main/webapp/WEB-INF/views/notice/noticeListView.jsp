<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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

                <tr>
                    <td>5</td>
                    <td>5월 시스템 점검 안내</td>
                    <td>관리자</td>
                    <td>152</td>
                    <td>2026-05-26</td>
                </tr>

                <tr>
                    <td>4</td>
                    <td>사내 교육 프로그램 신청 공지</td>
                    <td>관리자</td>
                    <td>98</td>
                    <td>2026-05-24</td>
                </tr>

                <tr>
                    <td>3</td>
                    <td>강의 업로드 일정 변경 안내</td>
                    <td>운영팀</td>
                    <td>67</td>
                    <td>2026-05-22</td>
                </tr>

                <tr>
                    <td>2</td>
                    <td>ERP 접속 오류 관련 공지</td>
                    <td>관리자</td>
                    <td>210</td>
                    <td>2026-05-20</td>
                </tr>

                <tr>
                    <td>1</td>
                    <td>신규 교육 콘텐츠 추가 안내</td>
                    <td>교육팀</td>
                    <td>134</td>
                    <td>2026-05-18</td>
                </tr>

            </tbody>

        </table>

    </div>

</body>
</html>