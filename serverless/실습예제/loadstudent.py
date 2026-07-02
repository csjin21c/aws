import json
import pymysql

def lambda_handler(event, context):
    # TODO implement
    conn = pymysql.connect(
        host="mysql-1.c844rz2p4hli.ap-northeast-2.rds.amazonaws.com",
        user="ian",
        password="ian0213!",
        database="ian"
    )
    sql="SELECT * FROM VRESULT"
    curs=conn.cursor(pymysql.cursors.DictCursor)
    curs.execute(sql)
    rows=curs.fetchall()
    return {
        'statusCode': 200,
        'headers': { 
            'Content-Type': 'application/json' ,
            'Access-Control-Allow-Origin': '*'
        },
        'body': json.dumps(rows, default=str, indent=2)
    }
    
    
    
    
    
    
    
    환경변수 로드 : os.