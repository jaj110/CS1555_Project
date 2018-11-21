drop table ourSysDATE cascase constraints;

create table ourSysDATE(
  c_date DATE,
  constraint pk_ourSysDATE primary key(c_date)
);
COMMIT;

drop table Customer cascase constraints;

create table Customer(
  login carchar2(10) not null,
  password varchar2(10) not null,
  name varchar2(20),
  address varchar2(30),
  email varchar2(20),
  constraint pk_Customer primary key(login)
);
COMMIT;

drop table Administrator cascase constraints;

create table Administrator(
  login carchar2(10) not null,
  password varchar2(10) not null,
  name varchar2(20),
  address varchar2(30),
  email varchar2(20),
  constraint pk_Administrator primary key(login)
);
COMMIT;

drop table Product cascase constraints;

create table Product(
  auction_id int not null,
  name varchar2(20),
  description varchar2(30),
  seller varchar2(10),
  start_date DATE,
  min_price int,
  number_of_days int,
  status varchar2(15) not null,
  buyer varchar2(10),
  sell_date DATE,
  amount int,
  constraint pk_Product primary key(auction_id),
  constraint fk_Product_s foreign key(seller) references Customer(login),
  constraint fk_Product_b foreign key(buyer) references Customer(login)
);
COMMIT;

drop table Bidlog cascase constraints;

create table Bidlog(
  bidsn int,
  auction_id int,
  bidder varchar2(10),
  bid_time DATE,
  amount int,
  constraint pk_Bidlog primary key(bidsn),
  constraint fk_Bidlog_a foreign key(auction_id) references Product(auction_id),
  constraint fk_Bidlog_b foreign key(bidder) references Customer(login)
);
COMMIT;

drop table Category cascase constraints;

create table Category(
  name varchar2(20),
  parent_category varchar2(20),
  constraint pk_Category primary key(name),
  constraint fk_Category foreign key(parent_category) references Category(name)
);
COMMIT;

drop table BelongsTo cascase constraints;

create table BelongsTo(
  auction_id int,
  category varchar2(20),
  constraint pk_BelongsTo primary key(auction_id, category),
  constraint fk_BelongsTo_a foreign key(auction_id) references Product(auction_id),
  constraint fk_Bidlog_c foreign key(category) references Category(name)
);
COMMIT;

CREATE OR REPLACE TRIGGER trig_bidTimeUpdate
AFTER UPDATE
ON Bidlog
FOR EACH ROW
  when (bidsn = bidsn + 1)
BEGIN
  UPDATE ourSysDATE
  SET c_date = DATEADD(ss, 5, c_date)
END;
/

CREATE OR REPLACE TRIGGER trig_updateHighBid
AFTER UPDATE
ON Bidlog
FOR EACH ROW
  when (amount = new.amount)
BEGIN
  UPDATE Product
  SET new.amount = amount + new.amount
END;
/

 


insert into ourSysDATE values (TO_DATE('11-21-2018', 'MM-DD-YYYY'));

insert into Customer values ('customer1', 'password1', 'Joe', '123 Sesame St', 'joe@gmail.com');
insert into Customer values ('customer2', 'password2', 'Sue', '5000 Forbes Ave', 'sue@gmail.com');
insert into Customer values ('customer3', 'password3', 'Bob', '4000 Fifth Ave', 'bob@gmail.com');

insert into Administrator values ('admin1', 'adminpassword', 'Chad', '101 Fifth Ave', 'admin@gmail.com');

insert into Product values ('001', 'Adidas Shoes', 'These shoes were made for walkin', 'customer1', TO_DATE('11-11-2018','MM-DD-YYYY'), '1', '7', 'Active', 'customer2', TO_DATE('11-18-2018','MM-DD-YYYY'), '100');
insert into Product values ('002', 'Nike Shoes', 'These shoes were also made for walkin', 'customer2', TO_DATE('11-12-2018','MM-DD-YYYY'), '1', '7', 'Active', 'customer3', TO_DATE('11-19-2018','MM-DD-YYYY'), '10');
insert into Product values ('003', 'New Car', 'Perfect for driving', 'customer1', TO_DATE('10-10-2018','MM-DD-YYYY'), '1', '7', 'Active', 'customer2', TO_DATE('10-17-2018','MM-DD-YYYY'), '10000');
insert into Product values ('004', 'Used Car', 'Not quite as perfect for driving', 'customer3', TO_DATE('11-11-2018','MM-DD-YYYY'), '1', '7', 'Active', 'customer2', TO_DATE('11-18-2018','MM-DD-YYYY'), '1000');
insert into Product values ('005', 'Book', 'You can read it', 'customer1', TO_DATE('11-11-2018','MM-DD-YYYY'), '1', '7', 'Active', 'customer2', TO_DATE('11-18-2018','MM-DD-YYYY'), '5');

insert into Bidlog values ('1', '001', 'customer1', TO_DATE('11-11-2018','MM-DD-YYYY'), '10');
insert into Bidlog values ('2', '001', 'customer2', TO_DATE('11-11-2018','MM-DD-YYYY'), '20');
insert into Bidlog values ('3', '001', 'customer1', TO_DATE('11-12-2018','MM-DD-YYYY'), '50');
insert into Bidlog values ('4', '001', 'customer1', TO_DATE('11-14-2018','MM-DD-YYYY'), '100');
insert into Bidlog values ('1', '002', 'customer3', TO_DATE('11-15-2018','MM-DD-YYYY'), '10');
insert into Bidlog values ('1', '003', 'customer3', TO_DATE('10-11-2018','MM-DD-YYYY'), '100');
insert into Bidlog values ('2', '003', 'customer2', TO_DATE('10-12-2018','MM-DD-YYYY'), '1000');
insert into Bidlog values ('3', '003', 'customer3', TO_DATE('10-12-2018','MM-DD-YYYY'), '10000');
insert into Bidlog values ('1', '004', 'customer2', TO_DATE('11-15-2018','MM-DD-YYYY'), '1000');
insert into Bidlog values ('1', '005', 'customer2', TO_DATE('10-12-2018','MM-DD-YYYY'), '5');

insert into Category values ('running shoes', 'footwear');
insert into Category values ('basketball shoes', 'footwear');
insert into Category values ('autobiography', 'books');
insert into Category values ('biography', 'books');
insert into Category values ('SUV', 'automobiles');

insert into BelongsTo values ('001', 'running shoes');
insert into BelongsTo values ('002', 'basketball shoes');
insert into BelongsTo values ('003', 'SUV');
insert into BelongsTo values ('004', 'SUV');
insert into BelongsTo values ('005', 'biography');

commit;
