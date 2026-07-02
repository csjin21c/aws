#!/bin/bash

# 운영체제 확인 (ubuntu 또는 amzn)
OS_ID=$(grep -E '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')

echo "Detected OS: $OS_ID"

# 패키지 매니저 및 웹 루트 경로 설정
if [ "$OS_ID" == "ubuntu" ]; then
    PKG_MANAGER="apt"
    WEB_ROOT="/var/www/html"
    $PKG_MANAGER update -y
elif [ "$OS_ID" == "amzn" ]; then
    PKG_MANAGER="dnf"
    WEB_ROOT="/usr/share/nginx/html"
    $PKG_MANAGER update -y
else
    echo "지원되지 않는 운영체제입니다."
    exit 1
fi

# Nginx 설치
$PKG_MANAGER install -y nginx

# index.html 다운로드
# (참고: 기존 로직에 따라 대상 디렉토리 지정)
curl -o $WEB_ROOT/index.html https://raw.githubusercontent.com/csjin21c/aws/refs/heads/main/ALB/index.html

# 호스트 이름을 가져와서 파일 내 변수 치환
sed -i "s/{{HOSTNAME}}/$(hostname)/g" $WEB_ROOT/index.html

# charset 설정 추가
cat <<EOF > /etc/nginx/conf.d/charset.conf
charset utf-8;
EOF

# Nginx 설치 부분 수정
echo "Installing Nginx..."
$PKG_MANAGER install -y nginx

# 서비스 시작 전 설정이 올바른지 확인 (테스트)
nginx -t

# Nginx 서비스 시작 및 활성화
systemctl enable nginx
systemctl start nginx