-- List all books with their authors and genres
SELECT b.title, a.name AS author, c.genre_name 
FROM Books b
JOIN Authors a ON b.author_id = a.author_id
JOIN Categories c ON b.genre_id = c.genre_id;

-- Find overdue books
SELECT * FROM overdue_books;

-- Calculate fines for all loans
SELECT l.loan_id, b.title, m.name, calculate_fine(l.loan_id) AS fine_amount
FROM Loans l
JOIN Books b ON l.book_id = b.book_id
JOIN Members m ON l.member_id = m.member_id;

-- Find most popular books (most frequently borrowed)
SELECT b.title, COUNT(l.loan_id) AS borrow_count
FROM Books b
JOIN Loans l ON b.book_id = l.book_id
GROUP BY b.title
ORDER BY borrow_count DESC;

-- Check availability of all books
SELECT b.title, 
       CASE WHEN b.availability_status = TRUE THEN 'Available' ELSE 'Checked Out' END AS status
FROM Books b;
