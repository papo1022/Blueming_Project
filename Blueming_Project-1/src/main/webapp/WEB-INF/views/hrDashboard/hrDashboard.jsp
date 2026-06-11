<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>HR Dashboard</title>
</head>
<body>
	
	<div class="container-fluid mt-4">
	    <div class="row">
	
	        <%-- 왼쪽: 인사말 + 사원 이수율 목록 --%>
	        <div class="col-md-8">
	
	            <%-- 인사말 --%>
	            <h4>안녕하세요, ${profile.name} 님!</h4>
	            <p>오늘의 사원 강의 이수율을 확인해 보세요.</p>
	
	            <%-- 사원 이수율 목록 --%>
	            <h5 class="mt-4">강의 이수율</h5>
	            <table class="table table-bordered">
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
	                    <c:forEach var="member" items="${hrMemberList}">
	                        <tr>
	                            <td>${member.name}</td>
	                            <td>${member.departmentName}</td>
	                            <td>${member.positionName}</td>
	                            <td>${member.email}</td>
	                            <td>${member.avgProgressRate}%</td>
	                        </tr>
	                    </c:forEach>
	                    <%-- 데이터 없을 때 --%>
	                    <c:if test="${empty hrMemberList}">
	                        <tr>
	                            <td colspan="5" class="text-center">사원 데이터가 없습니다.</td>
	                        </tr>
	                    </c:if>
	                </tbody>
	            </table>
	
	        </div>
	
	        <%-- 오른쪽: 달력 + 공지사항 --%>
	        <div class="col-md-4">
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
	
	        </div>
	    </div>
	</div>
	
</body>
</html>