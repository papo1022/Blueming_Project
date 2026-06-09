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
    'user01',
    '테스트사원',
    'user01@test.com',
    '010-0000-0000',
    '서울시 테스트구 테스트동',
    SYSDATE,
    'Y',
    'N'
);

COMMIT;