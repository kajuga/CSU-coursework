
DROP TABLE inventory_category;
DROP TABLE service_card;
DROP TABLE client;
DROP TABLE inventory;
DROP TABLE category;



CREATE TABLE client (
    id SERIAL PRIMARY KEY NOT NULL ,
    firstname VARCHAR(50) NOT NULL ,
    secondname VARCHAR(50) NOT NULL ,
    surname VARCHAR(50) NOT NULL ,
    phone_number VARCHAR(20) NOT NULL
);


CREATE TABLE inventory
(
    id SERIAL PRIMARY KEY NOT NULL ,
    name VARCHAR(50) NOT NULL ,
    price NUMERIC NOT NULL
);
CREATE TABLE category
(
    id SERIAL PRIMARY KEY NOT NULL ,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE inventory_category
(
    id_inventory INTEGER references inventory(id)  ,
    id_category INTEGER references category(id)
);

CREATE TABLE service_card
(
    id SERIAL PRIMARY KEY NOT NULL ,
    id_inventory INTEGER references inventory(id)  ,
    id_client INTEGER references client(id)  ,
    date_of_issue date NOT NULL ,
    date_return date,
    invested_funds NUMERIC not null ,
    date_of_entry date NOT NULL,
    CHECK (date_of_issue <= date_return)
);


INSERT INTO category (name) VALUES ('Металл'),('Атлетика'),('Бадминтон'), ('Футбол'), ('Баскетбол');
INSERT INTO inventory (name, price) VALUES ('Гиря', 250.00), ('Штанга', 300.00), ('Ракетка', 450.00), ('Мяч', 150.00);
INSERT INTO client (firstname, secondname, surname, phone_number) VALUES
('Алексей', 'Иванович' , 'Петров', '89176756483'),
('Иван', 'Семенович' , 'Сидоров', '89195357423'),
('Петр', 'Владимирович' , 'Артемьев', '89155657483'),
('Семен', 'Петрович' , 'Куренной', '89185554453'),
('Георгий', 'Ольгович' , 'Федоров', '89135664323'),
('Моня', 'Александровна' , 'Федорова', '89186655444');

INSERT INTO service_card (id_inventory, id_client, date_of_issue, date_return, invested_funds, date_of_entry) VALUES
(2, 3, '01/01/19', '04/01/19', 300.00, '01/01/19'),
(3, 1, '12/02/19', '16/02/19', 450.00, '12/02/19'),
(1, 2, '18/01/19', '22/01/19', 250.00, '18/01/19'),
(4, 5, '27/01/19', '29/01/19', 150.00, '27/01/19'),
(4, 4, '15/02/19', '25/02/19', 150.00, '15/02/19'),
(3, 5, '17/02/19', '18/02/19', 450.00, '17/02/19'),
(2, 5, '18/02/19', '19/02/19', 300.00, '18/02/19');


-- тут я определяю роли инвентаря: например, гиря это категории металл и атлетика, штанга тоже, мяч - футбол и баскетбол.....?
INSERT INTO inventory_category (id_inventory, id_category) VALUES
(1,1),
(1,2),
(2,1),
(2,2),
(3,3),
(4,4),
(4,5);

-- Найти человека,который имеет максимальную сумму оплат в категории, заданной пользователем.

select CONCAT(c.surname, ' ', c.secondname, ' ', c.firstname) as client, cat.name, SUM(sc.invested_funds)  from service_card as sc
    left join client as c on sc.id_client = c.id
    left join inventory_category as ic on ic.id_inventory = sc.id_inventory
    left join category as cat on cat.id = ic.id_category
WHERE cat.name = 'Атлетика'
GROUP BY cat.id, c.id
HAVING SUM(sc.invested_funds) = (select max(all_sum.sum)
                                 from (
                                          select SUM(sc.invested_funds) as sum
                                          from service_card as sc
                                                   left join client as c on sc.id_client = c.id
                                                   left join inventory_category as ic on ic.id_inventory = sc.id_inventory
                                                   left join category as cat on cat.id = ic.id_category
                                          WHERE cat.name = 'Атлетика'
                                          GROUP BY cat.id, c.id) as all_sum)


