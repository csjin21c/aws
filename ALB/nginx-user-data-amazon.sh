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

# index.html 파일 생성
sudo tee /usr/share/nginx/html/index.html<<EOF
<!doctype html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Welcome to Amazon ALB</title>
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
          방문을 환영합니다 <br />
          [HOST NAME: {{HOSTNAME}}]
        </h1>
        <p class="text-slate-500 text-sm pb-4">
          이 페이지는 AWS ALB의 부하분산을 통해 <br />
          안정적으로 호스팅되고 있습니다.
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
sudo sed -i "s|{{HOSTNAME}}|$(hostname)|g" /usr/share/nginx/html/index.html