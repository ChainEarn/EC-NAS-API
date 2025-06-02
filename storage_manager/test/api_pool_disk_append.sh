TOKEN='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NDgyNjEwMzh9.huYU-IrRaH0XpIWaQ0UfgksRBx86fUwYenoZwqwqsp4'
curl -v -0 -X POST -d '{"dev":"loop0","devtype":"IMG"}' -H "Authorization: Bearer $TOKEN" "http://127.0.0.1:8090/storageManager/v1/poolDiskAppend"
