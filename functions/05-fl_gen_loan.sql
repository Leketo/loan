-- Function: public.fl_gen_loan(integer, numeric, numeric)

-- DROP FUNCTION public.fl_gen_loan(integer, numeric, numeric);

CREATE OR REPLACE FUNCTION public.fl_gen_loan(
    p_cust_id integer,
    p_amounts numeric,
    p_dues numeric)
  RETURNS void AS
$BODY$
 declare
 r_loan loan;
 r_fees fees;
 r_list listener;
 
 t_fees fees[];
 t_list listener[];
 
 nl_fees      integer;
 nl_last_fast integer;
 begin
  nl_fees := 0;
  nl_last_fast := 0;
  
  r_loan.amounts := p_amounts;
  r_loan.cust_id := p_cust_id;
  r_loan.dues := p_dues;
  r_loan.status := 0;
  r_loan.debits:= 0;
  r_loan.credits:= 0;
  r_loan.balance := 0;
  r_loan.interest_percentage := 0;
 
  nl_fees := p_amounts / p_dues;

  if p_dues > 1 then
   nl_fees := nl_fees - mod(nl_fees, 2);
   nl_last_fast := p_amounts - (nl_fees * (p_dues - 1));
  else
   nl_last_fast := nl_fees;
  end if;


  r_list.type_value := 1; 
  select array(select * from fl_gen_fees(p_dues,nl_fees,nl_last_fast,current_date)) into t_fees;
  
  select array(select * from fl_gen_listener_to_fees(t_fees, r_list)) into t_list;

  perform pl_ins_loan_fees_list(r_loan, t_fees, t_list);

 end;
 $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.fl_gen_loan(integer, numeric, numeric)
  OWNER TO postgres;

