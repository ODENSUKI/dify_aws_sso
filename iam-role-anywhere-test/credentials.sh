#! /bin/bash
export TZ=Asia/Tokyo

# .bashrcファイルのパス
BASHRC_PATH="$HOME/.bashrc"
AWS_CONFIG_PATH="$HOME/.aws/config"

echo GETTING CREDENTIALS START TIME: $(date)
output=$(/usr/local/bin/aws_signing_helper credential-process \
                    --certificate /app/api/credentials/test-user.example.com.pem \
                    --private-key /app/api/credentials/test-user.example.com-key.pem \
                    --trust-anchor-arn arn:aws:rolesanywhere:us-east-1:637423547155:trust-anchor/a1cc72e8-00ec-44d5-8a8f-e07edcffbc7c \
                    --profile-arn arn:aws:rolesanywhere:us-east-1:637423547155:profile/cc6664e2-3070-4520-9048-c0773f0b036a \
                    --role-arn arn:aws:iam::637423547155:role/test-role-iamanywhere \
                    --with-proxy)
AWS_ACCESS_KEY_ID=$(echo $output | jq -r '.AccessKeyId')
AWS_SECRET_ACCESS_KEY=$(echo $output | jq -r '.SecretAccessKey')
AWS_SESSION_TOKEN=$(echo $output | jq -r '.SessionToken')
    # .bashrcにAWS_ACCESS_KEY_IDが存在するか確認
# if grep -q "export AWS_ACCESS_KEY_ID=" "$BASHRC_PATH"; then
#     # 存在する場合は上書き
#     sed -i "s|export AWS_ACCESS_KEY_ID=.*|export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID|g" "$BASHRC_PATH"
#     sed -i "s|export AWS_SECRET_ACCESS_KEY=.*|export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY|g" "$BASHRC_PATH"
#     sed -i "s|export AWS_SESSION_TOKEN=.*|export AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN|g" "$BASHRC_PATH"
# else
#     # 存在しない場合は新たに追加
#     echo "export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> "$BASHRC_PATH"
#     echo "export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> "$BASHRC_PATH"
#     echo "export AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN" >> "$BASHRC_PATH"
# fi

# ~/.aws/フォルダが存在しない場合は作成
if [ ! -d "$HOME/.aws" ]; then
    mkdir -p "$HOME/.aws"
fi

# ~/.aws/configに認証情報を保存
if [ -f "$AWS_CONFIG_PATH" ]; then
    # ファイルが存在する場合は上書き
    sed -i "s|aws_access_key_id = .*|aws_access_key_id = $AWS_ACCESS_KEY_ID|g" "$AWS_CONFIG_PATH"
    sed -i "s|aws_secret_access_key = .*|aws_secret_access_key = $AWS_SECRET_ACCESS_KEY|g" "$AWS_CONFIG_PATH"
    sed -i "s|aws_session_token = .*|aws_session_token = $AWS_SESSION_TOKEN|g" "$AWS_CONFIG_PATH"
    if ! grep -q "region = us-east-1" "$AWS_CONFIG_PATH"; then
        echo "region = us-east-1" >> "$AWS_CONFIG_PATH"
    fi
else
    # ファイルが存在しない場合は新たに作成
    cat > "$AWS_CONFIG_PATH" <<EOL
[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
aws_session_token = $AWS_SESSION_TOKEN
EOL
fi

# source $BASHRC_PATH
echo GETTING CREDENTIALS SUCCESS
# echo AWS_ACESS_KEY_ID: $AWS_ACCESS_KEY_ID
# echo AWS_SECRET_ACCESS_KEY: $AWS_SECRET_ACCESS_KEY
