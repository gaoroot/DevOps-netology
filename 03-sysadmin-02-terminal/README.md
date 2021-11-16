1. Какого типа команда cd?
Это команда смены каталога `cd /home/user` переместит в каталог домашний каталог пользователя user.  
Если написать команду `cd` в отличном от домашнего каталога пользователя то она переместит в него(в домашний каталог).  
`cd ..` веруться на каталог ниже, `cd ../../` для перемещения на насколько каталогов вверх, для перехода в каталог с пробелами в имени нужно экранировать имя каталога `cd /home/user/"новая папка"`  


2. Какая альтернатива без pipe?
Находясь в домашней директории создать каталог `mkdir test`  
и перейти в него `cd test`  
создать в нём файл `touch test.txt` с содержимым  
```
cat test.txt   
123
```
вывод будет таким:  
```
vagrant@vagrant:~/test$ grep 123 test.txt | wc -l
1
```
Потом добавить в него ещё строку `123`  
То вывод изменится:   
```
vagrant@vagrant:~/test$ grep 123 test.txt | wc -l
2
```
Вывод показывает количество строк содержищий запрос `grep 123 test.txt | wc -l`  

Вывод с двумя `||` выдаст непосредственно содержимое в запросе
```
vagrant@vagrant:~/test$ grep 123 test.txt || wc -l
123

```
В запросе можно использовать '&&'  
```
vagrant@vagrant:~/test$ grep 123 test.txt && wc -l
123
123

^C
```
Но при этом терминал будет удерживаться и нужно будет нажать комбинацию клавишь `ctrl + c`   



3. Какой процесс с `PID 1` является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?  

```
vagrant@vagrant:~/test$ ps aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.5 167252 11196 ?        Ss   11:26   0:00 /sbin/init

```
```
vagrant@vagrant:~/test$ cat /proc/1/stat
1 (systemd) S 0 1 1 0 -1 4194560 11327 98180 101 398 8 47 69 133 20 0 1 0 5 171266048 2799 18446744073709551615 1 1 0 0 0 0 671173123 4096 1260 0 0 0 17 0 0 0 23 0 0 0 0 0 0 0 0 0 0

```

```
vagrant@vagrant:~/test$ ps -A  
    PID TTY          TIME CMD  
      1 ?        00:00:00 systemd  
```



`systemd` является родителем для всех процессов  
   

4. Как будет выглядеть команда, которая перенаправит вывод `stderr ls` на другую сессию терминала?  

Терминал 1

```
vagrant@vagrant:~/test$ ls % 2>&1 | tee /dev/pts/1
ls: cannot access '%': No such file or directory

```

![Терминал 1](/img/term1.png)

Терминал 2
```
vagrant@vagrant:~/test$ ls % 2>&1 | tee /dev/pts/1
ls: cannot access '%': No such file or directory

```

![Терминал 2](/img/term2.png)



5. Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл? Приведите работающий пример.  

```
vagrant@vagrant:~/test$ cat error.log 1>&1 | tee netology.txt
ls: cannot access '%': No such file or directory
ls: cannot access '%': No such file or directory
vagrant@vagrant:~/test$ cat netology.txt 
ls: cannot access '%': No such file or directory
ls: cannot access '%': No such file or directory

```

6. Получится ли находясь в графическом режиме, вывести данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?

```
ls % 2>&1 | tee /dev/tty6 
```

![pts2](/img/pts2.png)

![tty6](/img/tty6.jpg)


7. Выполните команду bash 5>&1. К чему она приведет? Что будет, если вы выполните echo netology > /proc/$$/fd/5? Почему так происходит?

В `bash` откроется файловый дескриптор `5`  
`echo netology > /proc/$$/fd/5` выведет в него `netology`  

Как пример:

Терминал 1
```
vagrant@vagrant:~/test_pts$ echo $$
1226
```
Терминал 2
```
echo "netology" > /proc/1226/fd/0
```
Терминал 1
```
vagrant@vagrant:~/test_pts$ netology
^C
```

8.  

9. Что выведет команда `cat /proc/$$/environ`? Как еще можно получить аналогичный по содержанию вывод?

Выводит содержимое переменной окружения    

подобное можно увидеть через команду `env`, `export`

Посмотреть для отдельного процесса:  
```
vagrant     1527  0.1  0.4  18908 10080 pts/1    S+   13:58   0:00 python3
cat /proc/1527/environ
```

10. 

11. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью /proc/cpuinfo.  

```
cat /proc/cpuinfo | grep sse
```
`sse` самая старшая 

P.S.:
`lshw -class processor | grep -w sse`

12. 

```
vagrant@vagrant:~/test$ ls %
ls: cannot access '%': No such file or directory
vagrant@vagrant:~/test$  ls %  2>>error.log
vagrant@vagrant:~/test$ ls
error.log  test.txt
vagrant@vagrant:~/test$ cat error.log 
ls: cannot access '%': No such file or directory
```

```
vagrant@vagrant:~/test$ ls %  &> error.log
vagrant@vagrant:~/test$ cat error.log 
ls: cannot access '%': No such file or 
```

```
vagrant@vagrant:~/test$ ls %  &>> error.log
vagrant@vagrant:~/test$ cat error.log 
ls: cannot access '%': No such file or directory
ls: cannot access '%': No such file or directory
```

