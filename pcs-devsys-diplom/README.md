# Курсовая работа по итогам модуля "DevOps и системное администрирование"

Курсовая работа необходима для проверки практических навыков, полученных в ходе прохождения курса "DevOps и системное администрирование".

Мы создадим и настроим виртуальное рабочее место. Позже вы сможете использовать эту систему для выполнения домашних заданий по курсу

## Задание

1. Создайте виртуальную машину Linux.
2. Установите ufw и разрешите к этой машине сессии на порты 22 и 443, при этом трафик на интерфейсе localhost (lo) должен ходить свободно на все порты.
3. Установите hashicorp vault ([инструкция по ссылке](https://learn.hashicorp.com/tutorials/vault/getting-started-install?in=vault/getting-started#install-vault)).
4. Cоздайте центр сертификации по инструкции ([ссылка](https://learn.hashicorp.com/tutorials/vault/pki-engine?in=vault/secrets-management)) и выпустите сертификат для использования его в настройке веб-сервера nginx (срок жизни сертификата - месяц).
5. Установите корневой сертификат созданного центра сертификации в доверенные в хостовой системе.
6. Установите nginx.
7. По инструкции ([ссылка](https://nginx.org/en/docs/http/configuring_https_servers.html)) настройте nginx на https, используя ранее подготовленный сертификат:
  - можно использовать стандартную стартовую страницу nginx для демонстрации работы сервера;
  - можно использовать и другой html файл, сделанный вами;
8. Откройте в браузере на хосте https адрес страницы, которую обслуживает сервер nginx.
9. Создайте скрипт, который будет генерировать новый сертификат в vault:
  - генерируем новый сертификат так, чтобы не переписывать конфиг nginx;
  - перезапускаем nginx для применения нового сертификата.
10. Поместите скрипт в crontab, чтобы сертификат обновлялся какого-то числа каждого месяца в удобное для вас время.

## Результат

Результатом курсовой работы должны быть снимки экрана или текст:

- Процесс установки и настройки ufw

  UFW устанавливается в Ubuntu по умолчанию

  Отключение IPv6:  
  `sudo nano /etc/default/ufw`  
  `IPV6=yes` изменить на `IPV6=no`  

  Настройки политик по умолчанию  
  `sudo ufw default deny incoming`  
  `sudo ufw default allow outgoing`  

  Разрешить ssh   
  `sudo ufw allow ssh`  
  можно указать номер порта   
  `sudo ufw allow 22`  
  или если порт не стандарный  
  `sudo ufw allow 2222`   

  Активация UFW  
  `sudo ufw enable`  

  Чтобы посмотреть заданные правила  
  `sudo ufw status verbose`  

  Разрешить соединения HTTP на порту 80  
  `sudo ufw allow http`   
  или   
  `sudo ufw allow 80`  
  Разрешить соединения HTTPS на порту 443  
  `sudo ufw allow https`   
  или   
  `sudo ufw allow 443`  

![UFW](img/ufw.png)  

Для интерфейса `lo`  

Разрешить входящий траффик:  
`sudo ufw allow in on lo to any`  
Разрешить исходящий траффик:  
`sudo ufw allow out on lo to any`  
Проверить статус:  
`sudo ufw status`  
        
![UFW lo](img/ufw-lo.png)


- Процесс установки и выпуска сертификата с помощью hashicorp vault

  - Установка Valut  
  Добавить ключ  
  `curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -`  
  Добавить репозторий  
  `sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"`  
  Обновить и установить   
  `sudo apt update && sudo apt install vault`  
  Проверка установки  
  `vault`

![vault](img/vault.png)

  - Выпускаю сертификаты с помощью скрипта [vault.sh](vault.sh) который создаёт сертификат      центра сертификации(rootCA.pem который в последствии необходимо добавить в доверенные "Центры сертификации" и все последующие автоматически созданные сертификаты будут достоверными) 





- Процесс установки и настройки сервера nginx

`sudo apt update`  
`sudo apt install nginx`  
`systemctl start nginx`  
`systemctl status nginx`  

![nginx](img/nginx.png)


Создаю конфигурайиооный файл `vault.test.local`  

/etc/nginx/sites-available/vault.test.local  

```
server {
        listen 80;
        listen 443 ssl;
    
        ssl_certificate /etc/nginx/vault/vault.test.local.crt.pem;
        ssl_certificate_key /etc/nginx/vault/vault.test.local.crt.key;
        #ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        #ssl_ciphers HIGH:!aNULL:!MD5;

        root /var/www/vault.test.local/html;
        index index.html index.htm index.nginx-debian.html;

        server_name vault.test.local www.vault.test.local;

        location / {
                try_files $uri $uri/ =404;
        }
}

```
`systemctl restart nginx`  


Для автоматического запуска  
`sudo systemctl enable nginx`    



- Страница сервера nginx в браузере хоста не содержит предупреждений  

![](img/https-vault_test_local-ru.png)

![](img/cert-crone-1min_1.png)

- Скрипт генерации нового сертификата работает (сертификат сервера ngnix должен быть "зеленым")

Генерирую сертификат скриптом [vault-nginx.sh](vault-nginx.sh)

![](img/cert-crone-1min_1.png)
![](img/cert-crone-1min_2.png)
![](img/cert-crone-1min_3.png)

- Crontab работает (выберите число и время так, чтобы показать что crontab запускается и делает что надо)

`crontab -e`   

![](img/cron.png)


[vault-nginx.sh](vault-nginx.sh)

![](img/cert-script.png)

