#!/bin/bash

# Пример работы с hotfix, когда в момент тестирования в ветке release/app_23.0 нашли баг!
# А что если не искать мы не хотим искать общий коммит, а хотим создать ветку hotfix из main?
# Если потом смержить изменениния, то в релиз попадут новые задачи, которые там не нужны!

# Если вы уверены, что правки не коснуться нового кода, можно создать ветку из master и по
# окончании работ сделать cherry-pick

# cherry-pick применяет только hotfix изменения к релизной ветке release/app_23.0

mkdir hotfix-chery-pick-git

cd hotfix-chery-pick-git || exit

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

# Создаём ветку hotfix из main
git checkout -b hotfix

# Правим баг
touch hotfix_additional_file_main_${i}.txt
echo "This is hotfix_additional_file_main_${i}.txt" >> hotfix_additional_file_main_${i}.txt
git add hotfix_additional_file_main_${i}.txt
git commit -m "Added hotfix_additional_file_main_${i}.txt"

echo "============================================================"
echo "Работа над багом закончена"
echo " "

read -p "Нажмите Enter чтобы продолжить"

# запоминаем хеш коммита hotfix
HOTFIX_COMMIT=$(git rev-parse HEAD)

# Переходим main обновляем и удаляем ветку hotfix
git checkout main
git merge hotfix -m "Hotfix merge-main"

git branch -D hotfix

echo "============================================================"
echo "Ветка main в актуальном состоянии"

read -p "Нажмите Enter чтобы продолжить"

# Переходим на ветку release/app_23.0
git checkout release/app_23.0

# Делаем cherry-pick коммита в release/app_23.0
git cherry-pick "${HOTFIX_COMMIT}"

echo "============================================================"
echo "Ветка release/app_23.0 в актуальном состоянии"

# Мержим доработки hotfix
echo "All done!"