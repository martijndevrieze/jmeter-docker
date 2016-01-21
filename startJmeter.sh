#/bin/sh
ssh -R 7000:127.0.0.1:7000 dockeruser@172.17.0.20 <<EOF
cd /apache-jmeter-2.13/bin/
./jmeter-server
EOF
