#!/bin/bash
# nginx 설치 및 데몬 등록
dnf update -y
dnf install nginx python3-pip -y
systemctl start nginx
systemctl enable nginx

# charset 추가
sudo tee /etc/nginx/conf.d/charset.conf<<EOF
charset utf-8;
EOF

# 재시작
systemctl restart nginx

# index.html 파일 생성
tee /usr/share/nginx/html/index.html<<EOF
<!doctype html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Welcome to Amazon S3</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
  </head>
  <body class="bg-slate-50 flex items-center justify-center min-h-screen">
    <div
      class="bg-white p-10 rounded-3xl shadow-2xl max-w-md w-full text-center border-t-8 border-orange-400"
    >
      <div class="flex justify-center mb-6">
        <div class="bg-orange-50 p-5 rounded-2xl">
          <i data-lucide="database" class="w-16 h-16 text-orange-500"></i>
        </div>
      </div>

      <div class="space-y-3">
        <h2 class="text-sm font-bold text-orange-600 tracking-widest uppercase">
          Amazon Application Load Balancer Test Web Site
        </h2>
        <h1 class="text-2xl font-extrabold text-slate-800 leading-tight">
          AWS Nginx 정적 웹사이트 <br />
          방문을 환영합니다
        </h1>
        <p class="text-slate-500 text-sm pb-4">
          이 페이지는 AWS ALB의 부하분산을 통해 <br />
          안정적으로 호스팅되고 있습니다. <br />
          [HOST NAME: {{HOSTNAME}}]
        </p>
      </div>

      <hr class="my-6 border-slate-100" />

      <div
        class="flex items-center justify-center space-x-2 text-slate-400 text-xs"
      >
        <i data-lucide="cloud-check" class="w-4 h-4"></i>
        <span>Powered by Amazon Web Services</span>
      </div>
    </div>

    <script>
      // 아이콘 렌더링
      lucide.createIcons();
    </script>
  </body>
</html>

EOF
# 호스트 이름을 가져와서 파일 내 변수 치환
sed -i "s/{{HOSTNAME}}/$(hostname)/g" /usr/share/nginx/html/index.html
# FastAPI 및 서버 실행을 위한 Uvicorn 설치
pip install fastapi uvicorn jinja2
# nginx 등록 및 시작
systemctl enable nginx
systemctl start nginx
# 디렉토리 생성
mkdir -p /home/ec2-user/app/templates
# main.py 파일 생성
tee /home/ec2-user/app/main.py <<EOF> /dev/null
from fastapi import FastAPI, Request
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates

app = FastAPI()

# 템플릿 파일이 위치한 디렉토리 지정
templates = Jinja2Templates(directory="templates")

@app.get("/", response_class=HTMLResponse)
async def read_item(request: Request):
    # 템플릿에 전달할 데이터 정의
    welcome_msg = "안녕하세요 AWS fastAPI에 방문하여 주셔서 감사합니다."
    
    # TemplateResponse를 통해 HTML 파일과 데이터를 반환
    return templates.TemplateResponse(
        "index.html", 
        {"request": request, "message": welcome_msg}
    )
EOF
# fastAPI용 index.html 파일 생성
tee /home/ec2-user/app/templates/index.html <<EOF> /dev/null
<!DOCTYPE html>
<html>
<head>
    <title>AWS FastAPI Template</title>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #f4f7f6;
            font-family: 'Arial', sans-serif;
        }
        .card {
            text-align: center;
            padding: 50px;
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            border-top: 5px solid #05998b;
        }
        .logo { width: 120px; margin-bottom: 25px; }
        h1 { color: #333; font-size: 1.4rem; line-height: 1.6; }
    </style>
</head>
<body>
    <div class="card">
        <img src="https://fastapi.tiangolo.com/img/logo-margin/logo-teal.png" alt="FastAPI" class="logo">
        <h1>{{ message }}</h1>
    </div>
</body>
</html>
EOF
# Uvicorn을 백그라운드에서 실행을 위한 데몬 파일 생성
tee /etc/systemd/system/fastapi.service <<EOF > /dev/null
[Unit]
Description=Gunicorn instance to serve FastAPI
After=network.target

[Service]
# 인스턴스 접속 계정 (기본값 ec2-user)
User=ec2-user
Group=ec2-user
# 프로젝트 main.py가 있는 디렉토리 경로
WorkingDirectory=/home/ec2-user/app
# 실행 명령어 (절대 경로 사용 권장)
ExecStart=/usr/local/bin/uvicorn main:app --host 0.0.0.0 --port 8000
# 오류 시 자동 재시작 설정
Restart=always

[Install]
WantedBy=multi-user.target

EOF
# 1. 시스템 데몬 재로드 (새 서비스 파일 인식)
systemctl daemon-reload

# 2. 서비스 시작
systemctl start fastapi

# 3. 부팅 시 자동 시작 설정 (Enable)
systemctl enable fastapi