-- Function: public.pl_ins_listener(listener)

-- DROP FUNCTION public.pl_ins_listener(listener);

CREATE OR REPLACE FUNCTION public.pl_ins_listener(p_list listener)
  RETURNS void AS
$BODY$
 declare
 begin
  select nextval('payment_id_seq') into strict p_list.id;

  INSERT INTO public.listener values (p_list.id, 
				      p_list.loan_id, 
				      p_list.fees_number, 
				      p_list.amounts, 
				      p_list.type_value);

 
 end;
  $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.pl_ins_listener(listener)
  OWNER TO postgres;

