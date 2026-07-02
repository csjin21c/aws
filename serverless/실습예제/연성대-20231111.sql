/* #################################################################
CREATE DATABASE `db name`;					-- 데이터베이스 생성
CREATE DATABASE IF NOT EXISTS `db name`;	-- `db name`이 없다면 생성

DROP DATABASE `db name`;	-- 데이터베이스 삭제
DROP DATABASE IF EXISTS `db name`;	-- `db name`이 있다면 삭제
================================================================== */
DROP DATABASE IF EXISTS `STUDY`; -- STUDY라는 이름의 데이터베이스 삭제
CREATE DATABASE IF NOT EXISTS STUDY;

USE STUDY;	-- STUDY 데이터베이스 사용 준비

/* #################################################################
테이블 생성문
CREATE TABLE `table name` (
	`column name 1`		dataType(length)	[option	comment '컬럼설명'],
	`column name 2`		dataType(length)	[option	comment '컬럼설명'],
    :
    :
	`column name n`		dataType(length)	[option	comment '컬럼설명'],
    PRIMARY KEY (`column name `)
);
DROP TABLE `table name`;	-- 테이블 삭제
DROP TABLE IF EXISTS `table name`;	-- 테이블이 있다면 삭제
================================================================== */
DROP TABLE IF EXISTS TBOARD;
CREATE TABLE IF NOT EXISTS TDiary (
	FIDX	int			AUTO_INCREMENT,
    FDATE	date		NOT NULL,
	FDIARY	text		NOT NULL,
    PRIMARY KEY (FIDX)
) COMMENT '연성대학교 텐센트클라우드 서버리스 교육을 위한 일기장 테이블';

/* #################################################################
- 행 삽입
INSERT INTO `table name` (column1, column2, column5) value ('data1','data2','data5');
- 행 삭제
DELETE FROM `table name` WHERE `column name` 비교연산자 '비교데이터';
- 행 수정
UPDATE `table name' SET `column name`='data', `column name`='data'
[WHERE `column name` 비교연산자 '비교데이터'];
- 행 추출
SELETE `column name`, `column name`, `column name` FROM `table name'
[WHERE `column name` 비교연산자 '비교데이터'];
================================================================== */
INSERT INTO TDIARY (FDATE, FDIARY ) VALUE ('2023-11-01','첫 일기');
INSERT INTO TDIARY (FDATE, FDIARY ) VALUE ('2023-11-02','두번째 일기');
INSERT INTO TDIARY (FDATE, FDIARY ) VALUE ('2023-11-03','세번째 일기'); 
SELECT * FROM TDIARY;
DELETE FROM TDIARY;
