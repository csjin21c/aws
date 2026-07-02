#!/bin/bash
# Raw 링크를 통해 스크립트 다운로드
# curl -o /tmp/setup.sh https://raw.githubusercontent.com/사용자/레포지토리/브랜치/setup.sh
curl -o /tmp/init.sh https://raw.githubusercontent.com/csjin21c/aws/main/alb/init.sh

# 실행
chmod +x /tmp/init.sh
/tmp/init.sh