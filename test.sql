-- ============================================================
-- Blueming Project 통합 더미 데이터 (Oracle)
-- 대상: DEPARTMENT, POSITION, MEMBER, ATTACHMENT, COURSE,
--      COURSE_TARGET, ENROLLMENT, CHAPTER, CHAPTER_PROGRESS,
--      ASSIGNMENT, ASSIGNMENT_SUBMISSION, REPLY, NOTICE
-- 특징: FK 순서 보장, 상태값 다양화, 충분한 테스트 데이터량
-- ============================================================

-- ------------------------------------------------------------
-- 0) 기존 데이터 정리 (FK 역순)
-- ------------------------------------------------------------
DELETE FROM ASSIGNMENT_SUBMISSION;
DELETE FROM REPLY;
DELETE FROM NOTICE;
DELETE FROM CHAPTER_PROGRESS;
DELETE FROM CHAPTER;
DELETE FROM ASSIGNMENT;
DELETE FROM ENROLLMENT;
DELETE FROM COURSE_TARGET;
DELETE FROM COURSE;
DELETE FROM ATTACHMENT;
DELETE FROM MEMBER;
DELETE FROM DEPARTMENT;
DELETE FROM POSITION;
COMMIT;

-- ------------------------------------------------------------
-- 1) 기준 코드 테이블
-- ------------------------------------------------------------
INSERT INTO DEPARTMENT (DEPARTMENT_ID, DEPARTMENT_NAME, STATUS) VALUES ('D01', '인사팀', 'Y');
INSERT INTO DEPARTMENT (DEPARTMENT_ID, DEPARTMENT_NAME, STATUS) VALUES ('D02', '개발팀', 'Y');
INSERT INTO DEPARTMENT (DEPARTMENT_ID, DEPARTMENT_NAME, STATUS) VALUES ('D03', '디자인팀', 'Y');
INSERT INTO DEPARTMENT (DEPARTMENT_ID, DEPARTMENT_NAME, STATUS) VALUES ('D04', '영업팀', 'Y');
INSERT INTO DEPARTMENT (DEPARTMENT_ID, DEPARTMENT_NAME, STATUS) VALUES ('D05', '마케팅팀', 'Y');
INSERT INTO DEPARTMENT (DEPARTMENT_ID, DEPARTMENT_NAME, STATUS) VALUES ('D06', '운영팀', 'Y');
INSERT INTO DEPARTMENT (DEPARTMENT_ID, DEPARTMENT_NAME, STATUS) VALUES ('D07', '품질관리팀', 'Y');
INSERT INTO DEPARTMENT (DEPARTMENT_ID, DEPARTMENT_NAME, STATUS) VALUES ('D08', '전략기획팀', 'N');

INSERT INTO POSITION (POSITION_ID, POSITION_NAME, POSITION_LEVEL, STATUS) VALUES ('P01', '사원', 1, 'Y');
INSERT INTO POSITION (POSITION_ID, POSITION_NAME, POSITION_LEVEL, STATUS) VALUES ('P02', '주임', 2, 'Y');
INSERT INTO POSITION (POSITION_ID, POSITION_NAME, POSITION_LEVEL, STATUS) VALUES ('P03', '대리', 3, 'Y');
INSERT INTO POSITION (POSITION_ID, POSITION_NAME, POSITION_LEVEL, STATUS) VALUES ('P04', '과장', 4, 'Y');
INSERT INTO POSITION (POSITION_ID, POSITION_NAME, POSITION_LEVEL, STATUS) VALUES ('P05', '차장', 5, 'Y');
INSERT INTO POSITION (POSITION_ID, POSITION_NAME, POSITION_LEVEL, STATUS) VALUES ('P06', '부장', 6, 'N');

-- ------------------------------------------------------------
-- 2) 회원 데이터
-- ROLE: S(관리자), R(인사), N(일반)
-- STATUS: Y(재직), R(휴직), N(퇴사)
-- ------------------------------------------------------------
INSERT INTO MEMBER (
    MEMBER_ID, LOGIN_ID, LOGIN_PWD, NAME, EMAIL, PHONE, ADDRESS,
    HIRE_DATE, RETIRE_DATE, STATUS, DEPARTMENT_ID, POSITION_ID, ROLE, LEAVE_START_DATE, LEAVE_END_DATE
) VALUES (
    1, 'admin', '$2a$10$BKk.B4uQgWnxfZ0Nk.WZqeB3RduZsGDLlGF.iuCE8Jp.8V2UQE.Da',
    '시스템관리자', 'admin@blueming.com', '010-9000-0001', '서울시 중구 본사 1층',
    DATE '2022-01-03', NULL, 'Y', 'D01', 'P06', 'S', NULL, NULL
);

INSERT INTO MEMBER (
    MEMBER_ID, LOGIN_ID, LOGIN_PWD, NAME, EMAIL, PHONE, ADDRESS,
    HIRE_DATE, RETIRE_DATE, STATUS, DEPARTMENT_ID, POSITION_ID, ROLE, LEAVE_START_DATE, LEAVE_END_DATE
) VALUES (
    2, 'hrmaster', '$2a$10$BKk.B4uQgWnxfZ0Nk.WZqeB3RduZsGDLlGF.iuCE8Jp.8V2UQE.Da',
    '인사담당자', 'hr@blueming.com', '010-9000-0002', '서울시 중구 본사 2층',
    DATE '2022-02-01', NULL, 'Y', 'D01', 'P05', 'R', NULL, NULL
);

-- 강사/운영 담당자 10명 (3~12)
INSERT INTO MEMBER (
    MEMBER_ID, LOGIN_ID, LOGIN_PWD, NAME, EMAIL, PHONE, ADDRESS,
    HIRE_DATE, RETIRE_DATE, STATUS, DEPARTMENT_ID, POSITION_ID, ROLE, LEAVE_START_DATE, LEAVE_END_DATE
)
SELECT
    id,
    'teacher' || LPAD(id - 2, 2, '0'),
    '$2a$10$BKk.B4uQgWnxfZ0Nk.WZqeB3RduZsGDLlGF.iuCE8Jp.8V2UQE.Da',
    '강사' || LPAD(id - 2, 2, '0'),
    'teacher' || LPAD(id - 2, 2, '0') || '@blueming.com',
    '010-' || LPAD(1000 + id, 4, '0') || '-' || LPAD(2000 + id, 4, '0'),
    '서울시 강남구 교육센터 ' || TO_CHAR(id - 2) || '호',
    DATE '2023-01-01' + MOD(id, 150),
    NULL,
    'Y',
    CASE MOD(id, 4)
      WHEN 0 THEN 'D02'
      WHEN 1 THEN 'D06'
      WHEN 2 THEN 'D07'
      ELSE 'D05'
    END,
    CASE WHEN MOD(id, 3) = 0 THEN 'P04' ELSE 'P03' END,
    'N',
    NULL,
    NULL
FROM (
    SELECT LEVEL + 2 AS id FROM dual CONNECT BY LEVEL <= 10
);

-- 일반 사원 148명 (13~160)
INSERT INTO MEMBER (
    MEMBER_ID, LOGIN_ID, LOGIN_PWD, NAME, EMAIL, PHONE, ADDRESS,
    HIRE_DATE, RETIRE_DATE, STATUS, DEPARTMENT_ID, POSITION_ID, ROLE, LEAVE_START_DATE, LEAVE_END_DATE
)
SELECT
    id,
    'user' || LPAD(id, 4, '0'),
    '$2a$10$BKk.B4uQgWnxfZ0Nk.WZqeB3RduZsGDLlGF.iuCE8Jp.8V2UQE.Da',
    '사원' || LPAD(id, 4, '0'),
    'user' || LPAD(id, 4, '0') || '@blueming.com',
    '010-' || LPAD(2000 + MOD(id, 7000), 4, '0') || '-' || LPAD(3000 + MOD(id * 7, 7000), 4, '0'),
    '서울시 송파구 사옥 ' || TO_CHAR(MOD(id, 30) + 1) || '길 ' || TO_CHAR(MOD(id, 90) + 1),
    DATE '2023-03-01' + MOD(id, 700),
    CASE WHEN MOD(id, 20) = 0 THEN DATE '2025-12-31' - MOD(id, 150) ELSE NULL END,
    CASE
      WHEN MOD(id, 20) = 0 THEN 'N'
      WHEN MOD(id, 13) = 0 THEN 'R'
      ELSE 'Y'
    END,
    'D' || LPAD(TO_CHAR(MOD(id, 8) + 1), 2, '0'),
    'P' || LPAD(TO_CHAR(MOD(id, 5) + 1), 2, '0'),
    'N',
        CASE
            WHEN MOD(id, 13) = 0 AND MOD(id, 20) != 0
            THEN TO_NUMBER(TO_CHAR(DATE '2026-01-01' + MOD(id, 120), 'YYYYMMDD'))
            ELSE NULL
        END,
        CASE
            WHEN MOD(id, 13) = 0 AND MOD(id, 20) != 0
            THEN TO_NUMBER(TO_CHAR(DATE '2026-01-21' + MOD(id, 120), 'YYYYMMDD'))
            ELSE NULL
        END
FROM (
    SELECT LEVEL + 12 AS id FROM dual CONNECT BY LEVEL <= 148
);

-- 휴직(R) 인원은 휴직 시작/종료일을 반드시 보유하도록 보정
UPDATE MEMBER
   SET LEAVE_START_DATE = NVL(LEAVE_START_DATE,
                              TO_NUMBER(TO_CHAR(HIRE_DATE + 180, 'YYYYMMDD')))
     , LEAVE_END_DATE = NVL(LEAVE_END_DATE,
                            TO_NUMBER(TO_CHAR(HIRE_DATE + 210, 'YYYYMMDD')))
 WHERE STATUS = 'R';

-- ------------------------------------------------------------
-- 3) 첨부파일 300건
-- ------------------------------------------------------------
INSERT INTO ATTACHMENT (
    FILE_ID, ORIGINAL_NAME, CHANGED_NAME, FILE_PATH, FILE_SIZE,
    TYPE, VIDEO_DURATION, MEMBER_ID, STATUS, UPLOAD_DATE
)
SELECT
    id,
    'sample_' || id ||
      CASE MOD(id, 4)
        WHEN 0 THEN '.mp4'
        WHEN 1 THEN '.pdf'
        WHEN 2 THEN '.png'
        ELSE '.txt'
      END,
    '20260528_' || LPAD(id, 5, '0') || '_' ||
      CASE MOD(id, 4)
        WHEN 0 THEN 'video.mp4'
        WHEN 1 THEN 'doc.pdf'
        WHEN 2 THEN 'img.png'
        ELSE 'note.txt'
      END,
    '/upload/blueming/' || TO_CHAR(MOD(id, 12) + 1) || '/',
    1024 + (id * 37),
    CASE MOD(id, 4)
      WHEN 0 THEN 'mp4'
      WHEN 1 THEN 'pdf'
      WHEN 2 THEN 'png'
      ELSE 'txt'
    END,
    CASE WHEN MOD(id, 4) = 0 THEN 300 + MOD(id * 23, 5400) ELSE NULL END,
    MOD(id, 160) + 1,
    CASE WHEN MOD(id, 25) = 0 THEN 'N' ELSE 'Y' END,
    SYSDATE - MOD(id, 180)
FROM (
    SELECT LEVEL AS id FROM dual CONNECT BY LEVEL <= 300
);

-- ------------------------------------------------------------
-- 4) 강의 80건
-- ------------------------------------------------------------
INSERT INTO COURSE (
    COURSE_ID, COURSE_TITLE, DESCRIPTION, MEMBER_ID, STATUS,
    START_DATE, END_DATE, TOTAL_HOURS, FILE_ID, CREATE_DATE, UPDATED_DATE
)
SELECT
    id,
    '강의 ' || LPAD(id, 3, '0') || ' - 실무 역량 과정',
    '강의 설명 ' || id || ' : 실습 중심 커리큘럼',
    MOD(id, 10) + 3,
    CASE MOD(id, 3)
      WHEN 0 THEN 'W'
      WHEN 1 THEN 'Y'
      ELSE 'N'
    END,
    DATE '2026-01-01' + (id * 3),
    DATE '2026-01-01' + (id * 3) + 30,
    8 + MOD(id * 3, 36),
    NULL,
    SYSDATE - MOD(id, 250),
    SYSDATE - MOD(id, 120)
FROM (
    SELECT LEVEL AS id FROM dual CONNECT BY LEVEL <= 80
);

-- ------------------------------------------------------------
-- 5) 강의 대상 조건 160건
--   - 1~80: 전체 대상
--   - 81~160: 부서/직급 조건
-- ------------------------------------------------------------
INSERT INTO COURSE_TARGET (TARGET_ID, COURSE_ID, TARGET_TYPE, TARGET_VALUE)
SELECT
    'T' || LPAD(id, 4, '0') AS target_id,
    id AS course_id,
    '전체' AS target_type,
    NULL AS target_value
FROM (
    SELECT LEVEL AS id FROM dual CONNECT BY LEVEL <= 80
);

INSERT INTO COURSE_TARGET (TARGET_ID, COURSE_ID, TARGET_TYPE, TARGET_VALUE)
SELECT
    'T' || LPAD(id + 80, 4, '0') AS target_id,
    id AS course_id,
    CASE WHEN MOD(id, 2) = 0 THEN '부서' ELSE '직급' END AS target_type,
    CASE
      WHEN MOD(id, 2) = 0 THEN 'D' || LPAD(TO_CHAR(MOD(id, 8) + 1), 2, '0')
      ELSE 'P' || LPAD(TO_CHAR(MOD(id, 5) + 1), 2, '0')
    END AS target_value
FROM (
    SELECT LEVEL AS id FROM dual CONNECT BY LEVEL <= 80
);

-- ------------------------------------------------------------
-- 6) 수강 600건
-- ------------------------------------------------------------
INSERT INTO ENROLLMENT (
    ENROLLMENT_ID, MEMBER_ID, COURSE_ID, STATUS, START_DATE, COMPLETED_DATE
)
SELECT
    id,
    MOD(id, 148) + 13,
    MOD(id * 7, 80) + 1,
    CASE WHEN MOD(id, 5) = 0 THEN 'N' ELSE 'Y' END,
    DATE '2026-02-01' + MOD(id, 210),
    CASE
      WHEN MOD(id, 5) = 0 THEN DATE '2026-02-01' + MOD(id, 210) + 35
      ELSE NULL
    END
FROM (
    SELECT LEVEL AS id FROM dual CONNECT BY LEVEL <= 600
);

-- ------------------------------------------------------------
-- 7) 챕터 400건 (강의당 5개)
-- ------------------------------------------------------------
INSERT INTO CHAPTER (
    CHAPTER_ID, COURSE_ID, CHAPTER_TITLE, CHAPTER_ORDER,
    VIDEO_FILE_ID, CREATE_DATE, UPDATED_DATE
)
SELECT
    ((c.course_id - 1) * 5) + n.seq AS chapter_id,
    c.course_id,
    '강의 ' || LPAD(c.course_id, 3, '0') || ' - 챕터 ' || n.seq,
    n.seq,
    MOD(((c.course_id - 1) * 5) + n.seq, 300) + 1,
    c.create_date,
    c.updated_date
FROM COURSE c
CROSS JOIN (
    SELECT LEVEL AS seq FROM dual CONNECT BY LEVEL <= 5
) n;

-- ------------------------------------------------------------
-- 8) 챕터 이수 1,800건 (수강당 3개 챕터)
-- ------------------------------------------------------------
INSERT INTO CHAPTER_PROGRESS (
    PROGRESS_ID, ENROLLMENT_ID, CHAPTER_ID,
    WATCHED_SECONDS, LAST_POSITION_SECONDS,
    CHAP_COMP_RATE, IS_COMPLETED
)
SELECT
    ((e.enrollment_id - 1) * 3) + x.seq AS progress_id,
    e.enrollment_id,
    ((e.course_id - 1) * 5) + x.seq AS chapter_id,
    300 + MOD(e.enrollment_id * x.seq * 17, 5400) AS watched_seconds,
    60 + MOD(e.enrollment_id * x.seq * 11, 3600) AS last_position_seconds,
    CASE
      WHEN MOD(e.enrollment_id + x.seq, 5) = 0 THEN 95.00
      WHEN MOD(e.enrollment_id + x.seq, 4) = 0 THEN 82.50
      ELSE 48.00
    END AS chap_comp_rate,
    CASE WHEN MOD(e.enrollment_id + x.seq, 5) = 0 THEN 'Y' ELSE 'N' END AS is_completed
FROM ENROLLMENT e
CROSS JOIN (
    SELECT LEVEL AS seq FROM dual CONNECT BY LEVEL <= 3
) x;

-- ------------------------------------------------------------
-- 9) 과제 240건 (강의당 3개)
-- ------------------------------------------------------------
INSERT INTO ASSIGNMENT (
    ASSIGNMENT_ID, CHAPTER_ID, COURSE_ID, ASSIGNMENT_TITLE, DESCRIPTION,
    START_DATE, DUE_DATE, MAX_SCORE
)
SELECT
    ((c.course_id - 1) * 3) + n.seq AS assignment_id,
    ((c.course_id - 1) * 5) + n.seq AS chapter_id,
    c.course_id,
    '강의 ' || LPAD(c.course_id, 3, '0') || ' 과제 ' || n.seq,
    '과제 안내: 실습 결과물 제출',
    NVL(c.start_date, DATE '2026-01-01') + (n.seq - 1) * 7,
    NVL(c.start_date, DATE '2026-01-01') + (n.seq - 1) * 7 + 10,
    CASE n.seq WHEN 1 THEN 30 WHEN 2 THEN 30 ELSE 40 END
FROM COURSE c
CROSS JOIN (
    SELECT LEVEL AS seq FROM dual CONNECT BY LEVEL <= 3
) n;

-- ------------------------------------------------------------
-- 10) 과제 제출 900건
-- ------------------------------------------------------------
INSERT INTO ASSIGNMENT_SUBMISSION (
    SUBMISSION_ID, ASSIGNMENT_ID, MEMBER_ID, CONTENT, FILE_ID,
    SCORE, SUBMITTED_DATE
)
SELECT
    id,
    MOD(id * 5, 240) + 1,
    MOD(id * 11, 148) + 13,
    '과제 제출 내용 #' || id,
    CASE WHEN MOD(id, 3) = 0 THEN MOD(id, 300) + 1 ELSE NULL END,
    CASE WHEN MOD(id, 4) = 0 THEN 70 + MOD(id, 31) ELSE NULL END,
    SYSDATE - MOD(id, 90)
FROM (
    SELECT LEVEL AS id FROM dual CONNECT BY LEVEL <= 900
);

-- ------------------------------------------------------------
-- 11) 챕터 댓글 질문 700건
-- 1~450: 원댓글, 451~700: 대댓글(PARENT_REPLY_ID 참조)
-- ------------------------------------------------------------
INSERT INTO REPLY (
    REPLY_ID, CHAPTER_ID, MEMBER_ID, PARENT_REPLY_ID,
    FILE_ID, CONTENT, IS_PRIVATE, CREATED_DATE, UPDATED_DATE, STATUS
)
SELECT
    id,
    MOD(id * 3, 400) + 1,
    MOD(id * 13, 148) + 13,
    NULL,
    CASE WHEN MOD(id, 4) = 0 THEN MOD(id, 300) + 1 ELSE NULL END,
    '챕터 질문(원댓글) #' || id,
    CASE WHEN MOD(id, 5) = 0 THEN 'Y' ELSE 'N' END,
    SYSDATE - MOD(id, 90),
    SYSDATE - MOD(id, 45),
    CASE WHEN MOD(id, 19) = 0 THEN 'N' ELSE 'Y' END
FROM (
    SELECT LEVEL AS id FROM dual CONNECT BY LEVEL <= 450
);

INSERT INTO REPLY (
    REPLY_ID, CHAPTER_ID, MEMBER_ID, PARENT_REPLY_ID,
    FILE_ID, CONTENT, IS_PRIVATE, CREATED_DATE, UPDATED_DATE, STATUS
)
SELECT
    id,
    MOD(id * 3, 400) + 1,
    MOD(id * 7, 148) + 13,
    MOD(id, 450) + 1,
    CASE WHEN MOD(id, 6) = 0 THEN MOD(id, 300) + 1 ELSE NULL END,
    '챕터 질문(대댓글) #' || id,
    'N',
    SYSDATE - MOD(id, 60),
    SYSDATE - MOD(id, 20),
    'Y'
FROM (
    SELECT LEVEL + 450 AS id FROM dual CONNECT BY LEVEL <= 250
);

-- ------------------------------------------------------------
-- 13) 공지사항 120건
-- ------------------------------------------------------------
INSERT INTO NOTICE (
    NOTICE_ID, NOTICE_TITLE, CONTENT, MEMBER_ID, COUNT,
    CREATED_DATE, UPDATED_DATE, FILE_ID, STATUS
)
SELECT
    id,
    '공지사항 제목 ' || LPAD(id, 3, '0'),
    '공지사항 본문 ' || id || ' - 시스템/학습/운영 안내',
    CASE WHEN MOD(id, 10) = 0 THEN 1 ELSE 2 END,
    MOD(id * 17, 5000),
    SYSDATE - MOD(id, 140),
    SYSDATE - MOD(id, 70),
    CASE WHEN MOD(id, 3) = 0 THEN MOD(id, 300) + 1 ELSE NULL END,
    CASE WHEN MOD(id, 29) = 0 THEN 'N' ELSE 'Y' END
FROM (
    SELECT LEVEL AS id FROM dual CONNECT BY LEVEL <= 120
);

COMMIT;

-- ------------------------------------------------------------
-- 14) 검증용 건수 확인
-- ------------------------------------------------------------
SELECT 'DEPARTMENT' AS TBL, COUNT(*) AS CNT FROM DEPARTMENT
UNION ALL SELECT 'POSITION', COUNT(*) FROM POSITION
UNION ALL SELECT 'MEMBER', COUNT(*) FROM MEMBER
UNION ALL SELECT 'ATTACHMENT', COUNT(*) FROM ATTACHMENT
UNION ALL SELECT 'COURSE', COUNT(*) FROM COURSE
UNION ALL SELECT 'COURSE_TARGET', COUNT(*) FROM COURSE_TARGET
UNION ALL SELECT 'ENROLLMENT', COUNT(*) FROM ENROLLMENT
UNION ALL SELECT 'CHAPTER', COUNT(*) FROM CHAPTER
UNION ALL SELECT 'CHAPTER_PROGRESS', COUNT(*) FROM CHAPTER_PROGRESS
UNION ALL SELECT 'ASSIGNMENT', COUNT(*) FROM ASSIGNMENT
UNION ALL SELECT 'ASSIGNMENT_SUBMISSION', COUNT(*) FROM ASSIGNMENT_SUBMISSION
UNION ALL SELECT 'REPLY', COUNT(*) FROM REPLY
UNION ALL SELECT 'NOTICE', COUNT(*) FROM NOTICE
ORDER BY 1;
