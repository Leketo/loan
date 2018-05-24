-- Function: public.pl_ins_loan_fees_list(loan, fees[], listener[])

-- DROP FUNCTION public.pl_ins_loan_fees_list(loan, fees[], listener[]);

CREATE OR REPLACE FUNCTION public.pl_ins_loan_fees_list(
    IN p_loan loan,
    INOUT p_fees fees[],
    INOUT p_list listener[])
  RETURNS record AS
$BODY$
 declare
  r_fees  fees; 
  r_list  listener; 
 begin
  select nextval('debts_id_seq') into strict p_loan.id;
  INSERT INTO public.loan VALUES (p_loan.id, 
				  p_loan.status, 
				  p_loan.cust_id, 
				  p_loan.amounts, 
				  p_loan.debits, 
				  p_loan.credits, 
				  p_loan.balance, 
				  p_loan.dues, 
				  p_loan.interest_percentage, 
				  p_loan.cancellation_date, 
				  p_loan.insertion_date, 
				  p_loan.date_update);



  foreach r_fees in array p_fees loop
    INSERT INTO public.fees values(p_loan.id, 
				   r_fees.number, 
				   r_fees.status, 
				   r_fees.expiration, 
				   null, 
				   r_fees.amounts, 
				   0, 
				   0, 
				   0);
  end loop;

  foreach r_list in array p_list loop
   r_list.loan_id := p_loan.id;
   perform pl_ins_listener(r_list);
  end loop;
 
 end;
  $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.pl_ins_loan_fees_list(loan, fees[], listener[])
  OWNER TO postgres;

