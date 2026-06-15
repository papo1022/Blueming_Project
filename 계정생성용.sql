-- 계정 생성
CREATE USER SEMI IDENTIFIED BY SEMI;

-- 권한 부여
GRANT CONNECT, RESOURCE TO SEMI;

INSERT INTO MEMBER (
    MEMBER_ID, LOGIN_ID, LOGIN_PWD, NAME, EMAIL, PHONE,
    ADDRESS, HIRE_DATE, STATUS, ROLE
) VALUES (
    (SELECT NVL(MAX(MEMBER_ID), 0) + 1 FROM MEMBER),
    'user01',
    '$2a$10$htzD22N9nwae8U4UmqieF.l.mUXLpKDOYT1ZtFC4ekDonjx2LFUsm',
    '테스트사원',
    'user01@test.com',
    '010-0000-0000',
    '서울시 테스트구 테스트동',
    SYSDATE,
    'Y',
    'N'
);

-- 기존 admin, hrmaster, teacher01~10 더미데이터 삭제
DELETE FROM MEMBER WHERE LOGIN_ID IN (
    'admin', 'hrmaster',
    'teacher01','teacher02','teacher03','teacher04','teacher05',
    'teacher06','teacher07','teacher08','teacher09','teacher10'
);
COMMIT;

-- 관리자(admin) 더미데이터 (비밀번호: admin)
INSERT INTO MEMBER (
    MEMBER_ID, LOGIN_ID, LOGIN_PWD, NAME, EMAIL, PHONE,
    ADDRESS, HIRE_DATE, STATUS, ROLE
) VALUES (
    (SELECT NVL(MAX(MEMBER_ID), 0) + 1 FROM MEMBER),
    'admin',
    '$2a$10$s.h1xw.q3/d7bV3amwBJLuS6BweHMbjoxvqnwTuDe82jXkJTcKom2',
    '시스템관리자',
    'admin@blueming.com',
    '010-9000-0001',
    '서울시 중구 본사 1층',
    TO_DATE('22/01/03', 'YY/MM/DD'),
    'Y',
    'A'
);

-- 강사(teacher01) 더미데이터 (비밀번호: teacher01)
INSERT INTO MEMBER (
    MEMBER_ID, LOGIN_ID, LOGIN_PWD, NAME, EMAIL, PHONE,
    ADDRESS, HIRE_DATE, STATUS, ROLE
) VALUES (
    (SELECT NVL(MAX(MEMBER_ID), 0) + 1 FROM MEMBER),
    'teacher01',
    '$2a$10$WL73VWPGvnObUpCPQxXniuujtJIv6widTaJvoPWhy8F02VCc5m07C',
    '강사01',
    'teacher01@blueming.com',
    '010-1003-2003',
    '서울시 강남구 교육센터 1호',
    TO_DATE('23/01/04', 'YY/MM/DD'),
    'Y',
    'T'
);

COMMIT;

COMMIT;