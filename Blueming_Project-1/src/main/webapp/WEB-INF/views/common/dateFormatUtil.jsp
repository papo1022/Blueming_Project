<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
    if (typeof window.formatDateOnlyKst !== "function") {
        window.formatDateOnlyKst = function(value) {
            if (!value) return "";

            const str = String(value);

            if (/^\d{4}-\d{2}-\d{2}$/.test(str)) {
                return str;
            }

            const date = new Date(str);
            if (!Number.isNaN(date.getTime())) {
                return new Intl.DateTimeFormat("sv-SE", {
                    timeZone: "Asia/Seoul",
                    year: "numeric",
                    month: "2-digit",
                    day: "2-digit"
                }).format(date);
            }

            return str;
        };
    }
</script>