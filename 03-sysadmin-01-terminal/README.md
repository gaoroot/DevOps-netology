<<<<<<< HEAD
1. Vagrantfile

```
 Vagrant.configure("2") do |config|
 	config.vm.box = "bento/ubuntu-20.04"
 end
```

![Vagrantfile.](./img/vagrantfile.png)


2. Какой переменной можно задать длину журнала `history`, и на какой строчке manual это описывается?

```
Manual page bash(1) line 835/4459 20%
```
![vistsize.](./img/histsize.png)


3. Что делает директива `ignoreboth` в bash?

```
ignoredups - Отключает вывод одинаковых команд
ignorespace - Игнорирует команды начинающиеся с пробела.
ignoreboth - Используется для установки обоих изнчений(ignoredups и ignorespace)

```
Описано в man bash `HISTCONTROL`:
![HISTCONTROL.](./img/HISTCONTROL.png)


4. В каких сценариях использования применимы скобки `{}` и на какой строчке `man bash` это описано?

Описано в man bash `RESERVED WORDS`:
![RESERVED WORDS.](./img/RESERVED_WORDS.png)


5. С учётом ответа на предыдущий вопрос, как создать однократным вызовом `touch` 100000 файлов? Получится ли аналогичным образом создать 300000? Если нет, то почему?

`touch {1..100000}.txt`

![touch.](./img/touch.png)

```
touch {1..300000}.txt
-bash: /usr/bin/touch: Argument list too long
```
Выводится сообщение `Argument list too long` из за того что файлов больше чем допустимый лимит, проверить который можно командой
```
getconf ARG_MAX
2097152
```
Удалить фалы командой `rm` болше числа `2097152` не получится


6. В man bash поищите по `/\[\[`. Что делает конструкция `[[ -d /tmp ]]`

=======
1. Vagrantfile

```
 Vagrant.configure("2") do |config|
 	config.vm.box = "bento/ubuntu-20.04"
 end
```

![Vagrantfile.](./img/vagrantfile.png)


2. Какие ресурсы выделены по-умолчанию?

Оперативная память: 1024 МБ   
Процессоры: 2  
  

3. Как добавить оперативной памяти или ресурсов процессора виртуальной машине?

добавить оперативной пямяти и процессоров: 
```
v.memory = 2048
v.cpus = 4
```
      
`Vagrantfile`: 

```
Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"
    config.vm.provider "virtualbox" do |v|
      v.memory = 2048
      v.cpus = 4
  end
end
```

4.Какой переменной можно задать длину журнала `history`, и на какой строчке manual это описывается?

```
Manual page bash(1) line 835/4459 20%
```
Отредактировать значение переменных в `.bashrc`
```
HISTSIZE=20000
HISTFILESIZE=200000
```

![vistsize.](./img/histsize.png)


   
5. Что делает директива `ignoreboth` в bash?

```
ignoredups - Отключает вывод одинаковых команд
ignorespace - Игнорирует команды начинающиеся с пробела.
ignoreboth - Используется для установки обоих изнчений(ignoredups и ignorespace)

```
Описано в man bash `HISTCONTROL`:
![HISTCONTROL.](./img/HISTCONTROL.png)


6. В каких сценариях использования применимы скобки `{}` и на какой строчке `man bash` это описано?

Описано в man bash `RESERVED WORDS`:
![RESERVED WORDS.](./img/RESERVED_WORDS.png)


7. С учётом ответа на предыдущий вопрос, как создать однократным вызовом `touch` 100000 файлов? Получится ли аналогичным образом создать 300000? Если нет, то почему?

`touch {1..100000}.txt`

![touch.](./img/touch.png)

```
touch {1..300000}.txt
-bash: /usr/bin/touch: Argument list too long
```
Выводится сообщение `Argument list too long` из за того что файлов больше чем допустимый лимит, проверить который можно командой
```
getconf ARG_MAX
2097152
```
Удалить фалы командой `rm` болше числа `2097152` не получится


8. В man bash поищите по `/\[\[`. Что делает конструкция `[[ -d /tmp ]]`

```
[ — это алиас встроенной команды test.   
[[ — более продвинутая версия.  

[ использует для проверки строк на совпадение операторы = и !=.  
[[ использует ==, != и =~, при этом правый аргумент расценивается как регулярное выражение, а не как строка, если не взят в кавычки.   

vagrant@vagrant:~$ [[ -d /test ]] && echo dir
vagrant@vagrant:~$ [[ -d /tmp ]] && echo dir
dir

mkdit /tmp/test

vagrant@vagrant:~$ [[ -d /tmp ]] && echo dir
dir
vagrant@vagrant:~$ [[ -d /tmp/test ]] && echo dir
dir
vagrant@vagrant:~$ [[ -d /tmp/test/test ]] && echo dir


```
[ [[…]] ](https://www.gnu.org/software/bash/manual/html_node/Conditional-Constructs.html#index-_005b_005b)

[	Conditional Constructs ](https://www.gnu.org/software/bash/manual/html_node/Conditional-Constructs.html)

9. Добейтесь в выводе type -a bash в виртуальной машине наличия первым пунктом в списке `bash is /tmp/new_path_directory/bash`:

![new_path_directory.](./img/new_path_directory.png)

```
mkdir /tmp/new_path_directory   
sudo cp /bin/bash /tmp/new_path_directory   
sudo nano /etc/shells   
exec bash
```


Опция `-a` показывает все места которые содержат команду 
Например:
```
type -a ll
ll is aliased to `ls -alF'
```

```
type -a bash
bash is /bin/bash
```

```
type -a pwd
pwd is a shell builtin
pwd is /bin/pwd
```




10. Чем отличается планирование команд с помощью ''batch' и 'at'?

``at``    - Используется для назначения одноразового задания на заданное время   
``batch`` - Используется для назначения одноразовых задач, которые должны выполняться, когда загрузка системы становится 0,8 (0,5)   
>>>>>>> af827acefdf8eea38b947ac60ca1c3fee796ae28
