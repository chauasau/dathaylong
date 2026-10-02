set default_storage_engine = InnoDB;

create table employee (
	employee_id int auto_increment,
	employee_name varchar(100) not null,
	role varchar(50),
	phone varchar(12),
	is_active bool default true,
	primary key (employee_id)
);

create table customer (
	customer_id int auto_increment,
	customer_name varchar(100) not null,
	phone varchar(12) unique,				-- Đảm bảo không trùng số điện thoại
	loyalty_points INT unsigned default 0,	-- Không âm, mặc định là 0
	primary key (customer_id)
);

create table product (
	product_id int auto_increment,
	product_name varchar(100) not null,
	category varchar(100), 
	current_price int unsigned not null,	-- Giá không được âm
	stock_quantity int unsigned default 0,	-- Tồn kho không âm, khởi tạo bằng 0
	primary key (product_id)
);

create table supplier (
	supplier_id int auto_increment,
	supplier_name varchar(100) not null,
	phone varchar(12),
	address varchar(255),
	primary key (supplier_id)
);

create table invoice (
	invoice_id int auto_increment,
	employee_id int not null,
	customer_id int not null,
	created_at datetime default current_timestamp, -- Tự động lấy ngày giờ hiện tại khi tạo hóa đơn
	total_amount int unsigned default 0,
	payment_method varchar(50),
	primary key (invoice_id),
	constraint fk_invoice_employee_id
	foreign key (employee_id) references employee(employee_id),
	constraint fk_invoice_customer_id
	foreign key (customer_id) references customer(customer_id)
);

create table invoice_details (
	detail_id int auto_increment,
	invoice_id int not null,
	product_id int not null,
	quantity int unsigned not null,
	unit_price int unsigned not null,
	primary key (detail_id), 
	constraint fk_invoice_details_invoice_id
	foreign key (invoice_id) references invoice(invoice_id),
	constraint fk_invoice_details_product_id
	foreign key (product_id) references product(product_id)
);

create table import_order (
	import_id int auto_increment,
	employee_id int not null,
	supplier_id int not null,
	created_at datetime default current_timestamp,
	total_cost int unsigned default 0,
	primary key (import_id),
	constraint fk_import_order_employee_id
	foreign key (employee_id) references employee(employee_id),
	constraint fk_import_order_supplier_id
	foreign key (supplier_id) references supplier(supplier_id)
);

create table import_order_detail (
	detail_id int auto_increment,
	import_id int not null,
	product_id int not null,
	quantity int unsigned not null,
	unit_price int unsigned not null,
	primary key (detail_id),
	constraint fk_import_order_detail_import
	foreign key (import_id) references import_order(import_id),
	constraint fk_import_order_detail_product
	foreign key (product_id) references product(product_id)
);

INSERT INTO employee (employee_name, role, phone, is_active) VALUES
('Nguyen Thu Ha', 'Store Manager', '0901234567', TRUE),
('Tran Van Binh', 'Warehouse Staff', '0912345678', TRUE),
('Le Thi Cam', 'Cashier', '0923456789', TRUE),
('Pham Tuan Anh', 'Cashier', '0934567890', TRUE),
('Hoang Mai Lan', 'Beauty Advisor', '0945678901', TRUE),
('Vu Quoc Bao', 'Beauty Advisor', '0956789012', TRUE),
('Ngo Thanh Tra', 'Beauty Advisor', '0967890123', TRUE),
('Bui Tuong Vy', 'Cashier', '0978901234', FALSE), -- Nhân viên đã nghỉ việc
('Doan Minh Khoa', 'Warehouse Staff', '0989012345', TRUE),
('Truong Ngoc Anh', 'Beauty Advisor', '0990123456', TRUE);

INSERT INTO customer (customer_name, phone, loyalty_points) VALUES
('Tran Bich Ngoc', '0811112222', 150),
('Le Hoang Vu', '0822223333', 0),
('Nguyen Mai Phuong', '0833334444', 500),
('Pham Thuy Trang', '0844445555', 20),
('Hoang Duc Manh', '0855556666', 100),
('Vu Ngoc Tram', '0866667777', 350),
('Dang Kim Oanh', '0877778888', 80),
('Bui Thi Lan', '0888889999', 1200), -- Khách hàng VIP
('Ngo Tien Dat', '0899990000', 45),
('Ly Nha Ky', '0800001111', 220);

INSERT INTO supplier (supplier_name, phone, address) VALUES
('Loreal Vietnam', '0283812345', 'Q1, TP. HCM'),
('Shiseido VN', '0283823456', 'Q3, TP. HCM'),
('Unilever Vietnam', '0283834567', 'Q7, TP. HCM'),
('Rohto Mentholatum', '0274384567', 'VSIP, Binh Duong'),
('Amore Pacific VN', '0283856789', 'Q1, TP. HCM'),
('Estee Lauder', '0283867890', 'Q1, TP. HCM'),
('Bioderma Vietnam', '0283878901', 'Q10, TP. HCM'),
('Paula Choice VN', '0283889012', 'Dong Da, Ha Noi'),
('Kao Vietnam', '0251389012', 'Amata, Dong Nai'),
('Johnson & Johnson', '0283901234', 'Tan Binh, TP. HCM');

INSERT INTO product (product_name, category, current_price, stock_quantity) VALUES
('Sua Rua Mat CeraVe 236ml', 'Skincare', 350000, 50),
('Nuoc Tay Trang Bioderma 500ml', 'Skincare', 450000, 45),
('Kem Chong Nang Anessa', 'Skincare', 550000, 30),
('Son MAC Ruby Woo', 'Makeup', 650000, 20),
('Kem Duong Ẩm Kiehls 50ml', 'Skincare', 950000, 15),
('Serum B5 La Roche Posay', 'Skincare', 850000, 25),
('Phan Phu Innisfree', 'Makeup', 200000, 60),
('Dau Goi Buoi Cocoon', 'Haircare', 220000, 40),
('Nuoc Hoa Dior Sauvage 100ml', 'Perfume', 3500000, 10),
('Tay Da Chet BHA Paula Choice', 'Skincare', 800000, 35);

INSERT INTO invoice (employee_id, customer_id, created_at, total_amount, payment_method) VALUES
(3, 1, '2023-10-01 10:15:00', 800000, 'Credit Card'),  -- Mua SP 1 & 2
(3, 3, '2023-10-02 11:30:00', 550000, 'Cash'),         -- Mua SP 3
(4, 5, '2023-10-03 14:00:00', 1300000, 'Bank Transfer'), -- Mua 2x SP 4
(4, 8, '2023-10-04 16:45:00', 4450000, 'Credit Card'), -- Mua SP 5 & 9
(8, 2, '2023-10-05 09:20:00', 200000, 'Cash'),         -- Mua SP 7
(3, 10, '2023-10-06 18:10:00', 220000, 'Bank Transfer'), -- Mua SP 8
(4, 7, '2023-10-07 19:30:00', 1600000, 'Credit Card'), -- Mua 2x SP 10
(3, 4, '2023-10-08 12:15:00', 850000, 'Cash'),         -- Mua SP 6
(4, 6, '2023-10-09 15:00:00', 1200000, 'Bank Transfer'), -- Mua SP 3 & 4 (Giá cũ SP 4 là 650k)
(3, 9, '2023-10-10 10:00:00', 900000, 'Credit Card');  -- Mua 2x SP 2

INSERT INTO invoice_details (invoice_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 350000),
(1, 2, 1, 450000),
(2, 3, 1, 550000),
(3, 4, 2, 650000),
(4, 5, 1, 950000),
(4, 9, 1, 3500000),
(5, 7, 1, 200000),
(6, 8, 1, 220000),
(7, 10, 2, 800000),
(8, 6, 1, 850000),
(9, 3, 1, 550000),
(9, 4, 1, 650000),
(10, 2, 2, 450000);

INSERT INTO import_order (employee_id, supplier_id, created_at, total_cost) VALUES
(2, 1, '2023-09-15 08:00:00', 12500000), -- Nhập SP 1 (Giá nhập 250k x 50)
(9, 7, '2023-09-16 09:30:00', 15750000), -- Nhập SP 2 (Giá nhập 350k x 45)
(2, 2, '2023-09-17 10:00:00', 12000000), -- Nhập SP 3 (Giá nhập 400k x 30)
(9, 6, '2023-09-18 11:15:00', 10000000), -- Nhập SP 4 (Giá nhập 500k x 20)
(2, 1, '2023-09-19 14:00:00', 10500000), -- Nhập SP 5 (Giá nhập 700k x 15)
(9, 1, '2023-09-20 15:30:00', 15000000), -- Nhập SP 6 (Giá nhập 600k x 25)
(2, 5, '2023-09-21 08:45:00', 9000000),  -- Nhập SP 7 (Giá nhập 150k x 60)
(9, 4, '2023-09-22 13:20:00', 6000000),  -- Nhập SP 8 (Giá nhập 150k x 40)
(2, 6, '2023-09-23 09:10:00', 25000000), -- Nhập SP 9 (Giá nhập 2500k x 10)
(9, 8, '2023-09-24 16:00:00', 21000000); -- Nhập SP 10 (Giá nhập 600k x 35)

INSERT INTO import_order_detail (import_id, product_id, quantity, unit_price) VALUES
(1, 1, 50, 250000),
(2, 2, 45, 350000),
(3, 3, 30, 400000),
(4, 4, 20, 500000),
(5, 5, 15, 700000),
(6, 6, 25, 600000),
(7, 7, 60, 150000),
(8, 8, 40, 150000),
(9, 9, 10, 2500000),
(10, 10, 35, 600000);
