CREATE DATABASE test_db;
CREATE USER "test-admin-user";

CREATE TABLE orders(id SERIAL PRIMARY KEY, denomination TEXT, price integer,);
CREATE TABLE clients(id SERIAL PRIMARY KEY, surname TEXT, residence_country integer, order INT REFERENCES orders(id) ON DELETE CASCADE);



CREATE DATABASE test_db;
CREATE USER "test-admin-user" WITH ENCRYPTED PASSWORD 'testadminuser';

CREATE TABLE orders (id SERIAL PRIMARY KEY, denomination VARCHAR(100), price );
CREATE TABLE clients (id SERIAL PRIMARY KEY, surname VARCHAR(20), residence_country VARCHAR(20), order INT REFERENCES orders(id) ON DELETE CASCADE);

CREATE INDEX indx_clients_country ON clients (country);
GRANT CONNECT ON DATABASE test_db to "test-admin-user";

GRANT ALL ON ALL TABLES IN SCHEMA public to "test-admin-user";
GRANT CONNECT ON DATABASE test_db to "test-simple-user";
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public to "test-simple-user";



CREATE DATABASE test_db;
CREATE ROLE "test-admin-user";
GRANT ALL PRIVILEGES ON DATABASE test_db TO "test-admin-user";
GRANT USAGE, CREATE ON SCHEMA public TO "test-admin-user";
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO "test-admin-user";

CREATE TABLE orders (id integer PRIMARY KEY, name text, price integer);

CREATE TABLE clients (id integer PRIMARY KEY, surname text, residence_country text, booking integer, FOREIGN KEY (booking) REFERENCES orders (id));

CREATE INDEX countryid ON clients(residence_country); 

GRANT ALL ON DATABASE test_db to "test-admin-user";

CREATE USER "test-simple-user" WITH ENCRYPTED PASSWORD 'testsimpleuserpass';

GRANT SELECT,INSERT,UPDATE,DELETE ON TABLE public.clients TO "test-simple-user";
GRANT SELECT,INSERT,UPDATE,DELETE ON TABLE public.orders TO "test-simple-user";

SELECT * FROM information_schema.role_table_grants WHERE grantee not like 'postgres' AND table_catalog = 'test_db' AND table_name IN ('clients', 'orders');
