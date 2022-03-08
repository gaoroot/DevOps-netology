CREATE DATABASE test_db;
CREATE USER "test-admin-user" WITH ENCRYPTED PASSWORD 'testadminuser';

CREATE TABLE orders (id SERIAL PRIMARY KEY, denomination VARCHAR(100), price );
CREATE TABLE clients (id SERIAL PRIMARY KEY, surname VARCHAR(20), residence_country VARCHAR(20), order INT REFERENCES orders(id) ON DELETE CASCADE);

CREATE INDEX indx_clients_country ON clients (country);
GRANT CONNECT ON DATABASE test_db to "test-admin-user";

GRANT ALL ON ALL TABLES IN SCHEMA public to "test-admin-user";
GRANT CONNECT ON DATABASE test_db to "test-simple-user";
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public to "test-simple-user";