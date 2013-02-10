Goal: embedded <The Core iOS 6 Developer¡¯s Cookbook> in iOS Web Client
1, Google books api - https://developers.google.com/books/?hl=zh-CN
Developer guide - https://developers.google.com/books/docs/viewer/developers_guide
View API - https://developers.google.com/books/docs/viewer/reference?hl=de

2, Seeing sample - 00_code_conversion.html
curl [get]: http://stackoverflow.com/questions/4101742/how-can-i-make-a-request-with-both-get-and-post-parameters
get 
--> curl -G -d "key=val" "http://yadayadayada"
post
--> curl -d "key=val" "http://yadayadayada"
    curl -F "key=val" "http://yadayadayada"
    
api test - https://www.googleapis.com/books/v1/volumes?q=iOS6+Core+Developer+Cookbook&key=yourAPIKey

curl -G -d "q=iOS6+Core+Developer+Cookbook&key=AIzaSyC4ayZgs9myy7d9JhI10qTnn1H_fJZ-8Z4" "https://www.googleapis.com/books/v1/volumes"

https://www.googleapis.com/books/v1/volumes?q=search+terms

https://www.googleapis.com/books/v1/volumes?q=iOS6+Core+Developer+Cookbook&key=AIzaSyC4ayZgs9myy7d9JhI10qTnn1H_fJZ-8Z4
in Safari