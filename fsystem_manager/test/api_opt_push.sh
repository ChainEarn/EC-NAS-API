TOKEN='eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6IjQ1OTAzMjEzOS4ucXEuY29tIiwiZXhwIjoxNzQwMzA2Njg2LCJwYXNzd29yZCI6ImxvdmVAMTIzNDU2In0.JC-rmrWaQAcuZ6wzviI3bDMxVMv2bn9m7s3u8xT31JU'
curl -v -0 -X PUT -F 'path=xxxx.jpeg' -F "file=@./example.jpeg" -H "Authorization: Bearer $TOKEN" "http://127.0.0.1:8090/fsystemManager/v1/optPush"

