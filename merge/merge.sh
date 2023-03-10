#!/bin/bash

# Демонстрация истории коммитов при обновлении рабочей ветки через merge

# Создаётся репозиторий merge-git с коммитом включающим .gitignore
# Последовательно создаётся 10 веток и в каждой по 5 коммитов
# К каждой ветке подмерживается мастер, создаётся commit после merge commit и ветка сливается в мастера

mkdir merge-git

cd merge-git || exit

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
  git merge branch_${i} -m "merge branch_${i}"
done

echo "All done!"