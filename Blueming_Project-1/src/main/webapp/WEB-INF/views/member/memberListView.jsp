<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	<div class="outer">
		<br>
		<h2>사원 인사정보 관리</h2>
		<br>

		<br><br>

		<div id="search-area" align="center">

			<form action="" method="">

				<select name="condition">
					<option value="memberId">사원번호</option>
					<option value="dept">부서</option>
					<option value="position">직급</option>
					<option value="name">이름</option>

				</select>

				<input type="search" name="keyword" value="">

				<button type="submit">검색</button>



			</form>

		</div>

		<br><br>

		<table class="table table-bordered table-sm">
			<thead>
				<tr>
					<th>사원번호</th>
					<th>부서</th>
					<th>직급</th>
					<th>이름</th>
					<th>입사일</th>
				</tr>
			</thead>

			<tbody>
				<tr>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>

			</tbody>


		</table>











	</div>














</body>
</html>