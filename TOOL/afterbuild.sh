#!/bin/bash

set -e

# 作業ディレクトリの指定（引数 or デフォルト）
ENTER_DIR=$1
TOOLBOX="/root/TOOL"
VENV="${TOOLBOX}/venv"

# 仮想環境の有効化
if [ -f "${VENV}/bin/activate" ]; then
    echo "Activating Python virtual environment at ${VENV}"
    source "${VENV}/bin/activate"
else
    echo "Virtual environment not found at ${VENV}"
    exit 1
fi

# 作業ディレクトリへの移動
if [[ -z "${ENTER_DIR}" ]]; then
    cd /root
elif [[ -d "${ENTER_DIR}" ]]; then
    cd "${ENTER_DIR}"
else
    echo "Not found the directry: ${ENTER_DIR}"
    cd /root
fi

echo "=========================="
echo "Show the current working directory and Python version"
echo "Current working directory: $(pwd)"
echo "Python version: $(python --version)"
echo "Virtual environment activated. Ready to work."
echo "=========================="

# 対話型シェル（ローカル開発用）
exec bash