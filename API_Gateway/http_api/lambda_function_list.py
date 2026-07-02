import json
import os
import pymysql  # Layer(계층) 추가 필요
# 함수 외부(Global Scope)
conn = None

def get_connection():
    global conn
    if conn is None or not conn.open:
        # 연결이 필요할 때만 환경 변수를 읽고 새로 연결합니다.
        DB_HOST = os.environ['DB_HOST']
        DB_USER = os.environ['DB_USER']
        DB_PASSWORD = os.environ['DB_PASSWORD']
        DB_NAME = os.environ['DB_NAME']
        
        conn = pymysql.connect(
            host=DB_HOST, user=DB_USER, password=DB_PASSWORD, 
            db=DB_NAME, charset='utf8', 
            cursorclass=pymysql.cursors.DictCursor
        )
    return conn

def lambda_handler(event, context):
    global conn

    query_params = event.get('queryStringParameters') or {}
    query_page = query_params.get('page', '1')
    try:
        page = int(query_page)
        if page < 1:
            page = 1
    except (ValueError, TypeError):  # 숫자가 아니거나 값이 이상하면 기본값 1로 복구
        page = 1
    
    try:
        # MySQL 연결
        conn = get_connection()
        with conn.cursor() as cursor:
            size = 10
            offset = (page - 1) * size
            cursor.execute("SELECT COUNT(*) as cnt FROM tboard")
            total_count = cursor.fetchone()['cnt']
            sql = """
                SELECT fidx, fnum, fkey, flevel, fstep, fuserName, fsubject, fhit, fregdate 
                FROM tboard 
                ORDER BY fkey DESC, fstep DESC 
                LIMIT %s OFFSET %s
            """
            cursor.execute(sql, (size, offset))
            result = cursor.fetchall()
            response_body = {
                "items": result,
                "total_count": total_count,
                "page": page,
                "size": size
            }
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'  # CORS 허용
            },
            'body': json.dumps(response_body, default=str, ensure_ascii=False)
        }
    except Exception as e:
        print(f"Error: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps({
                'message': 'Internal Server Error',
                'error': str(e)
            })
        }
    # finally:
    #     if conn:
    #         conn.close()
    
    
