# Домашнее задание к занятию "6.1. Типы и структура СУБД"

## Задача 1

Архитектор ПО решил проконсультироваться у вас, какой тип БД 
лучше выбрать для хранения определенных данных.

Он вам предоставил следующие типы сущностей, которые нужно будет хранить в БД:

- Электронные чеки в json виде  
    - Документоориентированная СУБД(MongoDB, к примеру, хранит в себе данные в виде json фалов)  
- Склады и автомобильные дороги для логистической компании  
    - графовая(Склады - как узлы, дороги - как ребра.)  
- Генеалогические деревья  
    - Иерархические(Генеалогические деревья имеют структуру, похожую на иерархическую)  
- Кэш идентификаторов клиентов с ограниченным временем жизни для движка аутенфикации  
    - Ключ-значение(Простая структура, быстродействие)  
- Отношения клиент-покупка для интернет-магазина  
    - Реляционные(Множество категорий и типов данных, необходима чёткая структура)  

Выберите подходящие типы СУБД для каждой сущности и объясните свой выбор.

## Задача 2

Вы создали распределенное высоконагруженное приложение и хотите классифицировать его согласно 
CAP-теореме. Какой классификации по CAP-теореме соответствует ваша система, если 
(каждый пункт - это отдельная реализация вашей системы и для каждого пункта надо привести классификацию):

- Данные записываются на все узлы с задержкой до часа (асинхронная запись)  
   ~~CA, PACELC - PC/EL~~

    - CP, PACELC - PA/EL
- При сетевых сбоях, система может разделиться на 2 раздельных кластера  
   ~~PA, PACELC - PA/EL~~

    - CA, PA/EC
- Система может не прислать корректный ответ или сбросить соединение  
   ~~CP, PACELC - PA/EC~~

    - CP, PC/EC


А согласно PACELC-теореме, как бы вы классифицировали данные реализации?

## Задача 3

Могут ли в одной системе сочетаться принципы BASE и ACID? Почему?
- Нет, не могут. Принципы противоречат друг другу.

## Задача 4

Вам дали задачу написать системное решение, основой которого бы послужили:

- фиксация некоторых значений с временем жизни
- реакция на истечение таймаута

Вы слышали о key-value хранилище, которое имеет механизм [Pub/Sub](https://habr.com/ru/post/278237/). 
Что это за система? Какие минусы выбора данной системы?

    - redis
    - Механизм Pub/Sub позволяет подписаться на канал и получать сообщения из него или же отправлять в этот канал сообщение, которое будет получено всеми подписчиками

    - Механизм pub/sub не гарантирует доставки сообщений и консистентности. Поэтому, если необходимые задачи системного решения являются критичиными, то механизм Pub/Sub будет избыточен

---

[дополнительные материалы](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).