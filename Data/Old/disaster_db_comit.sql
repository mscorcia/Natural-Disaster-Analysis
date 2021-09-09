BEGIN;


CREATE TABLE public."FPIS"
(
    "FIPS_ID" integer NOT NULL,
    "NAME" character varying NOT NULL,
    PRIMARY KEY ("FIPS_ID")
);

CREATE TABLE public."USDisaster"
(
    fema_declaration character varying NOT NULL,
    disaster_number integer NOT NULL,
    state character varying(2) NOT NULL,
    declaration_type character varying NOT NULL,
    declaration_date date NOT NULL,
    fy_declared integer NOT NULL,
    incident_type character varying NOT NULL,
    declaration_title character varying NOT NULL,
    ih_program_declared integer NOT NULL,
    ia_program_declared integer NOT NULL,
    pa_program_declared integer NOT NULL,
    hm_program_declared integer NOT NULL,
    incident_begin_date date NOT NULL,
    fips integer NOT NULL,
    place_code character varying NOT NULL,
    designated_area character varying NOT NULL,
    declaration_request_number integer NOT NULL,
    hash character varying NOT NULL,
    last_refresh date NOT NULL,
    id character varying NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE public."USStates"
(
    "PostalAbreviation" character varying(2) NOT NULL,
    "StateDescription" character varying NOT NULL,
    PRIMARY KEY ("PostalAbreviation")
);

ALTER TABLE public."USDisaster"
    ADD FOREIGN KEY (state)
    REFERENCES public."USStates" ("PostalAbreviation")
    NOT VALID;


ALTER TABLE public."FPIS"
    ADD FOREIGN KEY ("FIPS_ID")
    REFERENCES public."USDisaster" (fips)
    NOT VALID;

END;