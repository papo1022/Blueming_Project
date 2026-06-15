<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Member Dashboard</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common/mainMenubar.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard/memberDashboard.css">
</head>
<body>

    <%-- 공통 메뉴바 (sidebar 역할) --%>
    <jsp:include page="/WEB-INF/views/common/mainMenubar.jsp" />

    <%-- MAIN WRAPPER --%>
    <div class="main-wrapper">

        <%-- LEFT COLUMN --%>
        <div class="left-col">

            <%-- 인사말 + 검색 --%>
            <div class="greeting-row">
                <div class="greeting-text">
                    <p id="greeting">안녕하세요, ${profile.name} 님!</p>
                    <p>오늘의 교육 이수율을 확인해 보세요.</p>
                </div>
                <div class="search-bar">
                    <input type="text" id="search-input" placeholder="검색할 강의를 입력해 주세요." maxlength="100"> 
                    <button type="submit" id="search-btn"><i class="fi fi-rr-search"></i></button>
	            </div>
            </div>

            <%-- 강의 목록 --%>
            <div class="section-title">강의 목록</div>
            <div class="course-grid" id="course-grid">
            
                <c:forEach var="course" items="${courseList}" varStatus="status">

                    <%-- 카드 색상: 완료=green, 마감=gray, 나머지는 순환 --%>
                    <c:choose>
					    <c:when test="${course.courseStatus == 'DONE'}">
					        <c:set var="theme" value="theme-green"/>
					    </c:when>
					    <c:when test="${course.courseStatus == 'CLOSED'}">
					        <c:set var="theme" value="theme-gray"/>
					    </c:when>
					    <c:when test="${course.dday <= 7}">
					        <c:set var="theme" value="theme-red"/>   <%-- 7일 이하: 빨강 --%>
					    </c:when>
					    <c:otherwise>
					        <c:set var="theme" value="theme-yellow"/> <%-- 여유 있음: 노랑 --%>
					    </c:otherwise>
					</c:choose>

                    <div class="course-card ${theme}" data-title="${course.courseTitle}">

                        <%-- 카드 상단: 아이콘 + 도넛 --%>
                        <div class="card-top">
                            <div class="card-icon">
                                <i class="fi fi-rs-document"></i>
                            </div>
                            <%-- 도넛 차트 --%>
                            <div class="donut-wrap">
                                <svg viewBox="0 0 58 58" style="transform: rotate(-90deg); transform-origin: center;">
								    <circle class="donut-bg" cx="29" cy="29" r="22"/>
								    <circle class="donut-fill" cx="29" cy="29" r="22"
								        stroke-dasharray="${course.progressRate * 1.382} 138.2"
								        stroke-dashoffset="0"/>
								</svg>
                                <div class="donut-label">${course.progressRate}%</div>
                            </div>
                        </div>

                        <%-- 카드 하단: 제목 + D-day --%>
                        <div class="card-title-text">${course.courseTitle}</div>
                        
                        <c:choose>
                            <c:when test="${course.courseStatus == 'DONE'}">
                                <div class="card-dday">완료</div>
                            </c:when>
                            <c:when test="${course.courseStatus == 'CLOSED'}">
                                <div class="card-dday">마감</div>
                            </c:when>
                            <c:otherwise>
                                <div class="card-dday">D-${course.dday}</div>
                            </c:otherwise>
                        </c:choose>

                    </div>
                </c:forEach>
                
            </div>

        </div><%-- /left-col --%>


        <%-- RIGHT COLUMN --%>
        <div class="right-col">

            <div class="right-col-title">내 프로필</div>

            <%-- 프로필 카드 --%>
            <div class="profile-card">
                <svg class="profile-avatar" viewBox="0 0 88 88" xmlns="http://www.w3.org/2000/svg">
				    <circle cx="44" cy="44" r="44" fill="#c4c5c6"/>
				</svg>
                <div class="profile-name">${profile.name}</div>
                <div class="profile-email">${profile.email}</div>
                <div style="font-size:14px; color:#888; margin-top:2px;">
                    ${profile.departmentName} / ${profile.positionName}
                </div>
            </div>

            <%-- 달력 (JS로 동적 렌더링) --%>
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

            <%-- 과제 목록 --%>
			<div class="assignment-section">
			    <div class="assignment-section-title">과제</div>
			    <c:forEach var="assign" items="${assignmentList}">
			        <div class="assignment-item">
			            <span>${assign.assignmentTitle}</span>
			            <c:choose>
			                <c:when test="${assign.submitStatus == 'SUBMITTED'}">
			                    <a href="${pageContext.request.contextPath}/assignment/list">
			                        <button type="button" class="btn-submit">제출</button>
			                    </a>
			                </c:when>
			                <c:otherwise>
			                    <a href="${pageContext.request.contextPath}/assignment/list">
			                        <button type="button" class="btn-unsubmit">미제출</button>
			                    </a>
			                </c:otherwise>
			            </c:choose>
			        </div>
			    </c:forEach>
			</div>

        </div><%-- /right-col --%>

    </div><%-- /main-wrapper --%>

    <%-- 달력 JS --%>
    <script>
    (function () {
        const monthEl = document.getElementById('cal-month');
        const datesEl = document.getElementById('cal-dates');
        const today   = new Date();
        
        // 현재 기준이 되는 주의 일요일을 구하기 위한 변수
        let currentWeekSunday = new Date(today.getFullYear(), today.getMonth(), today.getDate() - today.getDay());

        function render() {
            const y = currentWeekSunday.getFullYear();
            const m = currentWeekSunday.getMonth();
            monthEl.textContent = (m + 1) + '월';

            let html = '';
            
            // 일요일(0)부터 토요일(6)까지 7일간의 날짜를 반복 생성
            for (let i = 0; i < 7; i++) {
                const iterDate = new Date(currentWeekSunday.getFullYear(), currentWeekSunday.getMonth(), currentWeekSunday.getDate() + i);
                
                const d = iterDate.getDate();
                const isToday = (iterDate.getFullYear() === today.getFullYear() &&
                                 iterDate.getMonth() === today.getMonth() &&
                                 iterDate.getDate() === today.getDate());
                
                // 오늘 날짜인 경우 'today' 클래스 추가
                html += '<span class="' + (isToday ? 'today' : '') + '">' + d + '</span>';
            }
            
            datesEl.innerHTML = html;
        }

        // 이전 주 이동 (7일 차감)
        document.getElementById('cal-prev').addEventListener('click', function () {
            currentWeekSunday.setDate(currentWeekSunday.getDate() - 7);
            render();
        });
        
        // 다음 주 이동 (7일 증가)
        document.getElementById('cal-next').addEventListener('click', function () {
            currentWeekSunday.setDate(currentWeekSunday.getDate() + 7);
            render();
        });

        render();
    })();
    </script>
    
    <%-- 강의 검색창 js --%>
    <script>
	document.getElementById('search-input').addEventListener('input', function () {
	    const keyword = this.value.trim().toLowerCase();
	    const cards = document.querySelectorAll('#course-grid .course-card');
	
	    cards.forEach(function (card) {
	        const title = (card.dataset.title || '').toLowerCase();
	        card.style.display = title.includes(keyword) ? '' : 'none';
	    });
	});
	</script>

</body>
</html>
