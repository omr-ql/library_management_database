-- Create a view for overdue books
CREATE OR REPLACE VIEW overdue_books AS
SELECT l.loan_id, b.title, m.name, m.contact_info, l.due_date, 
       CURRENT_DATE - l.due_date AS days_overdue
FROM Loans l
JOIN Books b ON l.book_id = b.book_id
JOIN Members m ON l.member_id = m.member_id
WHERE l.return_status = FALSE AND l.due_date < CURRENT_DATE;

-- Create a function to calculate fines
CREATE OR REPLACE FUNCTION calculate_fine(p_loan_id INT)
RETURNS DECIMAL AS $$
DECLARE
    fine_amount DECIMAL(10,2);
    v_due_date DATE;
    v_return_date DATE;
    v_return_status BOOLEAN;
BEGIN
    SELECT due_date, return_date, return_status 
    INTO v_due_date, v_return_date, v_return_status
    FROM Loans
    WHERE loan_id = p_loan_id;
    
    IF v_return_status = TRUE THEN
        -- Book returned, calculate based on actual return date
        IF v_return_date > v_due_date THEN
            fine_amount := (v_return_date - v_due_date) * 1.00; -- $1 per day
        ELSE
            fine_amount := 0;
        END IF;
    ELSE
        -- Book not returned yet, calculate based on current date
        IF CURRENT_DATE > v_due_date THEN
            fine_amount := (CURRENT_DATE - v_due_date) * 1.00; -- $1 per day
        ELSE
            fine_amount := 0;
        END IF;
    END IF;
    
    RETURN fine_amount;
END;
$$ LANGUAGE plpgsql;
