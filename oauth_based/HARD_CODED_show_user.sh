#!/bin/sh


my_token_endpoint='https://us-3.rightscale.com/api/oauth2'
my_refresh_token=''

base_uri=`echo ${my_token_endpoint} | cut -d"/" -f1,2,3`
tmpfile="./$0.tmp"

curl --include \
  -H "X-API-Version:1.5" \
  --request POST "$my_token_endpoint" \
  -d "grant_type=refresh_token" \
  -d "refresh_token=$my_refresh_token"  |
sed 's/,/\
/g' > $tmpfile

access_token=`grep "access_token" $tmpfile |
cut -d":" -f2 |
sed 's/}//g' |
sed 's/\"//g'` 

rm $tmpfile

curl --verbose --include \
     -H "X-API-Version:1.5" \
     -H "Authorization: Bearer $access_token" \
    -X GET ${base_uri}/api/users/USERID
echo ""