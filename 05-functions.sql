CREATE or replace FUNCTION pr_calculate_fees(amount_of_fees integer,
                                             amounts numeric,
                                             amounts_last_fees numeric,
                                             first_expiration date) RETURNS SETOF public.fees[]
    LANGUAGE plpgsql
    AS $$
declare
i integer;
r_fees fees;
begin

 if (amount_of_fees is null or amount_of_fees = 0) then
  raise notice 'The amount of fees can not be null or zero';
 end if;

 for i in 1..amount_of_fees loop
   r_fees.number := i;
    if i > 1 then
     r_fees.expiration := r_fees.expiration + 30;
    else
     r_fees.expiration := first_expiration;
    end if;


    if i < amount_of_fees then
      r_fees.amounts := amounts;
     else
      r_fees.amounts := amounts_last_fees;
    end if;

    return next ARRAY[(r_fees)]::fees[];
 end loop;
end
$$;





CREATE or replace FUNCTION fl_gen_listener_to_fees(p_fees fees[], p_list listener) RETURNS SETOF listener[]
    LANGUAGE plpgsql
    AS $$
declare
r_fees fees;
r_list listener;
begin
foreach r_fees in array p_fees loop
  r_list.type_value :=  p_list.type_value;
  r_list.fees_number :=  r_fees.fees_number;
  r_list.amounts  :=  r_fees.amounts;
  return next ARRAY[(r_list)]::listener[];
 end loop;
end
$$;




CREATE or replace FUNCTION pr_gen_loan(p_cust_id integer,
                                       p_amounts numeric,
                                       p_dues numeric) returns void
    LANGUAGE plpgsql
    AS $$
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

  nl_fees := p_amounts / p_dues;

  if p_dues > 1 then
   nl_fees := nl_fees - mod(nl_fees, 2);
   nl_last_fast := p_amounts - (nl_fees * (p_dues - 1));
  else
   nl_last_fast := nl_fees;
  end if;

  select array(select * from pr_calculate_fees(p_dues, p_amounts, nl_last_fast, current_date)) into t_fees;

 end;
 $$;
