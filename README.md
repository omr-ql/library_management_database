<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" class="logo" width="120"/>

# Library Management System

A PostgreSQL database system for managing a library's books, members, and loans. This system provides a comprehensive solution for tracking book inventory, managing library members, and handling book loans with features for monitoring overdue books and calculating fines.

## Database Schema

The database consists of five main tables:

### Authors Table

```sql
CREATE TABLE Authors (
    author_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    bio TEXT
);
```


### Categories Table

```sql
CREATE TABLE Categories (
    genre_id SERIAL PRIMARY KEY,
    genre_name VARCHAR(100) NOT NULL
);
```


### Books Table

```sql
CREATE TABLE Books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author_id INT NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    publication_date DATE,
    genre_id INT,
    availability_status BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id),
    FOREIGN KEY (genre_id) REFERENCES Categories(genre_id)
);
```


### Members Table

```sql
CREATE TABLE Members (
    member_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    contact_info VARCHAR(255),
    membership_id VARCHAR(50) UNIQUE,
    join_date DATE
);
```


### Loans Table

```sql
CREATE TABLE Loans (
    loan_id SERIAL PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    checkout_date DATE,
    due_date DATE,
    return_date DATE,
    return_status BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);
```


## Features

- **Book Inventory Management**: Track books with details like title, author, ISBN, and availability status
- **Member Management**: Store information about library members including contact details and join date
- **Loan Tracking**: Record book checkouts with due dates and return status
- **Overdue Book Monitoring**: Identify books that are past their due date
- **Fine Calculation**: Automatically calculate fines for overdue books
- **Book Categorization**: Organize books by genre/category
- **Author Information**: Maintain separate author records with biographical information


## Setup Instructions

### Prerequisites

- PostgreSQL 12 or higher
- psql command-line tool or a PostgreSQL client (pgAdmin, DBeaver, etc.)


### Database Setup

1. Create a new PostgreSQL database:

```sql
CREATE DATABASE library_management;
```

2. Connect to the database:

```
\c library_management
```

3. Run the schema creation script:

```
\i schema.sql
```

4. Load sample data:

```
\i sample_data.sql
```

5. Create functions and views:

```
\i functions.sql
```


## Usage Examples

### Finding Overdue Books

```sql
SELECT * FROM overdue_books;
```


### Calculating Fines

```sql
SELECT loan_id, calculate_fine(loan_id) AS fine_amount FROM Loans;
```


### Checking Out a Book

```sql
-- First update book availability
UPDATE Books SET availability_status = FALSE WHERE book_id = 3;

-- Then create a loan record
INSERT INTO Loans (book_id, member_id, checkout_date, due_date)
VALUES (3, 2, CURRENT_DATE, CURRENT_DATE + INTERVAL '14 days');
```


### Returning a Book

```sql
-- Update the loan record
UPDATE Loans 
SET return_status = TRUE, return_date = CURRENT_DATE 
WHERE loan_id = 3;

-- Update book availability
UPDATE Books SET availability_status = TRUE WHERE book_id = 3;
```


### Finding Popular Books

```sql
SELECT b.title, COUNT(l.loan_id) AS times_borrowed
FROM Books b
JOIN Loans l ON b.book_id = l.book_id
GROUP BY b.title
ORDER BY times_borrowed DESC;
```


## Project Structure

```
library-management-system/
├── schema.sql        # Database schema creation script
├── sample_data.sql   # Sample data insertion script
├── functions.sql     # Custom functions and views
├── queries.sql       # Example queries
└── README.md         # Project documentation
```


## Future Enhancements

- User authentication system for library staff
- Book reservation system
- Email notification system for due dates
- Book review and rating functionality
- Integration with book cover image APIs
- Barcode scanning for book checkout/return
- Reporting dashboard for library statistics


## Contributing

Contributions to improve the Library Management System are welcome. Please feel free to fork the repository, make changes, and submit pull requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

