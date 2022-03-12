# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД

`\l` - выводит список БД

```concole
postgres=# \l
                                     List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |       Access privileges
-----------+----------+----------+------------+------------+--------------------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                   +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                   +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/postgres                  +
           |          |          |            |            | postgres=CTc/postgres         +
           |          |          |            |            | "test-admin-user"=CTc/postgres
(4 rows)
```

- подключения к БД

`\c имя_бд` - подключения к Имя_бд 

```console
postgres=# \c test_db
You are now connected to database "test_db" as user "postgres".
test_db=#
```

```console
test_db=# \c template1
You are now connected to database "template1" as user "postgres".
template1=#
```

- вывода списка таблиц

`\dt` - выводит список таблиц в подключённой БД

```console
test_db=# \dt
          List of relations
 Schema |  Name   | Type  |  Owner
--------+---------+-------+----------
 public | clients | table | postgres
 public | orders  | table | postgres
(2 rows)

test_db=#
```
- вывода описания содержимого таблиц

`\d имя_таблицы` - вывод содержимого таблицы имя_тиблицы

```console
test_db=# \d clients
                    Table "public.clients"
      Column       |  Type   | Collation | Nullable | Default
-------------------+---------+-----------+----------+---------
 id                | integer |           | not null |
 surname           | text    |           |          |
 residence_country | text    |           |          |
 booking           | integer |           |          |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "countryid" btree (residence_country)
Foreign-key constraints:
    "clients_booking_fkey" FOREIGN KEY (booking) REFERENCES orders(id)

test_db=#
```

- выхода из psql

`\q` - выход

```console
test_db=# \q
bash-5.1#
```

---

## Задача 2

Используя `psql` создайте БД `test_database`.

```console
bash-5.1# psql -U postgres
psql (13.6)
Type "help" for help.

postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(3 rows)

postgres=# CREATE DATABASE test_database;
CREATE DATABASE
postgres=# \l
                                   List of databases
     Name      |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
---------------+----------+----------+------------+------------+-----------------------
 postgres      | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
 template1     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
 test_database | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
(4 rows)

postgres=#
```

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

```console
user0@server:~/pg13$ docker exec -it pg13_postgres_1 /bin/bash
bash-5.1# cd /var/lib/postgresql/
bash-5.1# ls
backup  data
bash-5.1# psql -U postgres -d test_database -f backup/test_dump.sql
SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval
--------
      8
(1 row)

ALTER TABLE
bash-5.1#
```

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

```console
bash-5.1# psql -U postgres
psql (13.6)
Type "help" for help.

postgres=# \c test_database
You are now connected to database "test_database" as user "postgres".
test_database=# \dt
         List of relations
 Schema |  Name  | Type  |  Owner
--------+--------+-------+----------
 public | orders | table | postgres
(1 row)

test_database=# ANALYZE VERBOSE public.orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
test_database=#
```

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

```sql
test_database=# SELECT avg_width, attname FROM pg_stats WHERE TABLENAME='orders';
 avg_width | attname
-----------+---------
         4 | id
        16 | title
         4 | price
(3 rows)

test_database=#
```

---

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

```sql
ALTER TABLE orders RENAME TO orders_big;

CREATE TABLE orders (id integer, title varchar(80), price integer) PARTITION BY RANGE(price);

CREATE TABLE orders_1 PARTITION OF orders FOR VALUES FROM (500) TO (MAXVALUE);

CREATE TABLE orders_2 PARTITION OF orders FOR VALUES FROM (MINVALUE) TO (500);

INSERT INTO orders (id, title, price) SELECT * FROM orders_big;

SELECT * FROM orders_1;
SELECT * FROM orders_2;
```

```sql
test_database=# ALTER TABLE orders RENAME TO orders_big;
ALTER TABLE
test_database=# CREATE TABLE orders (id integer, title varchar(80), price integer) PARTITION BY RANGE(price);
CREATE TABLE
test_database=# CREATE TABLE orders_1 PARTITION OF orders FOR VALUES FROM (500) TO (MAXVALUE);
ATE TABLECREATE TABLE
test_database=# CREATE TABLE orders_2 PARTITION OF orders FOR VALUES FROM (MINVALUE) TO (500);
CREATE TABLE
test_database=# INSERT INTO orders (id, title, price) SELECT * FROM orders_big;
INSERT 0 8
test_database=# SELECT * FROM orders_1;
 id |       title        | price
----+--------------------+-------
  2 | My little database |   500
  6 | WAL never lies     |   900
  8 | Dbiezdmin          |   501
(3 rows)

test_database=# SELECT * FROM orders_2;
 id |        title         | price
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  7 | Me and my bash-pet   |   499
(5 rows)

test_database=#
```

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

    - Ручного расбиения можно было бы исбежать, если изначально спроектировать таблицу как секционарованную.

---

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

```console
bash-5.1# ls
backup  data
bash-5.1# pg_dump -U postgres test_database -f backup/dump_test_database.sql
bash-5.1# ls backup/
dump_test_database.sql  test_dump.sql
bash-5.1#
```

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

Доработать файл бекапа можно следующим образом, добавив `UNIQUE(title)`:

```sql
CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer DEFAULT 0,
    UNIQUE(title)
);
```

---
