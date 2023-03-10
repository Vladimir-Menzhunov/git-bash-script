#!/bin/bash

# Пример работы amend
# Создаётся новый коммит с новым message, старого коммита в истории не будет, но в базе гита он остался можем его пометить тегом
# Можем его пометить тегом

mkdir amend-commit-git

cd amend-commit-git || exit

git init
touch .gitignore
echo ".idea DS_Store merge.sh squash.sh rebase.sh" >> .gitignore
echo "============================================================"
git status
git add .gitignore
echo "============================================================"
git status
git commit -m "add .gitignore"

# Выводим лог коммитов в одну строчку
echo "============================================================"
git log --pretty=oneline

read -p "Нажмите Enter чтобы продолжить"

echo "============================================================"
git commit --amend -m "your new message"
# Выводим лог коммитов в одну строчку
git log --pretty=oneline
echo "============================================================"
git status

read -p "Нажмите Enter чтобы продолжить"

echo "All done!"