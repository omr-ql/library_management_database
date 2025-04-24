-- Insert Authors
INSERT INTO Authors (name, bio) VALUES 
('J.K. Rowling', 'British author, best known for the Harry Potter series.'),
('George Orwell', 'English novelist and essayist, known for 1984 and Animal Farm.');

-- Insert Categories
INSERT INTO Categories (genre_name) VALUES 
('Fantasy'), 
('Science Fiction'), 
('Non-Fiction'), 
('Mystery');

-- Insert Books
INSERT INTO Books (title, author_id, isbn, publication_date, genre_id, availability_status) VALUES 
('Harry Potter and the Sorcerer''s Stone', 1, '978-0439708180', '1997-06-26', 1, TRUE),
('1984', 2, '978-0451524935', '1949-06-08', 2, TRUE);

-- Insert Members
INSERT INTO Members (name, contact_info, membership_id, join_date) VALUES 
('Alice ', 'a@example.com', 'M01', '2023-01-12'),
('Bob ', 'b@example.com', 'M02', '2023-02-21');

-- Insert Loans
INSERT INTO Loans (book_id, member_id, checkout_date, due_date, return_date, return_status) VALUES 
(1, 1, CURRENT_DATE - INTERVAL '22 days', CURRENT_DATE - INTERVAL '8 days', NULL, FALSE),
(2, 2, CURRENT_DATE - INTERVAL '34 days', CURRENT_DATE - INTERVAL '20 days', CURRENT_DATE - INTERVAL '21 days', TRUE);
