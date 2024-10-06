#! /bin/bash
echo KAKYOUHENSUUHENKOU
export ENV_CRON=env_cron
export AWS_ACCESS_KEY_ID=aaa
export AWS_SECRET_ACCESS_KEY=bbb
export AWS_SESSION_TOKEN=ccc

echo GETTING CREDENTIALS
output=$(/usr/local/bin/aws_signing_helper credential-process \
                     --certificate /app/api/credentials/test-user.example.com.pem \
                     --private-key /app/api/credentials/test-user.example.com-key.pem \
                     --trust-anchor-arn arn:aws:rolesanywhere:us-east-1:637423547155:trust-anchor/a1cc72e8-00ec-44d5-8a8f-e07edcffbc7c \
                     --profile-arn arn:aws:rolesanywhere:us-east-1:637423547155:profile/cc6664e2-3070-4520-9048-c0773f0b036a \
                     --role-arn arn:aws:iam::637423547155:role/test-role-iamanywhere \
                     --with-proxy)
export AWS_ACCESS_KEY_ID=$(echo $output | jq -r '.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $output | jq -r '.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $output | jq -r '.SessionToken')
echo $AWS_ACCESS_KEY_ID
echo $AWS_SECRET_ACCESS_KEY
echo $AWS_SESSION_TOKEN