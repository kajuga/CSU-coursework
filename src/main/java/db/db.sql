
DROP TABLE service_card;
DROP TABLE client;
DROP TABLE inventory;


CREATE TABLE client (
    id SERIAL NOT NULL ,
    firstname VARCHAR(50) NOT NULL ,
    secondname VARCHAR(50) NOT NULL ,
    surname VARCHAR(50) NOT NULL ,
    phone_number VARCHAR(20) NOT NULL
);


CREATE TABLE inventory
(
    id SERIAL NOT NULL ,
    name VARCHAR(50) NOT NULL ,
    price NUMERIC NOT NULL
);
CREATE TABLE category
(
    id SERIAL NOT NULL ,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE inventory_category
(
    id_inventory INTEGER references inventory(id)  ,
    id_category INTEGER references category(id)
);

CREATE TABLE service_card
(
    id SERIAL NOT NULL ,
    id_inventory INTEGER references inventory(id)  ,
    id_client INTEGER references client(id)  ,
    date_of_issue date NOT NULL ,
    date_return date,
    invested_funds NUMERIC not null ,
    date_of_entry date NOT NULL,
    CHECK (date_of_issue <= date_return)
);


