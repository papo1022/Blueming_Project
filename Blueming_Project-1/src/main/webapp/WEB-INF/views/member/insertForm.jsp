<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사원 추가</title>
<style>
    .insert-container { width: 600px; margin: 40px auto; border: 1px solid #ddd; padding: 30px; border-radius: 8px; }
    .insert-row { display: flex; margin-bottom: 15px; border-bottom: 1px solid #eee; padding-bottom: 10px; align-items: center; }
    .insert-label { width: 30%; font-weight: bold; background-color: #f8f9fa; padding: 10px; }
    .insert-value { width: 70%; padding: 5px 10px; }
    .insert-value input, .insert-value select { width: 100%; padding: 8px; box-sizing: border-box; }
    .btn-group { text-align: center; margin-top: 30px; }
    .btn { padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; }
    .btn-primary { background-color: #007bff; color: white; }
</style>
</head>
<body>
    <div class="insert-container">
        <h2>사원 추가</h2>
        <form action="/blueming/memberlist/insert" method="post">
            
            <div class="insert-row">
                <div class="insert-label">이름</div>
                <div class="insert-value"><input type="text" name="name" required></div>
            </div>
            
            <div class="insert-row">
                <div class="insert-label">로그인ID</div>
                <div class="insert-value"><input type="text" name="loginId" required></div>
            </div>

            <div class="insert-row">
                <div class="insert-label">비밀번호</div>
                <div class="insert-value"><input type="password" name="loginPwd" required></div>
            </div>
            
            <div class="insert-row">
                <div class="insert-label">부서</div>
                <div class="insert-value">
                    <select name="deptId">
                        <option value="D01">인사팀</option>
                        <option value="D02">개발팀</option>
                        <option value="D03">디자인팀</option>
                        <option value="D04">영업팀</option>
                        <option value="D05">마케팅팀</option>
                    </select>
                </div>
            </div>
            
            <div class="insert-row">
                <div class="insert-label">직급</div>
                <div class="insert-value">
                    <select name="positionId">
                        <option value="P01">사원</option>
                        <option value="P02">주임</option>
                        <option value="P03">대리</option>
                        <option value="P04">과장</option>
                    </select>
                </div>
            </div>
            
            <div class="insert-row">
                <div class="insert-label">입사일</div>
                <div class="insert-value"><input type="date" name="hireDate" required></div>
            </div>

            <div class="btn-group">
                <button type="submit" class="btn btn-primary">등록</button>
                <button type="button" class="btn" onclick="history.back()">취소</button>
            </div>
        </form>
    </div>
</body>
</html>