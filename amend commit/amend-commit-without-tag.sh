#!/bin/bash

# Пример работы amend и возвращение к коммиту которого нет в логе
# Создаётся новый коммит с новым message, старого коммита в истории не будет, но в базе гита он остаётся
# Если прописать команду reflog можно увидеть перемещение head указателя и увидеть хеш скрытого коммита

mkdir amend-commit-without-tag-git

cd amend-commit-without-tag-git || exit

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

# смотрим reflog
git reflog

# Создаём ветку old_master по тегу
# И возвращаемся к потерянному коммиту
# git checkout -b old_main <commit-hash>
# Выводим лог коммитов в одну строчку
# git log --pretty=oneline
# echo "============================================================"
# git status

echo "All done!"