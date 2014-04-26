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
-- Name: character_eigenschaften; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE character_eigenschaften (
    id integer NOT NULL,
    "character" integer NOT NULL,
    eigenschaft integer NOT NULL,
    base integer NOT NULL,
    modifier integer,
    zugekauft integer,
    note character varying(255)
);


--
-- Name: character_eigenschaften_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE character_eigenschaften_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: character_eigenschaften_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE character_eigenschaften_id_seq OWNED BY character_eigenschaften.id;


--
-- Name: characters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE characters (
    id integer NOT NULL,
    name character varying(64) NOT NULL,
    rasse character varying(32),
    kultur character varying(32),
    profession character varying(32),
    geschlecht character varying(16),
    grosse integer,
    gewicht integer,
    haarfarbe character varying(16),
    augenfarbe character varying(16),
    aussehen character varying(1024),
    alter integer
);


--
-- Name: characters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE characters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: characters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE characters_id_seq OWNED BY characters.id;


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
-- Name: vorteile; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE vorteile (
    id integer NOT NULL,
    name character varying(64) NOT NULL,
    vorteil boolean NOT NULL,
    gp integer,
    ap integer,
    effect character varying(256),
    description character varying(2048)
);


--
-- Name: vorteile_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE vorteile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vorteile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE vorteile_id_seq OWNED BY vorteile.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY character_eigenschaften ALTER COLUMN id SET DEFAULT nextval('character_eigenschaften_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY characters ALTER COLUMN id SET DEFAULT nextval('characters_id_seq'::regclass);


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
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY vorteile ALTER COLUMN id SET DEFAULT nextval('vorteile_id_seq'::regclass);


--
-- Data for Name: character_eigenschaften; Type: TABLE DATA; Schema: public; Owner: -
--

COPY character_eigenschaften (id, "character", eigenschaft, base, modifier, zugekauft, note) FROM stdin;
1	1	1	16	\N	8	\N
3	1	2	16	0	8	\N
4	1	5	15	0	4	\N
2	1	3	16	0	8	\N
5	1	6	13	0	2	\N
6	1	4	14	0	2	\N
7	1	7	11	0	6	\N
8	1	8	12	0	3	\N
\.


--
-- Name: character_eigenschaften_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('character_eigenschaften_id_seq', 8, true);


--
-- Data for Name: characters; Type: TABLE DATA; Schema: public; Owner: -
--

COPY characters (id, name, rasse, kultur, profession, geschlecht, grosse, gewicht, haarfarbe, augenfarbe, aussehen, alter) FROM stdin;
1	Cyrotherias	Imperialer Mensch	Cantaresen	Optimat (Wesenbeschwörer)	Male	166	61	Black	Grau	\N	22
2	Phronna	Imperialer Mensch	Cantaresen	Dancer	Weiblich	\N	\N	Black	\N	Test	22
3	RiUa	Amaunir	Stadt- Amaunir	BaLoa	Female	178	66	Black	Green	Golden fur with black tiger stripes at the sides and over bottom length tail	18
\.


--
-- Name: characters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('characters_id_seq', 3, true);


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
-- Data for Name: vorteile; Type: TABLE DATA; Schema: public; Owner: -
--

COPY vorteile (id, name, vorteil, gp, ap, effect, description) FROM stdin;
\.


--
-- Name: vorteile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('vorteile_id_seq', 1, false);


--
-- Name: character_eigenschaften_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY character_eigenschaften
    ADD CONSTRAINT character_eigenschaften_pkey PRIMARY KEY (id);


--
-- Name: characters_name_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY characters
    ADD CONSTRAINT characters_name_key UNIQUE (name);


--
-- Name: characters_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY characters
    ADD CONSTRAINT characters_pkey PRIMARY KEY (id);


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
-- Name: vorteile_name_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY vorteile
    ADD CONSTRAINT vorteile_name_key UNIQUE (name);


--
-- Name: vorteile_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY vorteile
    ADD CONSTRAINT vorteile_pkey PRIMARY KEY (id);


--
-- Name: character_eigenschaften_character_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY character_eigenschaften
    ADD CONSTRAINT character_eigenschaften_character_fkey FOREIGN KEY ("character") REFERENCES characters(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: character_eigenschaften_eigenschaft_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY character_eigenschaften
    ADD CONSTRAINT character_eigenschaften_eigenschaft_fkey FOREIGN KEY (eigenschaft) REFERENCES traits(id) ON UPDATE CASCADE ON DELETE CASCADE;


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
-- Name: character_eigenschaften; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE character_eigenschaften FROM PUBLIC;
REVOKE ALL ON TABLE character_eigenschaften FROM andre;
GRANT ALL ON TABLE character_eigenschaften TO andre;
GRANT ALL ON TABLE character_eigenschaften TO nginx;


--
-- Name: character_eigenschaften_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE character_eigenschaften_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE character_eigenschaften_id_seq FROM andre;
GRANT ALL ON SEQUENCE character_eigenschaften_id_seq TO andre;
GRANT ALL ON SEQUENCE character_eigenschaften_id_seq TO nginx;


--
-- Name: characters; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE characters FROM PUBLIC;
REVOKE ALL ON TABLE characters FROM andre;
GRANT ALL ON TABLE characters TO andre;
GRANT ALL ON TABLE characters TO nginx;


--
-- Name: characters_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE characters_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE characters_id_seq FROM andre;
GRANT ALL ON SEQUENCE characters_id_seq TO andre;
GRANT ALL ON SEQUENCE characters_id_seq TO nginx;


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
-- Name: vorteile; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE vorteile FROM PUBLIC;
REVOKE ALL ON TABLE vorteile FROM andre;
GRANT ALL ON TABLE vorteile TO andre;
GRANT ALL ON TABLE vorteile TO nginx;


--
-- Name: vorteile_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE vorteile_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE vorteile_id_seq FROM andre;
GRANT ALL ON SEQUENCE vorteile_id_seq TO andre;
GRANT ALL ON SEQUENCE vorteile_id_seq TO nginx;


--
-- PostgreSQL database dump complete
--

