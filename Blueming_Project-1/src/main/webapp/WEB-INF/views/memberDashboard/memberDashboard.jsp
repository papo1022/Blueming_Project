<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Member Dashboard</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/memberDashboard.css">
</head>
<body>

    <%-- 공통 메뉴바 (sidebar 역할) --%>
    <jsp:include page="/WEB-INF/views/common/menubar.jsp" />

    <%-- MAIN WRAPPER --%>
    <div class="main-wrapper">

        <%-- LEFT COLUMN --%>
        <div class="left-col">

            <%-- 인사말 + 검색 --%>
            <div class="greeting-row">
                <div class="greeting-text">
                    <h1>안녕하세요, ${profile.name} 님!</h1>
                    <p>오늘의 교육 이수율을 확인해 보세요.</p>
                </div>
                <div class="search-bar">
                    <i class="fi fi-sr-search"></i>
                    <input type="text" placeholder="강의 검색...">
                </div>
            </div>

            <%-- 강의 목록 --%>
            <div class="section-title">강의 목록</div>
            <div class="course-grid">
                <c:forEach var="course" items="${courseList}" varStatus="status">

                    <%-- 카드 색상: 완료=green, 마감=gray, 나머지는 순환 --%>
                    <c:choose>
                        <c:when test="${course.courseStatus == 'DONE'}">
                            <c:set var="theme" value="theme-green"/>
                        </c:when>
                        <c:when test="${course.courseStatus == 'CLOSED'}">
                            <c:set var="theme" value="theme-gray"/>
                        </c:when>
                        <c:when test="${status.index % 2 == 0}">
                            <c:set var="theme" value="theme-red"/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="theme" value="theme-yellow"/>
                        </c:otherwise>
                    </c:choose>

                    <div class="course-card ${theme}">

                        <%-- 카드 상단: 아이콘 + 도넛 --%>
                        <div class="card-top">
                            <div class="card-icon">
                                <i class="fi fi-sr-book-alt"></i>
                            </div>
                            <%-- 도넛 차트: stroke-dasharray = (progressRate/100) * 138.2 --%>
                            <div class="donut-wrap">
                                <svg viewBox="0 0 58 58">
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
                                <div class="card-dday">D-${course.dDay}</div>
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
				    <circle cx="44" cy="44" r="44" fill="#e8eaf0"/>
				    <circle cx="44" cy="36" r="16" fill="#c4c5c6"/>
				    <ellipse cx="44" cy="80" rx="26" ry="18" fill="#c4c5c6"/>
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
                    <button id="cal-prev">&#8249;</button>
                    <span class="calendar-month" id="cal-month"></span>
                    <button id="cal-next">&#8250;</button>
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
                                <button class="btn-submit">제출</button>
                            </c:when>
                            <c:otherwise>
                                <button class="btn-unsubmit">미제출</button>
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
        let   cur     = new Date(today.getFullYear(), today.getMonth(), 1);

        function render() {
            const y = cur.getFullYear();
            const m = cur.getMonth();
            monthEl.textContent = y + '년 ' + (m + 1) + '월';

            const firstDay  = new Date(y, m, 1).getDay();
            const lastDate  = new Date(y, m + 1, 0).getDate();
            const isThisMon = (y === today.getFullYear() && m === today.getMonth());

            let html = '';
            for (let i = 0; i < firstDay; i++) html += '<span></span>';
            for (let d = 1; d <= lastDate; d++) {
                const isToday = isThisMon && d === today.getDate();
                html += '<span class="' + (isToday ? 'today' : '') + '">' + d + '</span>';
            }
            datesEl.innerHTML = html;
        }

        document.getElementById('cal-prev').addEventListener('click', function () {
            cur.setMonth(cur.getMonth() - 1);
            render();
        });
        document.getElementById('cal-next').addEventListener('click', function () {
            cur.setMonth(cur.getMonth() + 1);
            render();
        });

        render();
    })();
    </script>

</body>
</html>
