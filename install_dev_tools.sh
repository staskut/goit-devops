#!/bin/bash

set -e

is_installed() {
    command -v "$1" >/dev/null 2>&1
}

echo "Перевірка та встановлення Docker..."
if is_installed docker; then
    echo "Docker вже встановлено."
else
    echo "Встановлюємо Docker..."
    sudo apt-get update
    sudo apt-get install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    echo "Docker встановлено."
fi

echo "Перевірка Docker Compose..."
if docker compose version >/dev/null 2>&1; then
    echo "Docker Compose вже встановлено."
else
    echo "Docker Compose не знайдено окремо (можливо, інтегровано як плагін)."
fi

echo "Перевірка Python ≥3.9..."
PYTHON_VERSION=$(python3 --version 2>/dev/null | awk '{print $2}' || echo "0")
if [[ $(printf '%s\n' "3.9" "$PYTHON_VERSION" | sort -V | head -n1) == "3.9" ]]; then
    echo "Python $PYTHON_VERSION вже встановлено."
else
    echo "Встановлюємо Python 3.9..."
    sudo apt-get update
    sudo apt-get install -y python3.9 python3.9-venv python3.9-distutils
    sudo ln -sf /usr/bin/python3.9 /usr/bin/python3
    echo "Python 3.9 встановлено."
fi

echo "Перевірка pip..."
if is_installed pip3; then
    echo "pip вже встановлено."
else
    echo "Встановлюємо pip..."
    curl -sS https://bootstrap.pypa.io/get-pip.py | sudo python3
    echo "pip встановлено."
fi

echo "🔍 Перевірка Django..."
if python3 -m django --version >/dev/null 2>&1; then
    echo "Django вже встановлено."
else
    echo "Встановлюємо Django..."
    pip3 install --user Django
    echo "Django встановлено."
fi

echo "Установка завершена успішно!"