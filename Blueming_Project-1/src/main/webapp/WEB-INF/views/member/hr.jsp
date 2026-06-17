<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>인사 대시보드</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard/memberDashboard.css">
<link rel="stylesheet" href="https://cdn-uicons.flaticon.com/uicons-regular-rounded/css/uicons-regular-rounded.css">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
<style>
    /* 1. 사이드바와 수평으로 완벽히 공존하기 위한 레이아웃 초기화 */
    * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Noto Sans KR', sans-serif; }
   body {
    background-color: #F8F9FA;
    min-height: 100vh;
    overflow-x: hidden;
}

    /* 메인메뉴바(사이드바) 오른쪽에 붙어 공간을 꽉 채우는 본문 컨테이너 */
    .dashboard-wrapper {
    margin-left: 260px; /* 사이드바 width랑 동일하게 */
    flex-grow: 1;
    display: flex;
    flex-direction: column;
    min-width: 0;
    background-color: #F8F9FA;
}

	.header-bar,
.dashboard-content {
    width: 100%;
}

    /* 2. [상단 바] 프로필 헤더 레이아웃 (시안 그대로 구현) */
    .header-bar { background-color: white; padding: 25px 40px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #E5E7EB; width: 100%; }
    .welcome-text h1 { font-size: 24px; color: #1F2937; font-weight: 700; }
    .welcome-text p { font-size: 13px; color: #6B7280; margin-top: 4px; }
    
    /* 검색창 영역 */
    .search-container { position: relative; width: 320px; height: 60px; padding-top : 10px;}
    .search-container input { position: absolute; width: 100%; padding: 10px 40px 10px 20px; border: 1px solid #E5E7EB; border-radius: 25px; font-size: 13px; background-color: #F9FAFB; outline: none;  box-sizing: border-box; }
    .search-container i { position: absolute; right: 15px; top: 50%; transform: translateY(-50%); color: #9CA3AF; cursor: pointer; }

    .user-profile { display: flex; align-items: center; gap: 15px; }
    .user-profile .role { font-weight: 700; color: #1F2937; font-size: 16px; }
    .user-profile .nav-links { font-size: 12px; color: #6B7280; display: flex; gap: 8px; }
    .user-profile .nav-links a { color: #6B7280; text-decoration: none; }
    .user-profile .nav-links a:hover { text-decoration: underline; }
    .user-profile .profile-img { width: 44px; height: 44px; border-radius: 50%; background-color: #E5E7EB; overflow: hidden; border: 1px solid #E5E7EB; }

    /* 3. [하단 메인 바디] 대시보드 콘텐츠 2단 분할 Grid */
    .dashboard-content {
    max-width: 1300px;
    margin: 0 auto;
    display: grid;
    grid-template-columns: 1fr 360px;
    gap: 40px;
}

    /* [좌측 영역] 강의 이수율 메인 섹션 */
    .left-section { background: white; border-radius: 16px; padding: 30px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02); }
    .section-title { font-size: 22px; color: #1F2937; font-weight: 700; margin-bottom: 25px; }
    
    /* 시안 특유의 민트/시안(Teal) 라운드 테이블 디자인 세팅 */
    .progress-table { width: 100%; border-collapse: collapse; font-size: 14px; }
    .progress-table th { background-color: #2DD4BF; color: white; font-weight: 500; padding: 14px 16px; text-align: left; border: none; }
    .progress-table th:first-child { border-top-left-radius: 12px; border-bottom-left-radius: 12px; }
    .progress-table th:last-child { border-top-right-radius: 12px; border-bottom-right-radius: 12px; }
    .progress-table td { padding: 16px; border-bottom: 1px solid #F3F4F6; color: #4B5563; }
    .progress-table tbody tr:hover { background-color: #F9FAFB; }
    
    /* 시안 속 선택 행 파란색 하이라이트 박스 효과 */
    .progress-table tbody tr.highlighted { outline: 2px solid #3B82F6; background-color: #EFF6FF; border-radius: 4px; }

    /* [우측 영역] 사이드 스택 위젯 (달력 & 공지사항) */
    .right-section { display: flex; flex-direction: column; gap: 35px; }
    .widget-card { background: white; border-radius: 20px; padding: 25px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02); }
    
    /* 4. 미니 달력 디자인 정밀화 */
    .calendar-card {
    width: 100%;

    background: #fff;
    border-radius: 20px;

    padding: 20px;

    border: 1px solid #e5e7eb;

    box-shadow: 0 2px 8px rgba(0,0,0,0.04);
}
	
	.calendar-header {
	    display: flex;
	    justify-content: space-between;
	    align-items: center;
	    padding-bottom: 10px;
	}
	
	.calendar-month {
	    font-size: 18px;
	    font-weight: bold;
	}
	
	.calendar-days-header {
	    display: grid;
	    grid-template-columns: repeat(7, 1fr);
	    text-align: center;
	    padding-top: 10px;
	    padding-bottom: 10px;
	}
	
	.calendar-dates {
	    display: grid;
	    grid-template-columns: repeat(7, 1fr);
	    font-size: 12px;
	    text-align: center;
	    justify-items: center;
	    align-items: center;
	    padding: 10px;
	    gap: 12px;
	}
	
	.calendar-dates .today {
	    background-color: #E16B60;
	    border-radius: 50%;
	    color: white;
	    display: flex;
	    justify-content: center;
	    align-items: center;
	    width: 28px;
	    height: 28px;
	}
	
	.calendar-header button {
	    background: transparent;
	    border: none;
	    cursor: pointer;
	    display: flex;
	    justify-items: center;
	    align-items: center;
	    padding: 5px;
	}
	
	.calendar-header button i {
	    font-size: 11px;
	    color: #333333;
	    transition: color 0.2s;
	}
    /* 5. 공지사항 테이블 전용 스타일 */
    .notice-widget-title { font-size: 18px; font-weight: 700; color: #1F2937; margin-bottom: 20px; }
    .notice-table th { background-color: #4B5563; font-size: 12px; padding: 10px; text-align: center; }
    .notice-table td { padding: 12px 8px; font-size: 13px; }
    .notice-table td a { color: #1F2937; text-decoration: none; font-weight: 500; display: inline-block; max-width: 130px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; vertical-align: middle; }
    .notice-table td a:hover { color: #2DD4BF; text-decoration: underline; }

    /* 정렬용 클래스 */
    .text-center { text-align: center !important; }
    .text-right { text-align: right !important; }

    /* 6. 페이징 버튼 컴포넌트 디자인 */
    .paging-area { display: flex; justify-content: center; align-items: center; margin-top: 25px; gap: 4px; }
    .paging-area a { display: inline-block; padding: 6px 12px; border: 1px solid #E5E7EB; border-radius: 6px; color: #4B5563; text-decoration: none; font-size: 13px; font-weight: 500; background: white; transition: all 0.2s; }
    .paging-area a:hover { background-color: #F3F4F6; border-color: #D1D5DB; }
    .paging-area a.active { background-color: #2DD4BF; color: white; border-color: #2DD4BF; cursor: default; }
    .paging-area a.disabled { color: #D1D5DB; background-color: #F9FAFB; border-color: #E5E7EB; cursor: not-allowed; pointer-events: none; }
</style>
</head>
<body>

<jsp:include page="../common/mainMenubar.jsp" />

<div class="dashboard-wrapper">
    
    <div class="header-bar">
        <div class="welcome-text">
            <h1>안녕하세요, ${loginUser.name} 님!</h1>
            <p>오늘의 사원 강의 이수율을 확인해 보세요.</p>
        </div>
        
        <form class="search-container" action="${pageContext.request.contextPath}/member/hr" method="get">
    <input type="text" name="keyword" placeholder="검색할 이름을 입력해 주세요."
           value="${keyword}">
    <button type="submit" style="background:none; border:none; cursor:pointer;">
        <i class="fi fi-rr-search"></i>
    </button>
</form>

        <div class="user-profile">
            <span class="role">HR팀 ${loginUser.name}</span>
            <div class="nav-links">
                <a href="myPage">마이페이지</a> | <a href="logout">로그아웃</a>
            </div>
            <div class="profile-img">
                <img src="${pageContext.request.contextPath}/resources/images/profile_dummy.png" alt="" style="width:100%; height:100%; object-fit:cover; display:block;" onerror="this.src='https://cdn-icons-png.flaticon.com/512/149/149071.png'">
            </div>
        </div>
    </div>

    <div class="dashboard-content">
        
        <div class="left-section">
            <div class="section-title">강의 이수율</div>
            <table class="progress-table">
                <thead>
                    <tr>
                        <th>이름</th>
                        <th>부서</th>
                        <th>직급</th>
                        <th>이메일</th>
                        <th>이수율</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty progressList}">
                            <tr>
                                <td colspan="5" class="text-center" style="padding:40px; color:#9CA3AF;">조회된 데이터가 없습니다.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="item" items="${progressList}">
                                <tr class="${item.name eq '최갑돌' ? 'highlighted' : ''}">
                                    <td style="font-weight: 500; color:#1F2937;">${item.name}</td>
                                   <td>
									    <c:choose>
									        <c:when test="${item.departmentName eq 'D01'}">인사팀</c:when>
									        <c:when test="${item.departmentName eq 'D02'}">개발팀</c:when>
									        <c:when test="${item.departmentName eq 'D03'}">디자인팀</c:when>
									        <c:when test="${item.departmentName eq 'D04'}">영업팀</c:when>
									        <c:when test="${item.departmentName eq 'D05'}">마케팅팀</c:when>
									        <c:when test="${item.departmentName eq 'D06'}">운영팀</c:when>
									        <c:when test="${item.departmentName eq 'D07'}">품질관리팀</c:when>
									        <c:when test="${item.departmentName eq 'D08'}">전략기획팀</c:when>
									        <c:otherwise>${item.departmentName}</c:otherwise>
									    </c:choose>
									</td>
                                    <td>
									    <c:choose>
									        <c:when test="${item.positionName eq 'P01'}">사원</c:when>
									        <c:when test="${item.positionName eq 'P02'}">주임</c:when>
									        <c:when test="${item.positionName eq 'P03'}">대리</c:when>
									        <c:when test="${item.positionName eq 'P04'}">과장</c:when>
									        <c:when test="${item.positionName eq 'P05'}">차장</c:when>
									        <c:when test="${item.positionName eq 'P06'}">부장</c:when>
									        <c:otherwise>${item.positionName}</c:otherwise>
									    </c:choose>
									</td>
                                    <td>${item.email}</td>
                                    <td style="font-weight: 700; color: #111827;">${item.progressRate}%</td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>

            <div class="paging-area">
                <c:choose>
                    <c:when test="${mpi.currentPage eq 1}">
                        <a class="disabled">&lt;</a>
                    </c:when>
                    <c:otherwise>
                        <a href="hr?mpage=${mpi.currentPage - 1}&npage=${npi.currentPage}">&lt;</a>
                    </c:otherwise>
                </c:choose>

                <c:forEach var="p" begin="${mpi.startPage}" end="${mpi.endPage}">
                    <a href="hr?mpage=${p}&npage=${npi.currentPage}" class="${p eq mpi.currentPage ? 'active' : ''}">${p}</a>
                </c:forEach>

                <c:choose>
                    <c:when test="${mpi.currentPage eq mpi.maxPage || mpi.maxPage eq 0}">
                        <a class="disabled">&gt;</a>
                    </c:when>
                    <c:otherwise>
                        <a href="hr?mpage=${mpi.currentPage + 1}&npage=${npi.currentPage}">&gt;</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="right-section">
            
            <div class="widget-card">
                <div class="calendar-card">
                    <div class="calendar-header">
                        <button id="cal-prev"><i class="fi fi-rr-angle-left"></i></button>
                        <span class="calendar-month" id="cal-month"></span>
                        <button id="cal-next"><i class="fi fi-rr-angle-right"></i></button>
                    </div>
                    <div class="calendar-days-header">
                        <span>일</span><span>월</span><span>화</span><span>수</span><span>목</span><span>금</span><span>토</span>
                    </div>
                    <div class="calendar-dates" id="cal-dates"></div>
                </div>
            </div>

            <div class="widget-card">
                <div class="notice-widget-title">최신 공지사항</div>
                <table class="progress-table notice-table">
                    <thead>
                        <tr>
                            <th class="text-center">번호</th>
                            <th>제목</th>
                            <th class="text-center">작성일</th>
                            <th class="text-right">조회수</th>
                        </tr>
                    </thead>
                    <tbody>
					    <c:choose>
					        <c:when test="${empty noticeList}">
					            <tr><td colspan="4" class="text-center" style="padding: 20px 0; color: #9CA3AF;">등록된 공지사항이 없습니다.</td></tr>
					        </c:when>
					        <c:otherwise>
					            <c:forEach var="notice" items="${noticeList}">
					                <tr>
					                    <td class="text-center" style="color: #9CA3AF;">${notice.noticeId}</td>
					                    
					                    <td>
					                        <a href="${pageContext.request.contextPath}/notice/detail/${notice.noticeId}">
					                            ${notice.noticeTitle}
					                        </a>
					                    </td>
					                    
					                    <td class="text-center" style="font-size: 11px; color: #9CA3AF;">${notice.createdDate}</td>
					                    <td class="text-right" style="font-weight: 500;">${notice.count}</td>
					                </tr>
					            </c:forEach>
					        </c:otherwise>
					    </c:choose>
					</tbody>
                </table>

                <div class="paging-area" style="margin-top: 20px;">
                    <c:choose>
                        <c:when test="${npi.currentPage eq 1}">
                            <a class="disabled" style="padding: 4px 9px; font-size: 11px;">&lt;</a>
                        </c:when>
                        <c:otherwise>
                            <a href="hr?mpage=${mpi.currentPage}&npage=${npi.currentPage - 1}" style="padding: 4px 9px; font-size: 11px;">&lt;</a>
                        </c:otherwise>
                    </c:choose>

                    <c:forEach var="p" begin="${npi.startPage}" end="${npi.endPage}">
                        <a href="hr?mpage=${mpi.currentPage}&npage=${p}" class="${p eq npi.currentPage ? 'active' : ''}" style="padding: 4px 9px; font-size: 11px;">${p}</a>
                    </c:forEach>

                    <c:choose>
                        <c:when test="${npi.currentPage eq npi.maxPage || npi.maxPage eq 0}">
                            <a class="disabled" style="padding: 4px 9px; font-size: 11px;">&gt;</a>
                        </c:when>
                        <c:otherwise>
                            <a href="hr?mpage=${mpi.currentPage}&npage=${npi.currentPage + 1}" style="padding: 4px 9px; font-size: 11px;">&gt;</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

        </div> </div> </div> <script>
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

html += '<span class="' + (isToday ? 'today' : '') + '">' + day + '</span>';
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