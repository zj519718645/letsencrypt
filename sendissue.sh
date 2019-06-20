#!/usr/bin/expect
set timeout 300
set COMMONPASS "!QWEasd2"

spawn "/opt/letsencrypt/getissue.sh"
expect "*assword:*"
send "$COMMONPASS"
expect "*assword:*"
send "$COMMONPASS"
expect "*assword:*"
send "$COMMONPASS"
expect "*assword:*"
send "$COMMONPASS"
expect "*assword:*"
send "$COMMONPASS"
expect eof
