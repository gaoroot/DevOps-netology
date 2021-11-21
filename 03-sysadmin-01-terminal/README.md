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

