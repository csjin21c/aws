# 1. 베이스 이미지로 공식 Nginx 최신 버전 사용
FROM nginx:1.29.7-alpine

# 2. 로컬의 html 폴더 내용을 컨테이너의 nginx 기본 정적 파일 경로로 복사
# Nginx의 기본 웹 루트 경로는 /usr/share/nginx/html 입니다.
RUN rm /usr/share/nginx/html/index.html
RUN rm /etc/nginx/conf.d/default.conf
COPY ./html /usr/share/nginx/html
COPY ./default.conf /etc/nginx/conf.d/default.conf

# 3. 80번 포트 개방 (Nginx 기본 포트)
EXPOSE 80

# 4. 컨테이너 실행 시 Nginx를 포그라운드에서 실행
CMD ["nginx", "-g", "daemon off;"]