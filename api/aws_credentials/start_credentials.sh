#! /bin/bash
makedir credentials

# 必要なモジュールをインストール
apt-get update && apt-get install -y --no-install-recommends cron jq nano unzip iputils-ping less wget
wget https://rolesanywhere.amazonaws.com/releases/1.0.4/X86_64/Linux/aws_signing_helper -O /usr/local/bin/aws_signing_helper
chmod 755 /usr/local/bin/aws_signing_helper


# cronの実行&ログを出力するための設定
chmod 755 /app/api/credentials/credentials.sh
echo "SHELL=/bin/bash" >> /etc/crontab
echo "0 0,12 * * * root /bin/bash -c 'source /app/api/credentials/credentials.sh' >> /var/log/cron.log 2>&1" > /etc/cron.d/credentials-cron
chmod 0644 /etc/cron.d/credentials-cron
touch /var/log/cron.log
source /app/api/credentials/credentials.sh > /app/api/credentials/credentials.log &
cron -f &

# aws cliの設定
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install &