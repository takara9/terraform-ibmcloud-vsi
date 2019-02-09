
キーの生成

ssh-keygen -t rsa -f ./keys/key -N ''



キーの登録と確認

bx sl security sshkey-add tf -f keys/key.pub  --note 'test'
bx sl security sshkey-list

