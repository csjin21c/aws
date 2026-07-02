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