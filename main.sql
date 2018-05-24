--select * from pr_calculate_fees(,0,0,null)
--select array(select * from fl_gen_fees(20,1000,1001,current_date))
select fl_gen_loan(1, 5000, 12);

--select * from fl_gen_listener_to_fees(null, null);

select f.* from loan l
join fees f on l.id = f.loan_id
join listener li on f.loan_id = li.loan_id and f.number =  li.fees_number


delete from listener;
delete from fees;
delete from loan;
