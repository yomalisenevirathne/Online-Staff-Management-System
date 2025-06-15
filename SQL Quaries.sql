CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  position VARCHAR(100),
  contactno VARCHAR(20),
  department VARCHAR(100),
  salary DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  OTperHour DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  password VARCHAR(255) NOT NULL
);

INSERT INTO users (name, email, position, contactno, department, password) VALUES
('Nimal Perera', 'nimal.perera@example.com', 'Manager', '+94 77 123 4567', 'Sales', 'hashedpassword1'),
('Kumari Jayasinghe', 'kumari.jayasinghe@example.com', 'Staff', '+94 71 234 5678', 'STAFF', 'hashedpassword2'),
('Priyanthi Fernando', 'priyanthi.fernando@example.com', 'Manager', '+94 77 345 6789', 'MANAGER', 'hashedpassword3'),
('Chamara Wijesinghe', 'chamara.wijesinghe@example.com', 'Staff', '+94 71 456 7890', 'IT',  'hashedpassword4'),
('Rashmi Silva', 'rashmi.silva@example.com', 'Manager', '+94 77 567 8901', 'HR', 'hashedpassword5'),
('Dinesh Perera', 'dinesh.perera@example.com', 'Staff', '+94 71 678 9012', 'Operations', 'hashedpassword6');

CREATE TABLE leave_request (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  start_date DATE,
  end_date DATE,
  type  VARCHAR(20),
  reason TEXT,
  status VARCHAR(20),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO leave_request (user_id, start_date, end_date, type, reason, status) VALUES
(1, '2025-05-15', '2025-05-17', 'Annual', 'Family vacation', 'Pending'),
(2, '2025-05-20', '2025-05-22', 'Sick', 'Medical leave', 'Approved');

CREATE TABLE attendance (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    date DATE NOT NULL,
    in_time TIME,
    out_time TIME,
    remark TEXT,
    status VARCHAR(50) DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

select * from users;
select * from payroll;

CREATE TABLE payroll (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    month VARCHAR(15) NOT NULL,
    year INT NOT NULL,
    basic_salary DOUBLE NOT NULL,
    bonus DOUBLE DEFAULT 0,
    deductions DOUBLE DEFAULT 0,
    payment_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

	INSERT INTO payroll (user_id, month, year, basic_salary, bonus, deductions, payment_date, status, employee_name)
	VALUES
	(1, 'January', 2025, 50000.00, 5000.00, 2000.00, '2025-01-31', 'Paid', 'Alice Johnson'),
	(2, 'January', 2025, 60000.00, 4000.00, 1500.00, '2025-01-31', 'Paid', 'Bob Smith'),
	(3, 'February', 2025, 55000.00, 3000.00, 1000.00, '2025-02-28', 'Pending', 'Charlie Brown'),
	(4, 'February', 2025, 48000.00, 2000.00, 1800.00, NULL, 'Pending', 'Diana Prince'),
	(5, 'March', 2025, 62000.00, 0.00, 2200.00, '2025-03-31', 'Paid', 'Edward Green');



