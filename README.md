# DevOps-netology

Найти commit по названию   
Посмотреть изменения commita   
```
git log --grep="Prepare to delete and move"   

git show ebdc652
```

```
git diff  
```
```
git commit -v  
```

## terraform .gitignore
1. Локальная дирректория .terraform и все её содержимое  
2. Все файлв tfstate  
3. Файл crash.log  
4. Все фалы с расширением tfvars  
5. Файлы override  
6. Фалы terraformrc и terraform.rc  
