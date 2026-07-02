#!/bin/bash
# nginx 설치 및 데몬 등록
dnf update -y
dnf install nginx -y
systemctl start nginx
systemctl enable nginx

# charset 추가
tee /etc/nginx/conf.d/charset.conf<<EOF
charset utf-8;
EOF

# 재시작
systemctl restart nginx