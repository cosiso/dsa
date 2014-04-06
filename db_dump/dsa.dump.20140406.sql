--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: talente; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE talente (
    id integer NOT NULL,
    name character varying(30) NOT NULL,
    be character varying(16),
    komp character varying(16),
    eigenschaft1 integer NOT NULL,
    eigenschaft2 integer NOT NULL,
    eigenschaft3 integer NOT NULL,
    category integer NOT NULL,
    skt character(1) NOT NULL
);


--
-- Name: talente_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE talente_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: talente_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE talente_id_seq OWNED BY talente.id;


--
-- Name: talenten_cat; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE talenten_cat (
    id integer NOT NULL,
    name character varying(32) NOT NULL,
    default_skt character(1)
);


--
-- Name: talenten_cat_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE talenten_cat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: talenten_cat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE talenten_cat_id_seq OWNED BY talenten_cat.id;


--
-- Name: traits; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE traits (
    id integer NOT NULL,
    name character varying(20),
    abbr character(2)
);


--
-- Name: traits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE traits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: traits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE traits_id_seq OWNED BY traits.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY talente ALTER COLUMN id SET DEFAULT nextval('talente_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY talenten_cat ALTER COLUMN id SET DEFAULT nextval('talenten_cat_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY traits ALTER COLUMN id SET DEFAULT nextval('traits_id_seq'::regclass);


--
-- Data for Name: talente; Type: TABLE DATA; Schema: public; Owner: -
--

COPY talente (id, name, be, komp, eigenschaft1, eigenschaft2, eigenschaft3, category, skt) FROM stdin;
\.


--
-- Name: talente_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('talente_id_seq', 1, false);


--
-- Data for Name: talenten_cat; Type: TABLE DATA; Schema: public; Owner: -
--

COPY talenten_cat (id, name, default_skt) FROM stdin;
3	Gesellschaftliche Talente	B
2	Körperliche Talente	D
1	Kampftechniken	D
6	Natur-Talente	B
7	Wissenstalente	B
8	Sprachen & Schriften	A
9	Handwerkliche Talente	B
\.


--
-- Name: talenten_cat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('talenten_cat_id_seq', 9, true);


--
-- Data for Name: traits; Type: TABLE DATA; Schema: public; Owner: -
--

COPY traits (id, name, abbr) FROM stdin;
1	Mut	MU
3	Charisma	CH
5	Intuition	IN
6	Fingerfertigkeit	FF
7	Konstitution	KO
8	Körperkraft	KK
2	Klugheit	KL
4	Gewandtheit	GE
\.


--
-- Name: traits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('traits_id_seq', 25, true);


--
-- Name: talente_name_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY talente
    ADD CONSTRAINT talente_name_key UNIQUE (name);


--
-- Name: talente_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY talente
    ADD CONSTRAINT talente_pkey PRIMARY KEY (id);


--
-- Name: talenten_cat_name_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY talenten_cat
    ADD CONSTRAINT talenten_cat_name_key UNIQUE (name);


--
-- Name: talenten_cat_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY talenten_cat
    ADD CONSTRAINT talenten_cat_pkey PRIMARY KEY (id);


--
-- Name: traits_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY traits
    ADD CONSTRAINT traits_pkey PRIMARY KEY (id);


--
-- Name: talente_category_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY talente
    ADD CONSTRAINT talente_category_fkey FOREIGN KEY (category) REFERENCES talenten_cat(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: talente_eigenschaft1_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY talente
    ADD CONSTRAINT talente_eigenschaft1_fkey FOREIGN KEY (eigenschaft1) REFERENCES traits(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: talente_eigenschaft2_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY talente
    ADD CONSTRAINT talente_eigenschaft2_fkey FOREIGN KEY (eigenschaft2) REFERENCES traits(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: talente_eigenschaft3_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY talente
    ADD CONSTRAINT talente_eigenschaft3_fkey FOREIGN KEY (eigenschaft3) REFERENCES traits(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: public; Type: ACL; Schema: -; Owner: -
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: talente; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE talente FROM PUBLIC;
REVOKE ALL ON TABLE talente FROM andre;
GRANT ALL ON TABLE talente TO andre;
GRANT ALL ON TABLE talente TO nginx;


--
-- Name: talente_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE talente_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE talente_id_seq FROM andre;
GRANT ALL ON SEQUENCE talente_id_seq TO andre;
GRANT ALL ON SEQUENCE talente_id_seq TO nginx;


--
-- Name: talenten_cat; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE talenten_cat FROM PUBLIC;
REVOKE ALL ON TABLE talenten_cat FROM andre;
GRANT ALL ON TABLE talenten_cat TO andre;
GRANT ALL ON TABLE talenten_cat TO nginx;


--
-- Name: talenten_cat_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE talenten_cat_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE talenten_cat_id_seq FROM andre;
GRANT ALL ON SEQUENCE talenten_cat_id_seq TO andre;
GRANT ALL ON SEQUENCE talenten_cat_id_seq TO nginx;


--
-- Name: traits; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE traits FROM PUBLIC;
REVOKE ALL ON TABLE traits FROM andre;
GRANT ALL ON TABLE traits TO andre;
GRANT ALL ON TABLE traits TO nginx;


--
-- Name: traits_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE traits_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE traits_id_seq FROM andre;
GRANT ALL ON SEQUENCE traits_id_seq TO andre;
GRANT ALL ON SEQUENCE traits_id_seq TO nginx;


--
-- PostgreSQL database dump complete
--

