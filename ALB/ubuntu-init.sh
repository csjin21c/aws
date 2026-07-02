#!/bin/bash
# nginx 설치 및 데몬 등록
apt update -y
apt install nginx -y

# index.html 파일 다운로드
curl -o /var/www/html/index.html https://raw.githubusercontent.com/csjin21c/aws/main/alb/index.html

# 호스트 이름을 가져와서 파일 내 변수 치환
sudo sed -i "s/{{HOSTNAME}}/$(hostname)/g" /var/www/html/index.html

# nginx 등록 및 시작
systemctl start nginx
systemctl enable nginx

# charset 추가
cat <<EOF > /etc/nginx/conf.d/charset.conf
charset utf-8;
EOF

# 재시작
systemctl restart nginx