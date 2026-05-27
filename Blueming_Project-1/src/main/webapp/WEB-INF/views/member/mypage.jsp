<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

    <h2>비밀번호 찾기</h2>
    
    
    <div>
        <form id="slect-pwd" action="/blueming/member/select" method="post">
        <table>
            <tr>
                <th>아이디를 입력해주세요</th>
            <td>
                <input type="text" name="userId" maxlength="12" required>
            </td>
           </tr>
       

            
    </div>
    
    <div>
          <tr> 
            <button type="submit" class="btn btn-primary btn-sm" disabled>다음</button>
           </tr>
    </div>
   
</form>
</body>
</html>