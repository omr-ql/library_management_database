-- This SQL script is just a Sample SQL script to run it and if everything works fine .

-- Finding Overdue Books 
SELECT Loans.loan_id, Books.title, Members.name, Loans.due_date 
FROM Loans 
JOIN Books ON Loans.book_id = Books.book_id 
JOIN Members ON Loans.member_id = Members.member_id 
WHERE Loans.return_status = FALSE AND Loans.due_date < CURRENT_DATE;
 
-- Calculating Fines
SELECT member_id, SUM(CASE WHEN due_date < CURRENT_DATE THEN (CURRENT_DATE - due_date) * 1 ELSE 0 END) AS total_fine 
FROM Loans 
WHERE return_status = FALSE 
GROUP BY member_id;

--Finding Popular Books
SELECT Books.title, COUNT(Loans.loan_id) AS times_borrowed 
FROM Loans 
JOIN Books ON Loans.book_id = Books.book_id 
GROUP BY Books.title 
ORDER BY times_borrowed DESC 
LIMIT 10;

--Find Books by Title, Author, or ISBN (Search Functionality)
SELECT b.book_id, b.title, a.name AS author, b.isbn, c.genre_name, 
       CASE WHEN b.availability_status = TRUE THEN 'Available' ELSE 'Checked Out' END AS status
FROM Books b
JOIN Authors a ON b.author_id = a.author_id
JOIN Categories c ON b.genre_id = c.genre_id
WHERE b.title ILIKE '%harry%' OR a.name ILIKE '%rowling%' OR b.isbn LIKE '%0439%'
ORDER BY b.title;

-- Books Due for Return in the Next 7 Days 
SELECT b.title, m.name AS borrower, m.contact_info, l.due_date,
       (l.due_date - CURRENT_DATE) AS days_until_due
FROM Loans l
JOIN Books b ON l.book_id = b.book_id
JOIN Members m ON l.member_id = m.member_id
WHERE l.return_status = FALSE 
AND l.due_date BETWEEN CURRENT_DATE AND (CURRENT_DATE + INTERVAL '7 days')
ORDER BY l.due_date;

-- Books That Have Never Been Borrowed
SELECT b.title, a.name AS author, c.genre_name
FROM Books b
JOIN Authors a ON b.author_id = a.author_id
JOIN Categories c ON b.genre_id = c.genre_id
WHERE b.book_id NOT IN (SELECT DISTINCT book_id FROM Loans)
ORDER BY c.genre_name, b.title;

-- Active Members with Current Loans
SELECT m.name, m.contact_info, COUNT(l.loan_id) AS active_loans,
       MAX(l.due_date) AS latest_due_date
FROM Members m
JOIN Loans l ON m.member_id = l.member_id
WHERE l.return_status = FALSE
GROUP BY m.member_id, m.name, m.contact_info
ORDER BY active_loans DESC;

-- Members with Overdue Books and Total Fines
SELECT m.member_id, m.name, m.contact_info, 
       COUNT(l.loan_id) AS overdue_books,
       SUM(CURRENT_DATE - l.due_date) AS total_days_overdue,
       SUM(calculate_fine(l.loan_id)) AS total_fines
FROM Members m
JOIN Loans l ON m.member_id = l.member_id
WHERE l.return_status = FALSE AND l.due_date < CURRENT_DATE
GROUP BY m.member_id, m.name, m.contact_info
ORDER BY total_fines DESC;

-- Inactive Members (No Loans in Last 3 Months)
SELECT m.name, m.contact_info, m.join_date,
       MAX(l.return_date) AS last_activity
FROM Members m
LEFT JOIN Loans l ON m.member_id = l.member_id
GROUP BY m.member_id, m.name, m.contact_info, m.join_date
HAVING MAX(l.return_date) < (CURRENT_DATE - INTERVAL '3 months')
   OR MAX(l.return_date) IS NULL
ORDER BY last_activity NULLS FIRST;

-- End of SQL script