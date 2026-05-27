<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>notice 작성</title>

<style>

    body{
        margin: 0;
        padding: 30px;
        background-color: #f5f6fa;
        font-family: Arial, sans-serif;
    }

    .notice-wrap{
        width: 900px;
        margin: auto;
        background-color: white;
        padding: 40px;
        border-radius: 12px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.08);
    }

    .notice-title{
        font-size: 28px;
        font-weight: bold;
        margin-bottom: 30px;
    }

    table{
        width: 100%;
        border-collapse: collapse;
    }

    th{
        width: 120px;
        background-color: #f1f2f6;
        text-align: center;
        padding: 15px;
        border-bottom: 1px solid #ddd;
    }

    td{
        padding: 15px;
        border-bottom: 1px solid #ddd;
    }

    input[type=text]{
        width: 100%;
        padding: 12px;
        border: 1px solid #ccc;
        border-radius: 6px;
        box-sizing: border-box;
        font-size: 14px;
    }

    textarea{
        width: 100%;
        height: 300px;
        padding: 12px;
        border: 1px solid #ccc;
        border-radius: 6px;
        resize: none;
        box-sizing: border-box;
        font-size: 14px;
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

    .submit-btn{
        background-color: #3742fa;
        color: white;
    }

    .cancel-btn{
        background-color: #747d8c;
        color: white;
    }

</style>

</head>
<body>

    <div class="notice-wrap">

        <div class="notice-title">
            공지사항 작성
        </div>

        <form action="${pageContext.request.contextPath}/notice/insert" method="post">

            <input type="hidden" name="noticeWirter" value="${sessionScope.loginMember.memberId}">
            <table>

                <tr>
                    <th>제목</th>
                    <td>
                        <input 
                            type="text" 
                            name="noticeTitle"
                            placeholder="제목을 입력하세요."
                            required
                        >
                    </td>
                </tr>

                <tr>
                    <th>내용</th>
                    <td>
                        <textarea 
                            name="content"
                            placeholder="내용을 입력하세요."
                            required
                        ></textarea>
                    </td>
                </tr>

            </table>

            <div class="btn-area">

                <button type="submit" class="submit-btn">
                    등록
                </button>

                <button 
                    type="reset"
                    class="cancel-btn"
                >
                    초기화
                </button>

            </div>

        </form>

    </div>

</body>
</html>