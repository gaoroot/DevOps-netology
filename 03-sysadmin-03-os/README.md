1.  Какой системный вызов делает команда cd?   
```
vagrant@vagrant:~/test3$ strace /bin/bash -c 'cd /tmp' > out-strace.log 2>&1 
vagrant@vagrant:~/test3$ cat out-strace.log | grep /tmp
execve("/bin/bash", ["/bin/bash", "-c", "cd /tmp"], 0x7ffe7921d200 /* 25 vars */) = 0
stat("/tmp", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=4096, ...}) = 0
chdir("/tmp")                           = 0
```


2. ... Используя strace выясните, где находится база данных file на основании которой она делает свои догадки. ....
```
vagrant@vagrant:~/test3$ strace file
...
openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3  
...
vagrant@vagrant:~/test3$ file /usr/share/file/magic.mgc  
/usr/share/file/magic.mgc: symbolic link to ../../lib/file/magic.mgc  
```
3.  

4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?

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

