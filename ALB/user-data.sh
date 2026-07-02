#!/bin/bash
# 모든 출력을 로그 파일로 리다이렉션하여 디버깅 가능하게 함
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "Start UserData Script..."

# Raw 링크를 통해 스크립트 다운로드
# curl -o /tmp/setup.sh https://raw.githubusercontent.com/사용자/레포지토리/브랜치/setup.sh
curl -o /tmp/init.sh https://raw.githubusercontent.com/csjin21c/aws/main/alb/init.sh

# 실행
chmod +x /tmp/init.sh
/tmp/init.sh

echo "Script Finished."