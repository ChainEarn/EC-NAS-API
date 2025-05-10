TOKEN='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NDY4NzcxMzd9.fftQB93ODFxw4PSS2y5cOubg2Wr0rF39lSLo6SuhcHk'
curl -v -0 -X POST -d '{"dev":"loop0"}' -H "Authorization: Bearer $TOKEN" "http://127.0.0.1:8090/storageManager/v1/poolDiskAppend"
