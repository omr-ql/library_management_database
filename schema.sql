DROP TABLE IF EXISTS Loans;
DROP TABLE IF EXISTS Books;
DROP TABLE IF EXISTS Members;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Authors;

-- Create Authors table
CREATE TABLE Authors (
    author_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    bio TEXT
);

-- Create Categories table
CREATE TABLE Categories (
    genre_id SERIAL PRIMARY KEY,
    genre_name VARCHAR(100) NOT NULL
);

-- Create Books table
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

-- Create Members table
CREATE TABLE Members (
    member_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    contact_info VARCHAR(255),
    membership_id VARCHAR(50) UNIQUE,
    join_date DATE
);

-- Create Loans table
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
