-- Function: public.fl_gen_listener_to_fees(fees[], listener)

-- DROP FUNCTION public.fl_gen_listener_to_fees(fees[], listener);

CREATE OR REPLACE FUNCTION public.fl_gen_listener_to_fees(
    p_fees fees[],
    p_list listener)
  RETURNS SETOF listener[] AS
$BODY$
declare
r_fees fees;
r_list listener;
begin
foreach r_fees in array p_fees loop
  r_list.type_value  :=  p_list.type_value;
  r_list.fees_number :=  r_fees.number;
  r_list.amounts     :=  r_fees.amounts;
  return next ARRAY[(r_list)]::listener[];
 end loop;
end
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.fl_gen_listener_to_fees(fees[], listener)
  OWNER TO postgres;

