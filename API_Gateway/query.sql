-- 1. 사용자 생성 ('%'는 모든 IP에서의 접속을 허용합니다)
CREATE USER 'student'@'%' IDENTIFIED BY 'student1234';

-- 2. 모든 데이터베이스와 테이블에 대한 모든 권한 부여
GRANT ALL PRIVILEGES ON *.* TO 'student'@'%' WITH GRANT OPTION;

-- 3. 변경 사항 즉시 적용
FLUSH PRIVILEGES;

CREATE DATABASE IF NOT EXISTS iandb;
USE iandb;

-- DROP TABLE tstudent;
CREATE TABLE IF NOT EXISTS tstudent (
	id		varchar(12)		not null	comment '교육생 Account id, 자동생성yyyymmddxxxx'
	, user			varchar(30)		not null	comment '교육생 이름'
	, password		varchar(12)		null		comment '교육생 비밀번호'
	, email			varchar(50)		not null	comment '교육생 이메일 주소'
	, major			varchar(30)		not null	comment '과정명'
	, batch			tinyint			default 1	comment '기수'
	, location		varchar(4)		not null	comment '지역'
	, primary key (id)
);

INSERT INTO tstudent (id, user, email, major, batch, location) values
('202512290001','김강환','kkhwan0822@gmail.com','MSP 솔루션 아키텍처 양성과정','6', '부산')
,('202512290002','김다정','rlaekwjd248@gmail.com','MSP 솔루션 아키텍처 양성과정','6', '부산')
,('202512290003','박소영','goster789@gmail.com','MSP 솔루션 아키텍처 양성과정','6', '부산')
,('202512290004','이경민','l01090982517r@gmail.com','MSP 솔루션 아키텍처 양성과정','6', '부산')
,('202512290005','이예찬','yeadohran@gmail.com','MSP 솔루션 아키텍처 양성과정','6', '부산')
,('202512290006','장유승','jus4612@gmail.com','MSP 솔루션 아키텍처 양성과정','6', '부산')
,('202512290007','박경민','exodusean@gmail.com','MSP 솔루션 아키텍처 양성과정','6', '부산')
,('202512290008','박세훈','pshcms77@gmail.com','MSP 솔루션 아키텍처 양성과정','6', '부산')
;

select distinct major