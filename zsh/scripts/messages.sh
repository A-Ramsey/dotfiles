#!/usr/bin/bash

blue='\033[0;36m'
green='\033[0;32m'
red='\033[0;31m'
yellow='\033[0;33m'
orange='\033[0;35m'
clear='\033[0m'

info() {
    echo -e "ℹ️ ${blue}Info:${clear} $1"
}

success() {
    echo -e "✅ ${green}Success:${clear} $1"
}

error() {
    echo -e "❌ ${red}Error:${clear} $1"
}

warning() {
    echo -e "⚠️ ${yellow}Warning:${clear} $1"
}

question() {
    echo -en "❓ ${orange}Question:${clear} $1? "
}

case "$1" in 
    "info")
        info "$2"
        ;;
    "success")
        success "$2"
        ;;
    "error")
        error "$2"
        ;;
    "warning")
        warning "$2"
        ;;
    "question")
        question "$2"
        ;;
    *)
        echo -e "${red}Invalid message type. Use 'info', 'success', 'error', 'question', or 'warning'.${clear}"
        ;;
esac
