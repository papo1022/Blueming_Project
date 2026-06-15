<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>HR Dashboard</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common/mainMenubar.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard/hrDashboard.css">
</head>
<body>

    <%-- 공통 메뉴바 --%>
    <jsp:include page="/WEB-INF/views/common/mainMenubar.jsp" />

    <%-- MAIN WRAPPER --%>
    <div class="main-wrapper">

        <%-- LEFT COLUMN --%>
        <div class="left-col">

            <%-- 인사말 + 검색바 --%>
            <div class="greeting-row">
                <div class="greeting-text">
                    <p>안녕하세요, ${profile.name} 님!</p>
                    <p>오늘의 사원 강의 이수율을 확인해 보세요.</p>
                </div>
                <div class="search-bar">
                    <input type="text" id="search-input" placeholder="검색할 이름을 입력해 주세요.">
                    <i class="fi fi-rr-search"></i>
                </div>
            </div>

            <%-- 강의 이수율 테이블 --%>
            <div class="section-title">강의 이수율</div>
            <div class="rate-table-wrap">
                <table class="rate-table">
                    <thead>
                        <tr>
                            <th>이름</th>
                            <th>부서</th>
                            <th>직급</th>
                            <th>이메일</th>
                            <th>이수율</th>
                        </tr>
                    </thead>
                    <tbody id="member-tbody">
                        <c:forEach var="member" items="${hrMemberList}">
                            <tr data-name="${member.name}">
                                <td>${member.name}</td>
                                <td>${member.departmentName}</td>
                                <td>${member.positionName}</td>
                                <td>${member.email}</td>
                                <td class="rate-cell">
                                    <c:choose>
                                        <c:when test="${not empty member.avgProgressRate}">
                                            ${member.avgProgressRate}%
                                        </c:when>
                                        <c:otherwise>–</c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty hrMemberList}">
                            <tr>
                                <td colspan="5" class="empty-msg">사원 데이터가 없습니다.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

        </div><%-- /left-col --%>


        <%-- RIGHT COLUMN --%>
        <div class="right-col">
        
        	<%-- 프로필 바 --%>
			<div class="profile-bar">
			    <div class="profile-bar-name">${profile.departmentName} ${profile.name}</div>
			    <div class="profile-bar-links">
			        <a href="#">마이페이지</a>
			        <a href="#">로그아웃</a>
			    </div>
			    <svg class="profile-bar-avatar" viewBox="0 0 44 44" xmlns="http://www.w3.org/2000/svg">
			        <circle cx="22" cy="22" r="22" fill="#c4c5c6"/>
			    </svg>
			</div>

            <%-- 달력 --%>
            <div class="right-col-title"></div>
            <div class="calendar-card">
                <div class="calendar-header">
                    <button id="cal-prev"><i class="fi fi-rr-angle-left"></i></button>
                    <span class="calendar-month" id="cal-month-label"></span>
                    <button id="cal-next"><i class="fi fi-rr-angle-right"></i></button>
                </div>
                <div class="calendar-days-header">
                    <span>일</span><span>월</span><span>화</span>
                    <span>수</span><span>목</span><span>금</span><span>토</span>
                </div>
                <div class="calendar-dates" id="cal-dates"></div>
            </div>

            <%-- 공지사항 --%>
            <div class="notice-section-title">공지사항</div>
            <div class="notice-list">
                <c:forEach var="notice" items="${noticeList}">
                    <div class="notice-item">
                        <div class="notice-icon">📢</div>
                        <div class="notice-text">
                            <div class="notice-title">${notice.noticeTitle}</div>
                            <div class="notice-date">${notice.createdAt}</div>
                        </div>
                    </div>
                </c:forEach>
                <%-- 공지 데이터 없을 때 --%>
                <c:if test="${empty noticeList}">
                    <div style="color:#aaa; font-size:14px; padding: 12px 4px;">공지사항이 없습니다.</div>
                </c:if>
            </div>

        </div><%-- /right-col --%>

    </div><%-- /main-wrapper --%>


    <%-- 달력 JS --%>
    <script>
    (function () {
        const monthLabelEl = document.getElementById('cal-month-label');
        const calMonthEl   = document.getElementById('cal-month');
        const datesEl      = document.getElementById('cal-dates');
        const today        = new Date();
        let   cur          = new Date(today.getFullYear(), today.getMonth(), 1);

        function render() {
            const y = cur.getFullYear();
            const m = cur.getMonth();
            const label = y + '년 ' + (m + 1) + '월';
            monthLabelEl.textContent = label;
            if (calMonthEl) calMonthEl.textContent = label;

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

    <%-- 검색 JS (이름 기준 필터) --%>
    <script>
    document.getElementById('search-input').addEventListener('input', function () {
        const keyword = this.value.trim().toLowerCase();
        const rows = document.querySelectorAll('#member-tbody tr[data-name]');
        rows.forEach(function (row) {
            const name = (row.dataset.name || '').toLowerCase();
            row.style.display = name.includes(keyword) ? '' : 'none';
        });
    });
    </script>

</body>
</html>
