DROP DATABASE IF EXISTS STUDY;
CREATE DATABASE IF NOT EXISTS STUDY;
USE STUDY;

DROP TABLE IF EXISTS TMEMBER;
CREATE TABLE IF NOT EXISTS TMEMBER (
    fid			varchar(12)		not null	comment '가입자 아이디',	# 수업을 위해 기본키 설정하지 않음.
    fpass		varchar(20)		not null	comment '가입자 비밀번호',
    fname		nvarchar(20)	not null	comment '가입자 이름',
    femail		varchar(50)		not null	comment '가입자 이메일 주소',
    fphone		varchar(13)		not null	comment '가입자 연락처',
    faddr1		nvarchar(30)	not null	comment '가입자 기본주소',
    faddr2		nvarchar(20)	not null	comment '가입자 상세주소',
    fbirthday	date			not null	comment '가입자 생년월일',
    fgender		set('남','여')	not null	comment '가입자 성별',
    fdate		datetime		not	null	comment '가입일'
) COMMENT='AWS RDS 서비스 테스트용 테이블';

INSERT INTO TMEMBER VALUES
('mzc-000', '1111', '김유신', 'mzc-adc@mz.co.kr', '010-1111-1111', '서울특별시 강남구 논현로', '메가존빌딩 101호', '2002-07-26',2, now()),
('mzc-111', '1111', '이순신', 'mzc-adc@mz.co.kr', '010-2222-2222', '서울특별시 강남구 강남대로', '제니스빌딩 210호', '2002-07-26',2, now()),
('mzc-333', '1111', '홍길동', 'mzc-adc@mz.co.kr', '010-3333-3333', '서울특별시 강남구 삼성로', '금정빌딩 310호', '2002-07-26',2, now()),
('mzc-444', '1111', '강감찬', 'mzc-adc@mz.co.kr', '010-4444-4444', '서울특별시 강남구 역삼동', '빅데이터빌딩 410호', '2002-07-26',2, now()),
('mzc-555', '1111', '세종', 'mzc-adc@mz.co.kr', '010-5555-5555', '서울특별시 강남구 청담동', '에이아이빌딩 510호', '2002-07-26',2, now()),
('mzc-666', '1111', '정조', 'mzc-adc@mz.co.kr', '010-6666-6666', '경기도 수원시', '아이오티빌딩 610호', '2002-07-26',2, now()),
('mzc-777', '1111', '김종신', 'mzc-adc@mz.co.kr', '010-7777-7777', '경기도 의정부시', '스마트시티빌딩 710호', '2002-07-26',2, now()),
('mzc-888', '1111', '아이유', 'mzc-adc@mz.co.kr', '010-8888-8888', '경기도 안양시', '클라우드빌딩 810호', '2002-07-26',2, now()),
('mzc-999', '1111', '안중근', 'mzc-adc@mz.co.kr', '010-9999-9999', '경기도 군포시', '그램빌딩 210호', '2002-07-26',2, now()),
('adc-tot', '2222', '애쓴이', 'adc-tot@megazone.com', '010-0000-0000', '경기도 화성시', '메가존빌딩 2층', '2004-05-21', '1', now());
SELECT * FROM TMEMBER;
##################################################################################
#	서버리스 학습을 위한 테이블로 중복데이터를 허용함alter
# ================================================================================
DROP TABLE IF EXISTS TTEST;
CREATE TABLE IF NOT EXISTS TTEST (
	fidx		int				not null	auto_increment	comment '일련번호, 자동증가',
    fid			varchar(12)		not null	comment '가입자 아이디',
    fkor		smallint		not null	default 0	comment '국어점수',
    feng		smallint		not null	default 0	comment '영어점수',
    fmat		smallint		not null	default 0	comment '수학점수',
    fdate		datetime		not	null	comment '성적입력일',
    primary key (fidx)
#    FOREIGN KEY (fid) REFERENCES tmember (fid) : 수업을 위한 관계설정 하지 않음.
) COMMENT='수강생의 성적을 관리하기 위한 테이블';
INSERT INTO TTEST (fid, fkor, feng, fmat, fdate) VALUES
('mzc-000', '99', '88', '77',now() ),
('mzc-111', '88', '77', '60',now() );

DROP VIEW IF EXISTS VRESULT;
CREATE VIEW VRESULT
AS
	SELECT a.fid, fname, fgender, fkor, feng, fmat, (fkor+feng+fmat) ftot, round((fkor+feng+fmat)/3,1) favg, a.fdate FROM ttest a 
	LEFT JOIN tmember b ON a.fid=b.fid
	ORDER BY b.fid ASC;

SELECT * FROM VRESULT;
