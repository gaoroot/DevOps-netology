
11. 

Если имеется в виду самая свежая то SSE4_2
Если самая старая то SSE



5. 

STDIN	0
STDOUT	1

>	Записывает данные на выходе команды вместо командной строки в файл или на устройство, например, на принтер.
>&	Считывает данные на выходе одного дескриптора как входные данные для другого дескриптора.
0>&1 Считывает данные на выходе STDIN и передаёт как входные данные для STDOUT

    ~/test  cat test.txt                                                             ✔ 
test
netology

   ~/test  cat test.txt 0>&1 netology.txt                                           ✔ 
test
netology

Или так, netology.txt был пустой

    ~/test  cat test.txt 0>&1 |tee cat netology.txt                                  ✔ 
test
netology



2. 

   ~/test  grep test test.txt -c                                                     ✔ 
1

-c Выводит количество строк найденых в файле.