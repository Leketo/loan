-- Function: public.fl_gen_fees(numeric, numeric, numeric, date)

-- DROP FUNCTION public.fl_gen_fees(numeric, numeric, numeric, date);

CREATE OR REPLACE FUNCTION public.fl_gen_fees(
    amount_of_fees numeric,
    amounts numeric,
    amounts_last_fees numeric,
    first_expiration date)
  RETURNS SETOF fees[] AS
$BODY$
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.fl_gen_fees(numeric, numeric, numeric, date)
  OWNER TO postgres;

