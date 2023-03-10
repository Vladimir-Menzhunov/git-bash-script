#!/bin/bash

# Демонстрация истории коммитов при использовании squash

# Если уже есть мерж коммиты в локальных ветках то можно импользовать merge --squash, что бы история коммитов в мастер была читой

# squash объединяет все изменения в ветке, которую хотим подмержить в 1 коммит,
# это полезно при объединении маленьких незначительных коммитов в 1 большой
# чтобы упростить историю коммитов и улучшить их читабельность

# Создаётся репозиторий squash-git с коммитом включающим .gitignore
# Последовательно создаётся 10 веток и в каждой по 5 коммитов
# К каждой ветке подмерживается мастер, создаётся commit после merge commit, все изменения в рабочих ветках схлопываются в 1 commit
# Добавляются изменения в мастер и делается commit изменений в матере

mkdir squash-git

cd squash-git || exit

git init
touch .gitignore
echo ".idea DS_Store merge.sh squash.sh rebase.sh" >> .gitignore
echo "============================================================"
git status
git add .gitignore
echo "============================================================"
git status
git commit -m "add .gitignore"

read -p "Нажмите Enter чтобы продолжить"

# Создаем 10 веток
for i in {1..10}
do
  git checkout -b branch_$i
  # Создаем 5 файлов с разными именами
  for j in {1..5}
  do
    touch file_${j}_branch_${i}.txt
    echo "This is file_${j}_branch_${i}.txt" >> file_${j}_branch_${i}.txt
    git add file_${j}_branch_${i}.txt
    git commit -m "Added file_${j}_branch_${i}.txt"
  done
done

# Мерджим ветки в мастер
for i in {1..10}
do
  # Перед мержем в текущую ветку подливается мастер
  git checkout branch_$i
  git merge main -m "merge main in branch_${i}"

  # Создаётся доп коммит
  touch file_additional_branch_${i}.txt
  echo "This is file_additional_branch_${i}.txt" >> file_additional_branch_${i}.txt
  git add file_additional_branch_${i}.txt
  git commit -m "Added file_additional_branch_${i}.txt"

  # Merge с мастер
  git checkout main
  git merge --squash branch_${i}
  git commit -m "squash branch_${i}"
done

echo "All done!"