CREATE DATABASE student_management;
USE student_management;
CREATE TABLE students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_code VARCHAR(10) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    major VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO students (student_code, full_name, email, major) VALUES
('ST001', 'Nguyen Van An', 'an.nguyen@example.com', 'Computer Science'),
('ST002', 'Tran Thi Binh', 'binh.tran@example.com', 'Information Systems'),
('ST003', 'Le Hoang Chau', 'chau.le@example.com', 'Data Science'),
('ST004', 'Pham Minh Duc', 'duc.pham@example.com', 'Software Engineering'),
('ST005', 'Vu Thi E', 'e.vu@example.com', 'Computer Science'),
('ST006', 'Nguyen Hong Phat', 'phat.nguyen@example.com', 'Information Systems'),
('ST007', 'Bui Thanh Giang', 'giang.bui@example.com', 'Data Science'),
('ST008', 'Pham Quoc Hung', 'hung.pham@example.com', 'Software Engineering'),
('ST009', 'Le Thi Xuan', 'xuan.le@example.com', 'Computer Science'),
('ST010', 'Do Van Khoa', 'khoa.do@example.com', 'Information Systems'),
('ST011', 'Nguyen Bao Lam', 'lam.nguyen@example.com', 'Data Science'),
('ST012', 'Pham Thi Mai', 'mai.pham@example.com', 'Software Engineering'),
('ST013', 'Hoang Gia Nam', 'nam.hoang@example.com', 'Computer Science'),
('ST014', 'Le Tuan Phong', 'phong.le@example.com', 'Information Systems'),
('ST015', 'Tran Bao Quyen', 'quyen.tran@example.com', 'Data Science'),
('ST016', 'Nguyen Minh Sang', 'sang.nguyen@example.com', 'Software Engineering'),
('ST017', 'Dang Hoang Tan', 'tan.dang@example.com', 'Computer Science'),
('ST018', 'Vu Thi Uyen', 'uyen.vu@example.com', 'Information Systems'),
('ST019', 'Nguyen Trong Van', 'van.nguyen@example.com', 'Data Science'),
('ST020', 'Pham Huu Yen', 'yen.pham@example.com', 'Software Engineering'),
('ST021', 'Nguyen Hong Anh', 'anh.nguyen@example.com', 'Computer Science'),
('ST022', 'Ngo Hai Binh', 'binh.ngo@example.com', 'Information Systems'),
('ST023', 'Le Huu Cuong', 'cuong.le@example.com', 'Software Engineering'),
('ST024', 'Tran Bao Duy', 'duy.tran@example.com', 'Data Science'),
('ST025', 'Nguyen Phuong Ha', 'ha.nguyen@example.com', 'Computer Science'),
('ST026', 'Pham Duc Hung', 'hung.pham@example.com', 'Information Systems'),
('ST027', 'Ho Le Kiet', 'kiet.ho@example.com', 'Software Engineering'),
('ST028', 'Bui Quang Linh', 'linh.bui@example.com', 'Data Science'),
('ST029', 'Tran Van Minh', 'minh.tran@example.com', 'Computer Science'),
('ST030', 'Le Thi Nga', 'nga.le@example.com', 'Information Systems'),
('ST031', 'Nguyen Thanh Oanh', 'oanh.nguyen@example.com', 'Software Engineering'),
('ST032', 'Pham Quoc Phu', 'phu.pham@example.com', 'Data Science'),
('ST033', 'Vo Thi Quyen', 'quyen.vo@example.com', 'Information Systems'),
('ST034', 'Nguyen Quoc Son', 'son.nguyen@example.com', 'Computer Science'),
('ST035', 'Tran Huy Tung', 'tung.tran@example.com', 'Software Engineering'),
('ST036', 'Le Minh Vu', 'vu.le@example.com', 'Data Science');
SELECT * FROM students;
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role ENUM('admin', 'user') DEFAULT 'user',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL
);

-- Insert sample users (password is 'password123' hashed with BCrypt)
INSERT INTO users (username, password, full_name, role) VALUES
('admin', 'password123', 'Admin User', 'admin'),
('john', 'password123', 'John Doe', 'user'),
('jane', 'password123', 'Jane Smith', 'user');


