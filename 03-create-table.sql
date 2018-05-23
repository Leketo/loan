-- Table: public.customers

-- DROP TABLE public.customers;

CREATE TABLE public.customers
(
  customer_id integer NOT NULL,
  customer_name character(50) NOT NULL,
  CONSTRAINT customers_pk PRIMARY KEY (customer_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.customers
  OWNER TO postgres;




-- Table: public.loan

-- DROP TABLE public.loan;

CREATE TABLE public.loan
(
  id integer NOT NULL DEFAULT nextval('debts_id_seq'::regclass),
  status character varying(20),
  cust_id integer,
  amounts numeric(21,6),
  debits numeric(21,6),
  credits numeric(21,6),
  balance numeric(21,6),
  dues numeric,
  interest_percentage numeric,
  cancellation_date date,
  insertion_date date,
  date_update date,
  CONSTRAINT debts_pk PRIMARY KEY (id),
  CONSTRAINT loan_cust_fk FOREIGN KEY (cust_id)
      REFERENCES public.customers (customer_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT debts_status_check CHECK (status::text = ANY (ARRAY['ON'::character varying, 'OFF'::character varying]::text[]))
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.loan
  OWNER TO postgres;



-- Table: public.fees

-- DROP TABLE public.fees;

CREATE TABLE public.fees
(
  loan_id integer NOT NULL,
  "number" integer NOT NULL,
  status character varying(3),
  expiration date,
  cancellation date,
  amounts numeric(21,6),
  debits numeric(21,6),
  credits numeric(21,6),
  balance numeric(21,6),
  CONSTRAINT dues_pk PRIMARY KEY (loan_id, number),
  CONSTRAINT fees_loan_fk FOREIGN KEY (loan_id)
      REFERENCES public.loan (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT dues_status_check CHECK (status::text = ANY (ARRAY['ON'::character varying, 'OFF'::character varying]::text[]))
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.fees
  OWNER TO postgres;






-- Table: public.type

-- DROP TABLE public.type;

CREATE TABLE public.type
(
  id integer NOT NULL DEFAULT nextval('type_id_seq'::regclass),
  description character varying(25) NOT NULL,
  value smallint NOT NULL,
  CONSTRAINT type_pk PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.type
  OWNER TO postgres;





-- Table: public.listener

-- DROP TABLE public.listener;

CREATE TABLE public.listener
(
  id integer NOT NULL DEFAULT nextval('payment_id_seq'::regclass),
  loan_id integer,
  fees_number integer,
  amounts numeric(21,6),
  type_value smallint,
  CONSTRAINT listener_pk PRIMARY KEY (id),
  CONSTRAINT list_fess_fk FOREIGN KEY (loan_id, fees_number)
      REFERENCES public.fees (loan_id, "number") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.listener
  OWNER TO postgres;



