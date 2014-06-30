## 対応OS
- ubuntu12.04
- ubuntu14.04(なぜか数回コケるがそのまま繰り返せば入る)

## OSのインストール後のchefのタスク
- cheferユーザーをパスワードなしでsudoできるように( sudo cat /etc/sudoers.d/chefer < "chefer ALL=(ALL) NOPASSWD:ALL" )
- (ssh-copy-id -i (公開鍵ファイル) (リモートマシンのアドレス) )
- ssh-keygen -t rsa
- cheferの.ssh/authorized_keysに適宜以下をはる

    ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAw51eE+J2h6TpniohD+L9WZ9KiTVzyUW5u/um6Ce5t73kqJGmURc0ANW18cI8JbRppb9yOMDZpjnsOIKj0hH8bcazptyXJfVsZNzqXO7wak/OXtdJxrR06yXU7nAzpCQ0ojnG5zyJONRInY9SXXi33ZyoAiPK3onoGINL8IMwddUlm4VEgitF/eazrer7B14OuMsp9OwYlTZkk1tqlXKJ187ipDhZFsGTpfWRzq3QiLD/agIKlI12/YFMoxFmYLrYqX4Gvo1mgklZAhh2JR42jiwFcvy1ykVsxxjiRzv1dooe19kK7VagrBibrfhfxKcx8RVgUX1N8xE9+/W3NBrUcQ== hirobanex@000-local-env

- chmod 600 ~/.ssh/authorized_keys 

- sshの設定を変更
    - scp remote_sshd_config chefer@111.111.111.111:転送して、/etc/ssh/sshd_configに移動
    - sudo service ssh restart
- 作業用のローカルユーザーの.ssh/configに設定

    Host server-name
        HostName ........
        User chefer
        Port 12345
        UserKnownHostsFile /home/$USER/.ssh/known_hosts
        StrictHostKeyChecking no
        PasswordAuthentication no
        IdentityFile "/home/$USER/.ssh/id_rsa"
        IdentitiesOnly yes

## chefの実行
- knife solo prepare <host>
- knife solo cook <host>
- knife cookbook create <recipe> -o site-cookbooks
- knife cookbook test <recipe> -o site-cookbooks 

