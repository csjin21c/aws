import json
import os
import pymysql

# 1. 전역 변수 (Warm Start 시 연결 유지)
conn = None

def get_connection():
    global conn
    # 연결이 없거나 끊긴 경우에만 새로 연결
    if conn is None or not conn.open:
        conn = pymysql.connect(
            host=os.environ['DB_HOST'],
            user=os.environ['DB_USER'],
            password=os.environ['DB_PASSWORD'],
            db=os.environ['DB_NAME'],
            charset='utf8mb4', # 이모지 및 한글 깨짐 방지
            cursorclass=pymysql.cursors.DictCursor,
            connect_timeout=5
        )
    return conn

def lambda_handler(event, context):
    global conn
    
    # 2. 입력 데이터 파싱 (POST 방식 가정)
    # API Gateway 프록시 통합 시 body는 문자열로 들어옵니다.
    try:
        if event.get('body'):
            data = json.loads(event['body'])
        else:
            # 테스트를 위해 쿼리 파라미터도 허용하도록 구성
            data = event.get('queryStringParameters') or {}
    except Exception:
        data = {}

    try:
        # 3. DB 연결 및 실행
        db_conn = get_connection()
        with db_conn.cursor() as cursor:
            sql = "CALL BoardAppend(%s, %s, %s, %s, %s, %s, %s, %s, %s)"
            params = (
                data.get('p_key'), data.get('p_level'), data.get('p_step'), 
                data.get('p_userId'), data.get('p_passwd'), data.get('p_userName'), 
                data.get('p_subject'), data.get('p_content'), data.get('p_hit')
            )
            cursor.execute(sql, params)
            result = cursor.fetchone() 
            db_conn.commit()
            
            # 프로시저 결과 값 (없으면 1 반환)
            result_val = result.get('result') if result else 1

        # 4. API Gateway 표준 응답 규격
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*' # CORS 허용
            },
            'body': json.dumps({'result': result_val}, ensure_ascii=False)
        }

    except Exception as e:
        # 에러 발생 시 롤백
        if conn:
            try:
                conn.rollback()
            except:
                pass
        print(f"Error occurred: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)}, ensure_ascii=False)
        }
    # finally: conn.close()는 생략하여 연결을 유지합니다 (Warm Start)