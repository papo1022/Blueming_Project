<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"
    uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
    .outer {
        width : 90%;
        margin : 0 auto;
    }

    #courseTitle {
        width : 80%;
        margin : 10px;
    }

    #description {
        width : 80%;
        height : 300px;
        resize : none;
    }

    #chapterTitle{
        width : 80%;
    }
</style>
</head>
<body>

    <jsp:include page="../common/mainMenubar.jsp" />

    <br><br>
    <h1 align="center">챕터 수정</h1>
    <br><br>

    <div class="outer" id="detail-area">
        <form action="updateChapter" align="center" method="post" enctype="multipart/form-data">
            <input type="hidden" name="memberId" value="${sessionScope.loginUser.memberId}"><br>
            <input type="hidden" name="chapterId" value="${ch.chapterId}">
            <table class="table">
                <tr>
                    <td>챕터 번호</td>
                    <td><input type="number" name="chapterOrder" value="${ch.chapterOrder}" required readonly ></td>
                </tr>
                <tr>
                    <td>* 챕터명 </td>
                    <td><input type="text" name="chapterTitle" id="chapterTitle" value="${ch.chapterTitle}" required></td>
                </tr>
                <tr>
                    <td>현재 업로드된 영상</td>
                    <td>
                    <c:choose>
                        <c:when test="${ch.videoFileId > 0}">
                            ${ch.originalName}
                        </c:when>
                        <c:otherwise>
                            업로드된 파일이 없습니다.
                        </c:otherwise>
                    </c:choose>
                    </td>
                <tr>
                    <td>동영상 첨부파일</td>
                    <td><input type="file" accept="video/*" name="video"><input type="checkbox" name="deleteVideo" value="Y">기존 영상 삭제</td>
                </tr>
                <tr>
                    <label style="color: red;">
                        주의! 기존 영상 삭제를 선택한 경우 파일을 업로드 해도
                        기존 영상이 삭제되고 새로 업로드한 영상이 등록되지 않습니다.
                    </label>
                </tr>
            </table>
            <br><br> 
            <div class="buttons" align="center">
                <button type="submit" class="btn btn-primary">수정하기</button>
                <button type="reset" class="btn btn-warning">초기화</button>
            </div>
        </form>
    </div>
<script>
    const deleteVideoCheckbox = document.querySelector('input[name="deleteVideo"]');
    const videoFileInput = document.querySelector('input[name="video"]');

    deleteVideoCheckbox.addEventListener('change', function() {
        if (this.checked) {
            videoFileInput.disabled = true;
        } else {
            videoFileInput.disabled = false;
        }
    });
</script>
    
</body>
</html>