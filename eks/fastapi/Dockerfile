# 1. 가벼운 Python 3.11 슬림 이미지 사용
FROM python:3.11-slim

# 2. 컨테이너 내 작업 디렉토리 설정
WORKDIR /code

# 3. 종속성 파일 복사 및 설치 (캐싱 효율을 위해 소스 코드보다 먼저 복사)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 4. app 디렉토리 전체를 컨테이너의 /code/app으로 복사
COPY ./app /code/app

# 5. FastAPI 실행 (포트 8000)
# 주의: app 디렉토리 안에 main.py가 있으므로 'app.main:app' 형식을 사용합니다.
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]