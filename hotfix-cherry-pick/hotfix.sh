#!/bin/bash

# Пример работы с hotfix, когда в момент тестирования в ветке release/app_23.0 нашли баг!

mkdir hotfix-git

cd hotfix-git || exit

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

# Создание коммитов до релиза, работа над задачами релиза release/app_23.0
for i in {1..10}
do
  # Коммит до релиза
  touch before_release_additional_file_main_${i}.txt
  echo "This is before_release_additional_file_main_${i}.txt" >> before_release_additional_file_main_${i}.txt
  git add before_release_additional_file_main_${i}.txt
  git commit -m "Added before_release_additional_file_main_${i}.txt"
done

# Создание релизной ветки
git checkout -b release/app_23.0

echo "============================================================"
echo "Тестирование......................."
echo " "

read -p "Нажмите Enter чтобы продолжить"

# Переключение на мастер в котором продолжают работать над задачами следующего релиза
git checkout main

# Коммиты следующего релиза
for i in {1..10}
do
  # Создаётся доп коммит
  touch after_release_additional_file_main_${i}.txt
  echo "This is after_release_additional_file_main_${i}.txt" >> after_release_additional_file_main_${i}.txt
  git add after_release_additional_file_main_${i}.txt
  git commit -m "Added after_release_additional_file_main_${i}.txt"
done
echo "============================================================"
echo "Тестирование!!!!! В release/app_23.0 обнаружен баг нужно сделать hotfix"
echo " "
read -p "Нажмите Enter чтобы продолжить"

# Нужно срочно поправить баг в релизной ветке
echo "============================================================"
echo "Правим баг................"

# Ищем общий коммит между main и release/app_23.0
# shellcheck disable=SC2046
MERGE_BASE=$(git merge-base main release/app_23.0)

# Создаём новую ветку hotfix
# shellcheck disable=SC2046
git checkout -b hotfix "${MERGE_BASE}"

# Правим баг
for i in {1..10}
do
  # Создаётся доп коммит
  touch hotfix_additional_file_main_${i}.txt
  echo "This is hotfix_additional_file_main_${i}.txt" >> hotfix_additional_file_main_${i}.txt
  git add hotfix_additional_file_main_${i}.txt
  git commit -m "Added hotfix_additional_file_main_${i}.txt"
done
echo "============================================================"
echo "Работа над багом закончена"
echo " "

read -p "Нажмите Enter чтобы продолжить"

# Переходим на ветку release/app_23.0
git checkout release/app_23.0

# Мержим доработки hotfix
git merge hotfix -m "Hotfix merge-release/app_23.0"

echo "============================================================"
echo "Ветка release/app_23.0 в актуальном состоянии"
echo " "

read -p "Нажмите Enter чтобы продолжить"

# Переходим и обновляем main
git checkout main
git merge hotfix -m "Hotfix merge-main"

echo "============================================================"
echo "Ветка main в актуальном состоянии"
echo " "

# Мержим доработки hotfix
echo "All done!"