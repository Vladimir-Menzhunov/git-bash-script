#!/bin/bash

# Пример работы amend-tag
# Создаётся новый коммит с новым message, старого коммита в истории не будет, но в базе гита он остаётся
# Если его пометить тегом, то можно быстро восстановить к нему доступ

mkdir amend-commit-tag-git

cd amend-commit-tag-git || exit

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

# Создаём важный тег
git tag -a main_imp_commit_message -m "very important commit"

# Выводим лог коммитов в одну строчку
git log --pretty=oneline
echo "============================================================"
git status

read -p "Нажмите Enter чтобы продолжить"

echo "============================================================"
git commit --amend -m "your new message"
# Выводим лог коммитов в одну строчку
git log --pretty=oneline
echo "============================================================"
git status

read -p "Нажмите Enter чтобы продолжить"

# Создаём ветку old_master по тегу
# И возвращаемся к потерянному коммиту
git checkout -b old_main main_imp_commit_message
# Выводим лог коммитов в одну строчку
git log --pretty=oneline
echo "============================================================"
git status

echo "All done!"