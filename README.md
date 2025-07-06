# CodeBuildLineForAndroid
project-root/
├── create_flet.sh              # Android/Flet環境のビルドと起動を統括するスクリプト
├── Dockerfile                  # Flet用のDockerfile（Flet_Dockerfile）
├── Android/
│   └── Dockerfile              # Android開発環境用のDockerfile（Android_Dockerfile）
├── TOOL/
│   ├── afterbuild.sh           # コンテナ起動後に仮想環境を有効化し、作業ディレクトリに移動するスクリプト
│   ├── requirement.txt         # Python仮想環境にインストールするパッケージ一覧（flet, poetry）
│   ├── .bashrc                 # ホストの.bashrcをコピーして仮想環境の自動有効化などを設定
│   └── <その他の補助スクリプト> # START_SHELLなど、初期化に使うシェルスクリプト
├── buildroom/
│   └── src/                    # ホスト側の作業ディレクトリ。コンテナ内の /home/${USER}/src にマウントされる
└── <その他の補助ファイル>