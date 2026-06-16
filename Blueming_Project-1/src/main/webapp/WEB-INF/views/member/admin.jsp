<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="jakarta.tags.core" %>
		<!DOCTYPE html>
		<html>

		<head>
			<meta charset="UTF-8">
			<title>Admin Dashboard</title>
			<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
			<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common/mainMenubar.css">
			<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard/adminDashboard.css">
			<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
			<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
		</head>

		<body>
			<%-- 공통 메뉴바 --%>
				<jsp:include page="/WEB-INF/views/common/mainMenubar.jsp" />

				<%-- MAIN WRAPPER --%>
					<div class="main-wrapper">

						<%-- LEFT COLUMN --%>
							<div class="left-col">

									<%-- 프로필 바 --%>
										<div class="header-bar">

											<div class="welcome-text">
												<h1>안녕하세요, 관리자님!</h1>
												<p>강의 및 공지사항을 관리할 수 있습니다.</p>
											</div>

											<div class="search-bar">
												<input type="text" id="search-input" placeholder="검색할 강의를 입력해 주세요.">
												<i class="fi fi-rr-sear	ch"></i>
											</div>

											<div class="user-profile">
												<span class="role">관리자 ${profile.name}</span>

												<div class="nav-links">
													<a href="${pageContext.request.contextPath}/member/myPage">
														마이페이지
													</a>
													|
													<a href="${pageContext.request.contextPath}/member/logout">
														로그아웃
													</a>
												</div>

												<div class="profile-img"></div>
											</div>
										</div>

										<%-- 강의 목록 --%>
											<div class="section-title">관리할 강의 목록</div>
											<div class="course-grid" id="course-grid">

												<c:forEach var="course" items="${courseList}">

													<c:choose>
														<c:when test="${course.courseStatus == 'CLOSED'}">
															<c:set var="themeClass" value="theme-gray" />
															<c:set var="iconClass" value="fi-rs-document" />
															<c:set var="ddayLabel" value="마감" />
														</c:when>
														<c:when test="${course.courseStatus == 'WAITING'}">
															<c:set var="themeClass" value="theme-yellow" />
															<c:set var="iconClass" value="fi-rr-time-check" />
															<c:set var="ddayLabel" value="예정" />
														</c:when>
														<c:when test="${course.courseStatus == 'COMPLETED'}">
															<c:set var="themeClass" value="theme-green" />
															<c:set var="iconClass" value="fi-rs-document" />
															<c:set var="ddayLabel" value="완료" />
														</c:when>
														<c:otherwise>
															<c:set var="iconClass" value="fi-rs-document" />
															<c:set var="ddayLabel" value="D-${course.DDay}" />
															<c:choose>
																<c:when test="${course.DDay <= 7}">
																	<c:set var="themeClass" value="theme-red" />
																</c:when>
																<c:otherwise>
																	<c:set var="themeClass" value="theme-yellow" />
																</c:otherwise>
															</c:choose>
														</c:otherwise>
													</c:choose>


													<div class="course-card ${themeClass}"
														data-title="${course.courseTitle}">
														<a href="${pageContext.request.contextPath}/course/updateCourseView?courseId=${course.courseId}"
															class="card-edit-btn">수정</a>
														<div class="card-top">
															<div class="card-icon"><i class="fi ${iconClass}"></i></div>
														</div>
														<div class="card-title-text">${course.courseTitle}</div>
														<div class="card-dday">${ddayLabel}</div>
														<div class="card-period">${course.startDate} ~ ${course.endDate}
														</div>
													</div>

												</c:forEach>

												<%-- 데이터 없을 때 --%>
													<c:if test="${empty courseList}">
														<p class="empty-msg">등록된 강의가 없습니다.</p>
													</c:if>

											</div><%-- /course-grid --%>

							</div><%-- /left-col --%>

								<%-- RIGHT COLUMN --%>
									<div class="right-col">

										<%-- 달력 --%>
											<div class="calendar-card">
												<div class="calendar-header">
													<button id="cal-prev"><i class="fi fi-rr-angle-left"></i></button>
													<span class="calendar-month" id="cal-month"></span>
													<button id="cal-next"><i class="fi fi-rr-angle-right"></i></button>
												</div>
												<div class="calendar-days-header">
													<span>일</span><span>월</span><span>화</span>
													<span>수</span><span>목</span><span>금</span><span>토</span>
												</div>
												<div class="calendar-dates" id="cal-dates"></div>
											</div>

											<div class="widget-card">
												<div class="notice-widget-title">
													최신 공지사항
												</div>

												<table class="notice-table">

													<thead>
														<tr>
															<th>번호</th>
															<th>제목</th>
															<th>작성일</th>
														</tr>
													</thead>

													<tbody>

														<c:forEach var="notice" items="${noticeList}">
															<tr>

																<td>${notice.noticeId}</td>

																<td>
																	<a
																		href="${pageContext.request.contextPath}/notice/detail/${notice.noticeId}">
																		${notice.noticeTitle}
																	</a>
																</td>

																<td>${notice.createdDate}</td>

															</tr>
														</c:forEach>

													</tbody>

												</table>

											</div>

									</div><%-- /main-wrapper --%>


										<%-- 달력 JS --%>
											<script>
												(function () {
													const monthEl = document.getElementById('cal-month');
													const datesEl = document.getElementById('cal-dates');
													const today = new Date();
													let cur = new Date(today.getFullYear(), today.getMonth(), 1);

													function render() {
														const y = cur.getFullYear();
														const m = cur.getMonth();
														monthEl.textContent = y + '년 ' + (m + 1) + '월';

														const firstDay = new Date(y, m, 1).getDay();
														const lastDate = new Date(y, m + 1, 0).getDate();
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
														cur.setMonth(cur.getMonth() - 1); render();
													});
													document.getElementById('cal-next').addEventListener('click', function () {
														cur.setMonth(cur.getMonth() + 1); render();
													});

													render();
												})();
											</script>

											<%-- 강의 검색 JS --%>
												<script>
													document.getElementById('search-input').addEventListener('input', function () {
														const keyword = this.value.trim().toLowerCase();
														document.querySelectorAll('#course-grid .course-card').forEach(function (card) {
															const title = (card.dataset.title || '').toLowerCase();
															card.style.display = title.includes(keyword) ? '' : 'none';
														});
													});
												</script>

		</body>

		</html>