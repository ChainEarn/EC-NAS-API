TOKEN='eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE3NDAyMjAxNTJ9.JjBL2L1tqzS6jQMoYHn1fzEyo9yhgYItYarqw2Hqh1w'
curl -v -0 -X POST -d '{"username":"459032139@qq.com","password":"love@123456"}' -H "Authorization: Bearer $TOKEN" "http://127.0.0.1:8090/accountManager/v1/userCreate"
