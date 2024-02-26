create table bankloan(
id int primary key,
address_state varchar(50),
application_type varchar(50),
emp_length varchar(50),
emp_title varchar(100),
grade varchar(50),
home_ownership varchar(50),	
issue_date date,
last_credit_pull_date date,
last_payment_date date,
loan_status varchar(50),
next_payment_date date,	
member_id int,
purpose varchar(50),
sub_grade varchar(50),	
term varchar(50),
verification_status varchar(50),
annual_income float,
dti float,
installment float,	
int_rate float,
loan_amount varchar(50),
total_acc int,	
total_payment int
);
alter table bankloan
alter column loan_amount type numeric
using loan_amount::numeric;
select * from bankloan;

copy bankloan(id,address_state,application_type,emp_length,emp_title,grade,home_ownership,issue_date,last_credit_pull_date,last_payment_date,loan_status,next_payment_date,member_id,purpose,sub_grade,term,verification_status,annual_income,dti,installment,int_rate,loan_amount,total_acc,total_payment
)
from 'D:\financial_loan.csv'
delimiter ','
csv header;

--Total Loan Applications
SELECT COUNT(id) AS Total_Applications FROM bankloan;

--MTD Loan Applications
SELECT COUNT(id) AS Total_Applications FROM bankloan
WHERE extract(MONTH from issue_date) = 12

--PMTD Loan Applications
SELECT COUNT(id) AS Total_Applications FROM bankloan
WHERE extract(MONTH from issue_date) = 11;

--Total Funded Amount
SELECT SUM(loan_amount) AS Total_Funded_Amount FROM bankloan;

--MTD Total Funded Amount
SELECT SUM(loan_amount) AS Total_Funded_Amount FROM bankloan
WHERE extract(MONTH from issue_date) = 12

--PMTD Total Funded Amount
SELECT SUM(loan_amount) AS Total_Funded_Amount FROM bankloan
WHERE extract(MONTH from issue_date) = 11

--Total Amount Received
SELECT SUM(total_payment) AS Total_Amount_Collected FROM bankloan
 
--MTD Total Amount Received
SELECT SUM(total_payment) AS Total_Amount_Collected FROM bankloan
WHERE extract(MONTH from issue_date) = 12
 
--PMTD Total Amount Received
SELECT SUM(total_payment) AS Total_Amount_Collected FROM bankloan
WHERE extract(MONTH from issue_date) = 11

--Average Interest Rate
SELECT AVG(int_rate)*100 AS Avg_Int_Rate FROM bankloan
 
--MTD Average Interest
SELECT AVG(int_rate)*100 AS MTD_Avg_Int_Rate FROM bankloan
WHERE extract(MONTH from issue_date) = 12
 
--PMTD Average Interest
SELECT AVG(int_rate)*100 AS PMTD_Avg_Int_Rate FROM bankloan
WHERE extract(MONTH from issue_date) = 11

--Avg DTI
SELECT AVG(dti)*100 AS Avg_DTI FROM bankloan
 
--MTD Avg DTI
SELECT AVG(dti)*100 AS MTD_Avg_DTI FROM bankloan
WHERE extract(MONTH from issue_date) = 12
 
--PMTD Avg DTI
SELECT AVG(dti)*100 AS PMTD_Avg_DTI FROM bankloan
WHERE extract(MONTH from issue_date) = 11

--GOOD LOAN ISSUED
--Good Loan Percentage
SELECT
    (COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END) * 100.0) / 
	COUNT(id) AS Good_Loan_Percentage
FROM bankloan
 
--Good Loan Applications
SELECT COUNT(id) AS Good_Loan_Applications FROM bankloan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'
 
--Good Loan Funded Amount
SELECT SUM(loan_amount) AS Good_Loan_Funded_amount FROM bankloan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

--Good Loan Amount Received
SELECT SUM(total_payment) AS Good_Loan_amount_received FROM bankloan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'
 

--BAD LOAN ISSUED
--Bad Loan Percentage
SELECT
    (COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100.0) / 
	COUNT(id) AS Bad_Loan_Percentage
FROM bankloan
 
--Bad Loan Applications
SELECT COUNT(id) AS Bad_Loan_Applications FROM bankloan
WHERE loan_status = 'Charged Off'
 
--Bad Loan Funded Amount
SELECT SUM(loan_amount) AS Bad_Loan_Funded_amount FROM bankloan
WHERE loan_status = 'Charged Off'
 
--Bad Loan Amount Received
SELECT SUM(total_payment) AS Bad_Loan_amount_received FROM bankloan
WHERE loan_status = 'Charged Off'

--LOAN STATUS
	SELECT
        loan_status,
        COUNT(id) AS LoanCount,
        SUM(total_payment) AS Total_Amount_Received,
        SUM(loan_amount) AS Total_Funded_Amount,
        AVG(int_rate * 100) AS Interest_Rate,
        AVG(dti * 100) AS DTI
    FROM
        bankloan
    GROUP BY
        loan_status
 

SELECT 
	loan_status, 
	SUM(total_payment) AS MTD_Total_Amount_Received, 
	SUM(loan_amount) AS MTD_Total_Funded_Amount 
FROM bankloan
WHERE extract(MONTH from issue_date) = 12 
GROUP BY loan_status

--MONTH
SELECT 
	extract(MONTH from issue_date) AS Month_Number, 
	to_char(issue_date, 'month') AS Month_name, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bankloan
GROUP BY Month_Number, Month_name
ORDER BY Month_Number;


--STATE
SELECT 
	address_state AS State, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bankloan
GROUP BY address_state
ORDER BY address_state

--TERM
SELECT 
	term AS Term, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bankloan
GROUP BY term
ORDER BY term
 

--EMPLOYEE LENGTH
SELECT 
	emp_length AS Employee_Length, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bankloan
GROUP BY emp_length
ORDER BY emp_length
 
--PURPOSE
SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bankloan
GROUP BY purpose
ORDER BY purpose

--HOME OWNERSHIP
SELECT 
	home_ownership AS Home_Ownership, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bankloan
GROUP BY home_ownership
ORDER BY home_ownership
 

/*We have applied multiple Filters on all the dashboards. You can check the results for the filters as well by modifying the query and comparing the results.
For e.g
See the results when we hit the Grade A in the filters for dashboards*/
SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bankloan
WHERE grade = 'A'
GROUP BY purpose
ORDER BY purpose



