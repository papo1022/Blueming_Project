<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>수강 정보 관리</title>
</head>
<body>
		<jsp:include page="../common/menubar.jsp"/>
		
		
    <h2>수강 정보 관리</h2>
    
    <form id="pagingForm" action="/blueming/enrollment/enrollMemList" method="post" style="display:none;">
	    <input type="hidden" name="condition" value="${condition}">
	    <input type="hidden" name="keyword" value="${keyword}">
	    <input type="hidden" name="cpage" id="cpage">
	</form>

	<script>
	    function movePage(page) {
	        document.getElementById("cpage").value = page;
	        document.getElementById("pagingForm").submit();
	    }
	</script>
    
	 
</body>
</html>