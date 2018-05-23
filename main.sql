--select * from pr_calculate_fees(,0,0,null)
select array(select * from pr_calculate_fees(20,1000,1001,current_date))