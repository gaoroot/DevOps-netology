#### 1.  Какой системный вызов делает команда `cd`?   

chdir("/tmp")                           = 0

```
vagrant@vagrant:~/test3$ strace /bin/bash -c 'cd /tmp' > out-strace.log 2>&1 
vagrant@vagrant:~/test3$ cat out-strace.log | grep /tmp
execve("/bin/bash", ["/bin/bash", "-c", "cd /tmp"], 0x7ffe7921d200 /* 25 vars */) = 0
stat("/tmp", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=4096, ...}) = 0
chdir("/tmp")                           = 0
```

#### 2. ... Используя `strace` выясните, где находится база данных file на основании которой она делает свои догадки. ....
```
vagrant@vagrant:~/test3$ strace file
...
openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3  
...
vagrant@vagrant:~/test3$ file /usr/share/file/magic.mgc  
/usr/share/file/magic.mgc: symbolic link to ../../lib/file/magic.mgc  
```
#### 3.  Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).   


```
vagrant@vagrant:~/test3$ python3 wryter.py


```
`wryter.py` создаёт файл `lsof.log`
```
vagrant@vagrant:~/test3$ lsof | grep deleted
python3   1492                       vagrant    3w      REG              253,0 1072898048     262182 /home/vagrant/test3/lsof.log (deleted)

```
 - Обнулить файл
```
vagrant@vagrant:~/test3$ lsof | grep deleted
python3   1492                       vagrant    3w      REG              253,0 19824205824     262182 /home/vagrant/test3/lsof.log (deleted)
vagrant@vagrant:~/test3$ cat /dev/null > /proc/1492/fd/3

```
- Но он будет продалжат писать
```
vagrant@vagrant:~/test3$ lsof -p 1492
COMMAND  PID    USER   FD   TYPE DEVICE    SIZE/OFF   NODE NAME
python3 1492 vagrant  cwd    DIR  253,0        4096 262173 /home/vagrant/test3
python3 1492 vagrant  rtd    DIR  253,0        4096      2 /
python3 1492 vagrant  txt    REG  253,0     5490352 525251 /usr/bin/python3.8
python3 1492 vagrant  mem    REG  253,0       27002 527765 /usr/lib/x86_64-linux-gnu/gconv/gconv-modules.cache
python3 1492 vagrant  mem    REG  253,0     5699248 535133 /usr/lib/locale/locale-archive
python3 1492 vagrant  mem    REG  253,0      108936 526898 /usr/lib/x86_64-linux-gnu/libz.so.1.2.11
python3 1492 vagrant  mem    REG  253,0      182560 527233 /usr/lib/x86_64-linux-gnu/libexpat.so.1.6.11
python3 1492 vagrant  mem    REG  253,0     1369352 527435 /usr/lib/x86_64-linux-gnu/libm-2.31.so
python3 1492 vagrant  mem    REG  253,0       14848 527455 /usr/lib/x86_64-linux-gnu/libutil-2.31.so
python3 1492 vagrant  mem    REG  253,0       18816 527433 /usr/lib/x86_64-linux-gnu/libdl-2.31.so
python3 1492 vagrant  mem    REG  253,0      157224 527450 /usr/lib/x86_64-linux-gnu/libpthread-2.31.so
python3 1492 vagrant  mem    REG  253,0     2029224 527432 /usr/lib/x86_64-linux-gnu/libc-2.31.so
python3 1492 vagrant  mem    REG  253,0      191472 527389 /usr/lib/x86_64-linux-gnu/ld-2.31.so
python3 1492 vagrant    0u   CHR  136,1         0t0      4 /dev/pts/1
python3 1492 vagrant    1u   CHR  136,1         0t0      4 /dev/pts/1
python3 1492 vagrant    2u   CHR  136,1         0t0      4 /dev/pts/1
python3 1492 vagrant    3w   REG  253,0 24773214208 262182 /home/vagrant/test3/lsof.log (deleted)

```

```
vagrant@vagrant:~/test3$ ls -lia /proc/1492/fd/
total 0
42743 dr-x------ 2 vagrant vagrant  0 Nov 21 08:18 .
42742 dr-xr-xr-x 9 vagrant vagrant  0 Nov 21 08:18 ..
42748 lrwx------ 1 vagrant vagrant 64 Nov 21 08:18 0 -> /dev/pts/1
42749 lrwx------ 1 vagrant vagrant 64 Nov 21 08:18 1 -> /dev/pts/1
42750 lrwx------ 1 vagrant vagrant 64 Nov 21 08:18 2 -> /dev/pts/1
42751 l-wx------ 1 vagrant vagrant 64 Nov 21 08:18 3 -> '/home/vagrant/test3/lsof.log (deleted)'

```


#### 4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?

Нет  

```
vagrant@vagrant:~/test3$ ps aux | grep Z
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
vagrant     1286  0.0  0.0      0     0 pts/1    Z+   11:04   0:00 [python3] <defunct>
vagrant     1295  0.0  0.0   8900   672 pts/0    S+   11:04   0:00 grep --color=auto Z


vagrant@vagrant:~/test3$ ps aux | grep defunct
vagrant     1286  0.0  0.0      0     0 pts/1    Z+   11:04   0:00 [python3] <defunct>
vagrant     1297  0.0  0.0   8900   736 pts/0    S+   11:05   0:00 grep --color=auto defunct

vagrant@vagrant:~/test3$ top
...
1286 vagrant   20   0       0      0      0 Z   0.0   0.0   0:00.00 python3
...
```

#### 5. В iovisor BCC есть утилита `opensnoop`:   

```
vagrant@vagrant:~/test3$ dpkg -L bpfcc-tools | grep sbin/opensnoop
/usr/sbin/opensnoop-bpfcc
vagrant@vagrant:~/test3$ sudo /usr/sbin/opensnoop-bpfcc
PID    COMM               FD ERR PATH
808    vminfo              5   0 /var/run/utmp
585    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
585    dbus-daemon        18   0 /usr/share/dbus-1/system-services
585    dbus-daemon        -1   2 /lib/dbus-1/system-services
585    dbus-daemon        18   0 /var/lib/snapd/dbus-1/system-services/
594    irqbalance          6   0 /proc/interrupts
594    irqbalance          6   0 /proc/stat
594    irqbalance          6   0 /proc/irq/20/smp_affinity
594    irqbalance          6   0 /proc/irq/0/smp_affinity
594    irqbalance          6   0 /proc/irq/1/smp_affinity
594    irqbalance          6   0 /proc/irq/8/smp_affinity
594    irqbalance          6   0 /proc/irq/12/smp_affinity
594    irqbalance          6   0 /proc/irq/14/smp_affinity
594    irqbalance          6   0 /proc/irq/15/smp_affinity

```

#### 6. Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС.

- Системный вызов `uname`

```
vagrant@vagrant:~/test3$ strace uname -a > out-uname.log 2>&1

vagrant@vagrant:~/test3$ cat out-uname.log | grep uname
execve("/bin/uname", ["uname", "-a"], 0x7ffdaf0c1258 /* 25 vars */) = 0
uname({sysname="Linux", nodename="vagrant", ...}) = 0
uname({sysname="Linux", nodename="vagrant", ...}) = 0
uname({sysname="Linux", nodename="vagrant", ...}) = 0

```
- man proc
```
/proc/version
              This string identifies the kernel version that is currently running.  It includes the contents of  /proc/sys/kernel/ostype,  /proc/sys/kernel/osrelease
              and /proc/sys/kernel/version.
```
   
```
vagrant@vagrant:~/test3$ cat /proc/version
Linux version 5.4.0-80-generic (buildd@lcy01-amd64-030) (gcc version 9.3.0 (Ubuntu 9.3.0-17ubuntu1~20.04)) #90-Ubuntu SMP Fri Jul 9 22:49:44 UTC 2021
```

```
vagrant@vagrant:~/test3$ cat /proc/sys/kernel/ostype
Linux
```

```
vagrant@vagrant:~/test3$ cat /proc/sys/kernel/osrelease
5.4.0-80-generic
```

```
vagrant@vagrant:~/test3$ cat /proc/sys/kernel/version
#90-Ubuntu SMP Fri Jul 9 22:49:44 UTC 2021
```
- man 2 uname   

Если установить дополнительно пакет `manpages-dev`
```
vagrant@vagrant:~$ sudo apt install manpages-dev
```

```
vagrant@vagrant:~$ man 2 uname

...
Part of the utsname information is also accessible via /proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}.
...
```

#### 7. Чем отличается последовательность команд через `;` и `&&` в bash?
- `;`  

Для выполнения команд которые будут выполнены последовательно, одна за другой.

Для этого используется специальный оператор `;`
Если написать в командной строке:
```
vagrant@vagrant:~/test3$ mkdir /tmp/new-folder ; cd /tmp/new-folder
```
то оболочка вначале запустит на выполнение команду `mkdir /tmp/new-folder`, выполнится создание каталога, после чего выполнится перемещение в директорию `cd /tmp/new-folder`.   
- `&&`  

Оператор `&&` является управляющим оператором. Если в командной строке стоит `command1 && command2`, то `command2` выполняется в том случае, если статус выхода из команды `command1` имеет нулевой статус, что говорит об успешном ее завершении.   


#### 7. Есть ли смысл использовать в bash `&&`, если применить `set -e`


`set -e` - Немедленно выйти, если команда завершается с ненулевым статусом. 


```
-e    When this option is on, when any command fails (for any of the reasons listed in Section 2.8.1, Consequences of
             Shell Errors or by returning an exit status greater than zero), the shell immediately shall exit, as if by exe‐
             cuting the exit special built-in utility with no arguments, with the following exceptions:

              1. The  failure  of any individual command in a multi-command pipeline shall not cause the shell to exit. Only
                 the failure of the pipeline itself shall be considered.

              2. The -e setting shall be ignored when executing the compound list following the while, until,  if,  or  elif
                 reserved  word, a pipeline beginning with the !  reserved word, or any command of an AND-OR list other than
                 the last.

              3. If the exit status of a compound command other than a subshell command was the result of a failure while -e
                 was being ignored, then -e shall not apply to this command.

             This requirement applies to the shell environment and each subshell environment separately. For example, in:

                 set -e; (false; echo one) | cat; echo two

```

#### 8. Изкаких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?   


    -e  Немедленный выход, если команда завершается с ненулевым статусом.  
    -u  При подстановке расценивайте неустановленные переменные как ошибку.     
    -x  Печатать команды и их аргументы по мере их выполнения. 
    -o  имя-опции
           Установите переменную, соответствующую имени-опции: 
            pipefail    возвращаемое значение конвейера - это статус последней команды для выхода с ненулевым статусом или ноль, если ни одна команда не вышла с ненулевым статусом.



    -e  Exit immediately if a command exits with a non-zero status.  
    -u  Treat unset variables as an error when substituting.  
    -x  Print commands and their arguments as they are executed.  
    -o  option-name
          Set the variable corresponding to option-name:
          pipefail      the return value of a pipeline is the status of
                           the last command to exit with a non-zero status,
                           or zero if no command exited with a non-zero status

Сценарий с такими ключами выйдет если статуc завершения будет удачным, необходимо вводить определённые переменный при выполнении сценария, в противном случаее выдаст ошибку об не установленных переменных, будет выводить выполнение команд по мере их выполнения, выдаст pipefail если статус выполнения будет не удачным.

#### 9. 


```
 ps  -o stat
STAT
Ss
S
S
S
Sl
R+

```
S - Самый встречающийся 5 процессов.  
s - лидер сеанса   
l - является многопоточным

( S  прерывистый сон (ожидание завершения события) )


```
PROCESS STATE CODES
       Here are the different values that the s, stat and state output specifiers (header "STAT" or "S") will display to
       describe the state of a process:

               D    uninterruptible sleep (usually IO)
               I    Idle kernel thread
               R    running or runnable (on run queue)
               S    interruptible sleep (waiting for an event to complete)
               T    stopped by job control signal
               t    stopped by debugger during the tracing
               W    paging (not valid since the 2.6.xx kernel)
               X    dead (should never be seen)
               Z    defunct ("zombie") process, terminated but not reaped by its parent

       For BSD formats and when the stat keyword is used, additional characters may be displayed:

               <    high-priority (not nice to other users)
               N    low-priority (nice to other users)
               L    has pages locked into memory (for real-time and custom IO)
               s    is a session leader
               l    is multi-threaded (using CLONE_THREAD, like NPTL pthreads do)
               +    is in the foreground process group

```
***