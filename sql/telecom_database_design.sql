-- ** Database generated with pgModeler (PostgreSQL Database Modeler).
-- ** pgModeler version: 1.2.3
-- ** PostgreSQL version: 16.0
-- ** Project Site: pgmodeler.io
-- ** Model Author: ---

-- ** Database creation must be performed outside a multi lined SQL file. 
-- ** These commands were put in this file only as a convenience.



SET search_path TO pg_catalog,public,telecom;
-- ddl-end --

-- object: telecom.customer | type: TABLE --
-- DROP TABLE IF EXISTS telecom.customer CASCADE;
CREATE TABLE telecom.customer (
	customer_id varchar(20) NOT NULL,
	gender varchar(10),
	senior_citizen boolean,
	partner boolean,
	dependents boolean,
	CONSTRAINT customer_pk PRIMARY KEY (customer_id)
);
-- ddl-end --
ALTER TABLE telecom.customer OWNER TO telecom_user;
-- ddl-end --

-- object: telecom.subscription | type: TABLE --
-- DROP TABLE IF EXISTS telecom.subscription CASCADE;
CREATE TABLE telecom.subscription (
	subscription_id bigint NOT NULL,
	tenure integer,
	contract_start_date date,
	customer_id_customer varchar(20),
	plan_id_plan bigint,
	CONSTRAINT subscription_pk PRIMARY KEY (subscription_id)
);
-- ddl-end --
ALTER TABLE telecom.subscription OWNER TO telecom_user;
-- ddl-end --

-- object: telecom.plan | type: TABLE --
-- DROP TABLE IF EXISTS telecom.plan CASCADE;
CREATE TABLE telecom.plan (
	plan_id bigint NOT NULL,
	plan_name varchar(50),
	contract_type varchar(30),
	description varchar(500),
	is_active boolean,
	CONSTRAINT plan_pk PRIMARY KEY (plan_id)
);
-- ddl-end --
ALTER TABLE telecom.plan OWNER TO telecom_user;
-- ddl-end --

-- object: telecom.services | type: TABLE --
-- DROP TABLE IF EXISTS telecom.services CASCADE;
CREATE TABLE telecom.services (
	service_id bigint NOT NULL,
	service_name varchar(100),
	service_category varchar(50),
	description varchar(500),
	is_active boolean,
	CONSTRAINT services_pk PRIMARY KEY (service_id)
);
-- ddl-end --
ALTER TABLE telecom.services OWNER TO telecom_user;
-- ddl-end --

-- object: telecom.subscription_services | type: TABLE --
-- DROP TABLE IF EXISTS telecom.subscription_services CASCADE;
CREATE TABLE telecom.subscription_services (
	subscription_id bigint NOT NULL,
	service_id bigint NOT NULL,
	service_status varchar(20),
	activation_date date,
	deactivation_date date,
	subscription_id_subscription bigint,
	service_id_services bigint,
	CONSTRAINT subscription_services_pk PRIMARY KEY (subscription_id,service_id)
);
-- ddl-end --
ALTER TABLE telecom.subscription_services OWNER TO telecom_user;
-- ddl-end --

-- object: telecom.subscription_service_history | type: TABLE --
-- DROP TABLE IF EXISTS telecom.subscription_service_history CASCADE;
CREATE TABLE telecom.subscription_service_history (
	subscription_id_subscription bigint,
	history_id bigint NOT NULL,
	service_id bigint NOT NULL,
	old_status varchar(20),
	new_status varchar(20) NOT NULL,
	change_date timestamp NOT NULL,
	change_reason varchar(255),
	CONSTRAINT subscription_service_history_pk PRIMARY KEY (history_id)
);
-- ddl-end --
ALTER TABLE telecom.subscription_service_history OWNER TO telecom_user;
-- ddl-end --

-- object: customer_fk | type: CONSTRAINT --
-- ALTER TABLE telecom.subscription DROP CONSTRAINT IF EXISTS customer_fk CASCADE;
ALTER TABLE telecom.subscription ADD CONSTRAINT customer_fk FOREIGN KEY (customer_id_customer)
REFERENCES telecom.customer (customer_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: plan_fk | type: CONSTRAINT --
-- ALTER TABLE telecom.subscription DROP CONSTRAINT IF EXISTS plan_fk CASCADE;
ALTER TABLE telecom.subscription ADD CONSTRAINT plan_fk FOREIGN KEY (plan_id_plan)
REFERENCES telecom.plan (plan_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: subscription_fk | type: CONSTRAINT --
-- ALTER TABLE telecom.subscription_services DROP CONSTRAINT IF EXISTS subscription_fk CASCADE;
ALTER TABLE telecom.subscription_services ADD CONSTRAINT subscription_fk FOREIGN KEY (subscription_id_subscription)
REFERENCES telecom.subscription (subscription_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: services_fk | type: CONSTRAINT --
-- ALTER TABLE telecom.subscription_services DROP CONSTRAINT IF EXISTS services_fk CASCADE;
ALTER TABLE telecom.subscription_services ADD CONSTRAINT services_fk FOREIGN KEY (service_id_services)
REFERENCES telecom.services (service_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: subscription_fk | type: CONSTRAINT --
-- ALTER TABLE telecom.subscription_service_history DROP CONSTRAINT IF EXISTS subscription_fk CASCADE;
ALTER TABLE telecom.subscription_service_history ADD CONSTRAINT subscription_fk FOREIGN KEY (subscription_id_subscription)
REFERENCES telecom.subscription (subscription_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: telecom.service_plan | type: TABLE --
-- DROP TABLE IF EXISTS telecom.service_plan CASCADE;
CREATE TABLE telecom.service_plan (
	plan_id bigint NOT NULL,
	service_id bigint NOT NULL,
	is_included boolean NOT NULL,
	is_optional boolean NOT NULL,
	service_id_services bigint,
	plan_id_plan bigint,
	CONSTRAINT service_plan_pk PRIMARY KEY (plan_id,service_id)
);
-- ddl-end --
ALTER TABLE telecom.service_plan OWNER TO telecom_user;
-- ddl-end --

-- object: services_fk | type: CONSTRAINT --
-- ALTER TABLE telecom.service_plan DROP CONSTRAINT IF EXISTS services_fk CASCADE;
ALTER TABLE telecom.service_plan ADD CONSTRAINT services_fk FOREIGN KEY (service_id_services)
REFERENCES telecom.services (service_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: plan_fk | type: CONSTRAINT --
-- ALTER TABLE telecom.service_plan DROP CONSTRAINT IF EXISTS plan_fk CASCADE;
ALTER TABLE telecom.service_plan ADD CONSTRAINT plan_fk FOREIGN KEY (plan_id_plan)
REFERENCES telecom.plan (plan_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --


