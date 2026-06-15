<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MyPage</title>

<script src="//cdn.jsdelivr.net/npm/alertifyjs@1.14.0/build/alertify.min.js"></script>
<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.14.0/build/css/alertify.min.css"/>
<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.14.0/build/css/themes/default.min.css"/>
<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.14.0/build/css/themes/semantic.min.css"/>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/member/memberMyPage.css">
</head>
<body>



<div class="sidebar">
    <jsp:include page="../common/mainMenubar.jsp" />
</div>

<div class="main-layout">

  



   
    <div class="mypage-container">

        <div class="profile-card">

            <div class="profile-header"></div>

            <form id="mypage-form" action="/blueming/member/update" method="post">


                <div class="profile-top">
                    <div class="profile-image-wrap">
                        <span class="profile-image-default">👤</span>
                    </div>
                    <div class="profile-info">
                        <h2>${sessionScope.loginUser.name}</h2>
                        <span>${sessionScope.loginUser.email}</span>
                    </div>
                </div>

                <div class="info-grid">

                    <div class="info-item">
                        <span class="label-title">아이디</span>
                        <input type="text" name="loginId" readonly class="view-input"
                               maxlength="20"
                               value="${sessionScope.loginUser.loginId}">
                    </div>

                    <div class="info-item">
                        <span class="label-title">이름</span>
                        <input type="text" name="name" class="view-input"
                               maxlength="100"
                               value="${sessionScope.loginUser.name}">
                    </div>

                    <div class="info-item">
                        <span class="label-title">전화번호</span>
                        <input type="text" name="phone" class="view-input"
                               maxlength="13"
                               value="${sessionScope.loginUser.phone}">
                    </div>

                    <div class="info-item">
                        <span class="label-title">이메일</span>
                        <input type="email" name="email" class="view-input"
                               maxlength="100"
                               value="${sessionScope.loginUser.email}">
                    </div>

                    <div class="info-item full-width">
                        <span class="label-title">주소</span>
                        <input type="text" name="address" class="view-input"
                               maxlength="255"
                               value="${sessionScope.loginUser.address}">
                    </div>

                </div>

                <div class="button-area">
                    <button type="button"
                            class="btn-save"
                            data-toggle="modal"
                            data-target="#updateInfoModal">
                        정보변경
                    </button>

                    <button type="button"
                            class="btn-password"
                            data-toggle="modal"
                            data-target="#updatePwdModal">
                        비밀번호변경
                    </button>
                </div>
				
				
				
            </form>
				
        </div>
        
</div>
	<div class="right-panel">
		
        <div class="course-card">

    <h3 style="margin-bottom: 15px; font-size: 18px; font-weight: 700;">
         내 강의 목록
    </h3>

    <c:choose>

      
        <c:when test="${not empty courseList}">

            <table class="course-table">

                <thead>
                    <tr>
                        <th>강의명</th>
                        <th>설명</th>
                        <th>시작일</th>
                        <th>종료일</th>
                        <th>상태</th>
                    </tr>
                </thead>

                <tbody>
                    <c:forEach var="c" items="${courseList}">
                        <tr>
                            <td>${c.courseTitle}</td>
                            <td>${c.description}</td>
                            <td>${c.startDate}</td>
                            <td>${c.endDate}</td>
                            <td>    
                            		<c:choose>
							        <c:when test="${c.status eq 'W'}">
							            예정
							        </c:when>
							
							        <c:when test="${c.status eq 'Y'}">
							            진행중
							        </c:when>
							
							        <c:when test="${c.status eq 'N'}">
							            종료
							        </c:when>
							
							    </c:choose></td>
                        </tr>
                    </c:forEach>
                </tbody>

            </table>

        </c:when>

       
        <c:otherwise>
            <div style="padding: 20px; color: #94a3b8;">
                📭 수강 중인 강의가 없습니다.
            </div>
        </c:otherwise>

    </c:choose>
        	<div class="paging-area">

    <c:if test="${pi.currentPage > 1}">
        <a href="myPage?cpage=${pi.currentPage-1}">
            &lt;
        </a>
    </c:if>

    <c:forEach var="p"
               begin="${pi.startPage}"
               end="${pi.endPage}">

        <c:choose>

            <c:when test="${p eq pi.currentPage}">
                <strong>${p}</strong>
            </c:when>

            <c:otherwise>
                <a href="myPage?cpage=${p}">
                    ${p}
                </a>
            </c:otherwise>

        </c:choose>

    </c:forEach>

    <c:if test="${pi.currentPage < pi.maxPage}">
        <a href="myPage?cpage=${pi.currentPage+1}">
            &gt;
        </a>
    </c:if>

</div>
    </div>

            <div class="calendar-card">
                <div class="calendar-header">
                    <button id="cal-prev">
                    	<i class="fi fi-rr-angle-left"></i>
					</button>
					
                    <span class="calendar-month" id="cal-month"></span>
                    
                    <button id="cal-next">
                    	<i class="fi fi-rr-angle-right"></i>
                    </button>
                </div>
                <div class="calendar-days-header">
                    <span>일</span><span>월</span><span>화</span>
                    <span>수</span><span>목</span><span>금</span><span>토</span>
                </div>
                <div class="calendar-dates" id="cal-dates"></div>
            </div>


</div>
</div>

<div class="modal fade" id="updateInfoModal">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title">정보 변경 확인</h5>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>

            <div class="modal-body text-center">
                입력한 정보로 변경하시겠습니까?
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">
                    취소
                </button>
                <button type="button" class="btn btn-primary" onclick="submitInfo();">
                    확인
                </button>
            </div>

        </div>
    </div>
</div>

<script>
function submitInfo() {
    document.getElementById("mypage-form").submit();
}
</script>


<div class="modal fade" id="updatePwdModal">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title">비밀번호 변경</h5>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>

            <div class="modal-body">

                <form id="updatePwdFrm" action="/blueming/member/updatePwd" method="post">

                    <input type="hidden" name="loginId" value="${sessionScope.loginUser.loginId}">

                    <table class="modal-table">
                        <tr>
                            <th>현재 비밀번호</th>
                            <td>
                                <input type="password" name="loginPwd" maxlength="20" required>
                            </td>
                        </tr>
                        <tr>
                            <th>변경 비밀번호</th>
                            <td>
                                <input type="password" name="updatePwd" maxlength="20" required>
                            </td>
                        </tr>
                        <tr>
                            <th>비밀번호 확인</th>
                            <td>
                                <input type="password" name="checkPwd" maxlength="20" required>
                            </td>
                        </tr>
                    </table>

                    <br>

                    <div align="center">
                        <button type="button" class="btn btn-info btn-sm px-4" onclick="validatePwd();">
                            비밀번호 변경
                        </button>
                    </div>

                </form>

            </div>

        </div>
    </div>
</div>


<script>
function validatePwd() {
    let updatePwd = $("input[name=updatePwd]").val();
    let checkPwd = $("input[name=checkPwd]").val();

    if(updatePwd != checkPwd) {
        alertify.alert("알림", "비밀번호가 일치하지 않습니다.");
        return false;
    }

    alertify.confirm(
        "비밀번호 변경",
        "정말 비밀번호를 변경하시겠습니까?",
        function() {
            $("#updatePwdFrm").submit();
        },
        function() {
            alertify.error("취소되었습니다.");
        }
    );

    return false;
}
</script>

	

          
<script>
(function () {
    const monthEl = document.getElementById('cal-month');
    const datesEl = document.getElementById('cal-dates');

    let currentDate = new Date();

    function render() {

        const year = currentDate.getFullYear();
        const month = currentDate.getMonth();

        monthEl.textContent = year + "년 " + (month + 1) + "월";

        const firstDay = new Date(year, month, 1).getDay();
        const lastDate = new Date(year, month + 1, 0).getDate();

        const today = new Date();

        let html = '';

        // 앞 빈칸
        for(let i = 0; i < firstDay; i++){
            html += '<span class="empty"></span>';
        }

        // 날짜 출력
        for(let day = 1; day <= lastDate; day++){

            const isToday =
                today.getFullYear() === year &&
                today.getMonth() === month &&
                today.getDate() === day;

            html +=
                '<span class="' +
                (isToday ? 'today' : '') +
                '">' +
                day +
                '</span>';
        }

        datesEl.innerHTML = html;
    }

    document.getElementById('cal-prev').addEventListener('click', function () {
        currentDate.setMonth(currentDate.getMonth() - 1);
        render();
    });

    document.getElementById('cal-next').addEventListener('click', function () {
        currentDate.setMonth(currentDate.getMonth() + 1);
        render();
    });

    render();
})();
</script>


</body>
</html>