<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/notice/noticeFormShared.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/notice/noticeUpdateForm.css">
</head>
<body>

	<jsp:include page="../common/mainMenubar.jsp" />

	<div class="outer">

    <div class="page-title">
         공지사항 수정
    </div>

    <div class="notice-card">

        <div class="notice-header"></div>

        <form id="update-form"
              action="/blueming/notice/update"
              method="post">

            <input type="hidden"
                   name="noticeId"
                   value="${requestScope.n.noticeId}">

            <table>

				<tr>
				    <th>제목</th>
				    <td>
				        <input type="text"
				               id="noticeTitle"
				               name="noticeTitle"
				               value="${requestScope.n.noticeTitle}"
				               maxlength="15"
				               required>
				        <div class="counter-text">
                            <span id="title-curr">0</span> / 15자
                        </div>

				    </td>
				</tr>
				
				<tr>
				    <th>내용</th>
				    <td>
				        <textarea id="content"
				                  name="content"
				                  maxlength="400"
				                  required>${requestScope.n.content}</textarea>
				         <div class="counter-text">
                            <span id="content-curr">0</span> / 400자
                        </div>
				    </td>
				</tr>

            </table>

            <div class="button-area">

                <button type="submit"
                        class="btn-custom btn-update">
                    수정하기
                </button>

                <button type="button"
                        class="btn-custom btn-back"
                        onclick="history.back();">
                    뒤로가기
                </button>

            </div>

        </form>

    </div>

</div>

	<script>
	document.addEventListener("DOMContentLoaded", function(){

	    const titleInput = document.getElementById("noticeTitle");
	    const titleCurr = document.getElementById("title-curr");

	    const contentInput = document.getElementById("content");
	    const contentCurr = document.getElementById("content-curr");

	    function updateCounter(inputEl, counterEl, maxLength){

	        const currentLength = inputEl.value.length;

	        counterEl.textContent = currentLength;

	        if(currentLength >= maxLength){
	            counterEl.style.color = "#ef4444";
	            counterEl.style.fontWeight = "700";
	        }else{
	            counterEl.style.color = "#94a3b8";
	            counterEl.style.fontWeight = "400";
	        }
	    }

	    titleInput.addEventListener("input", function(){
	        updateCounter(titleInput, titleCurr, 15);
	    });

	    contentInput.addEventListener("input", function(){
	        updateCounter(contentInput, contentCurr, 400);
	    });

	    updateCounter(titleInput, titleCurr, 15);
	    updateCounter(contentInput, contentCurr, 400);
	});
</script>
	
	<br><br>

</body>
</html>






