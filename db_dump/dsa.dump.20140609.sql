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

--
-- Name: calc_at(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION calc_at(cid integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
   DECLARE
      my_at INT;
   BEGIN
      SELECT ROUND((calc_mu(cid) + calc_ge(cid) + calc_kk(cid)) / 5.0) INTO my_at;
      RETURN my_at;
   END;
$$;


--
-- Name: calc_ch(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION calc_ch(cid integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
   DECLARE
      ch INT;
   BEGIN
      SELECT COALESCE(base, 0) + COALESCE(modifier, 0) + COALESCE(zugekauft, 0) INTO ch
      FROM   character_eigenschaften, traits
      WHERE  character = cid AND
             traits.id = character_eigenschaften.eigenschaft AND
             traits.abbr = 'CH';
      RETURN ch;
   END;
$$;


--
-- Name: calc_ff(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION calc_ff(cid integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
   DECLARE
      ff INT;
   BEGIN
      SELECT COALESCE(base, 0) + COALESCE(modifier, 0) + COALESCE(zugekauft, 0) INTO ff
      FROM   character_eigenschaften, traits
      WHERE  character = cid AND
             traits.id = character_eigenschaften.eigenschaft AND
             traits.abbr = 'FF';
      RETURN ff;
   END;
$$;


--
-- Name: calc_ge(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION calc_ge(cid integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
   DECLARE
      ge INT;
   BEGIN
      SELECT COALESCE(base, 0) + COALESCE(modifier, 0) + COALESCE(zugekauft, 0) INTO ge
      FROM   character_eigenschaften, traits
      WHERE  character = cid AND
             traits.id = character_eigenschaften.eigenschaft AND
             traits.abbr = 'GE';
      RETURN ge;
   END;
$$;


--
-- Name: calc_in(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION calc_in(cid integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
   DECLARE
      mu INT;
   BEGIN
      SELECT COALESCE(base, 0) + COALESCE(modifier, 0) + COALESCE(zugekauft, 0) INTO mu
      FROM   character_eigenschaften, traits
      WHERE  character = cid AND
             traits.id = character_eigenschaften.eigenschaft AND
             traits.abbr = 'IN';
      RETURN mu;
   END;
$$;


--
-- Name: calc_ini(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION calc_ini(cid integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
   DECLARE
      my_ini INT;
   BEGIN
      SELECT ROUND( (calc_mu(cid) * 2 + calc_in(cid) + calc_ge(cid)) / 5.0 ) INTO my_ini;
      RETURN my_ini;
   END;
$$;


--
-- Name: calc_kk(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION calc_kk(cid integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
   DECLARE
      kk INT;
   BEGIN
      SELECT COALESCE(base, 0) + COALESCE(modifier, 0) + COALESCE(zugekauft, 0) INTO kk
      FROM   character_eigenschaften, traits
      WHERE  character = cid AND
             traits.id = character_eigenschaften.eigenschaft AND
             traits.abbr = 'KK';
      RETURN kk;
   END;
$$;


--
-- Name: calc_kl(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION calc_kl(cid integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
   DECLARE
      kl INT;
   BEGIN
      SELECT COALESCE(base, 0) + COALESCE(modifier, 0) + COALESCE(zugekauft, 0) INTO kl
      FROM   character_eigenschaften, traits
      WHERE  character = cid AND
             traits.id = character_eigenschaften.eigenschaft AND
             traits.abbr = 'KL';
      RETURN kl;
   END;
$$;


--
-- Name: calc_ko(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION calc_ko(cid integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
   DECLARE
      ko INT;
   BEGIN
      SELECT COALESCE(base, 0) + COALESCE(modifier, 0) + COALESCE(zugekauft, 0) INTO ko
      FROM   character_eigenschaften, traits
      WHERE  character = cid AND
             traits.id = character_eigenschaften.eigenschaft AND
             traits.abbr = 'KO';
      RETURN ko;
   END;
$$;


--
-- Name: calc_mu(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION calc_mu(cid integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
   DECLARE
      mu INT;
   BEGIN
      SELECT COALESCE(base, 0) + COALESCE(modifier, 0) + COALESCE(zugekauft, 0) INTO mu
      FROM   character_eigenschaften, traits
      WHERE  character = cid AND
             traits.id = character_eigenschaften.eigenschaft AND
             traits.abbr = 'MU';
      RETURN mu;
   END;
$$;


--
-- Name: calc_pa(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION calc_pa(cid integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
   DECLARE
      my_pa INT;
   BEGIN
      SELECT ROUND((calc_in(cid) + calc_ge(cid) + calc_kk(cid)) / 5.0) INTO my_pa;
      RETURN my_pa;
   END;
$$;


--
-- Name: kk_bonus(integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION kk_bonus(cid integer, tpkk character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
   DECLARE
      my_kk INT;
      start INT;
      step  INT;
      bonus INT;
   BEGIN
      start = split_part(tpkk, '/', 1);
      step  = split_part(tpkk, '/', 2);
      bonus = 0;
      SELECT calc_kk(cid) - start INTO my_kk;
      WHILE my_kk >= step LOOP
         bonus = bonus + 1;
         my_kk = my_kk - step;
      END LOOP;
      RETURN bonus;
   END;
$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: basevalues; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE basevalues (
    id integer NOT NULL,
    character_id integer NOT NULL,
    le_used integer,
    le_mod integer,
    le_bought integer,
    au_used integer,
    au_mod integer,
    au_bought integer,
    ae_used integer,
    ae_mod integer,
    ae_bought integer,
    mr_used integer,
    mr_mod integer,
    mr_bought integer,
    ini_mod integer,
    at_mod integer,
    pa_mod integer,
    fk_mod integer
);


--
-- Name: basevalues_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE basevalues_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: basevalues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE basevalues_id_seq OWNED BY basevalues.id;


--
-- Name: char_kampftechniken; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE char_kampftechniken (
    id integer NOT NULL,
    kampftechnik_id integer NOT NULL,
    at integer DEFAULT 0 NOT NULL,
    pa integer DEFAULT 0 NOT NULL,
    character_id integer NOT NULL
);


--
-- Name: char_kampftechniken_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE char_kampftechniken_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: char_kampftechniken_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE char_kampftechniken_id_seq OWNED BY char_kampftechniken.id;


--
-- Name: char_vorteile; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE char_vorteile (
    id integer NOT NULL,
    character_id integer NOT NULL,
    vorteil_id integer NOT NULL,
    note character varying(1024),
    value integer
);


--
-- Name: char_vorteile_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE char_vorteile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: char_vorteile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE char_vorteile_id_seq OWNED BY char_vorteile.id;


--
-- Name: char_weapons; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE char_weapons (
    id integer NOT NULL,
    character_id integer NOT NULL,
    weapon_id integer NOT NULL,
    ini integer DEFAULT 0,
    wm character varying(8),
    at integer DEFAULT 0,
    pa integer DEFAULT 0,
    bf integer DEFAULT 0,
    tpkk character varying(8),
    note character varying(4096),
    tp character varying(8)
);


--
-- Name: char_weapons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE char_weapons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: char_weapons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE char_weapons_id_seq OWNED BY char_weapons.id;


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
    alter integer,
    ap integer
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
-- Name: kampftechniken; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE kampftechniken (
    id integer NOT NULL,
    name character varying(32) NOT NULL,
    be integer,
    skt character(1),
    unarmed boolean DEFAULT false
);


--
-- Name: kampftechniken_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE kampftechniken_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: kampftechniken_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE kampftechniken_id_seq OWNED BY kampftechniken.id;


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
-- Name: weapons; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE weapons (
    id integer NOT NULL,
    tp character varying(8) NOT NULL,
    tpkk character varying(8) NOT NULL,
    gewicht integer,
    lange integer,
    bf integer DEFAULT 0 NOT NULL,
    ini integer DEFAULT 0 NOT NULL,
    preis integer,
    wm character varying(8) DEFAULT '0/0'::character varying NOT NULL,
    dk character varying(8),
    kampftechnik_id integer NOT NULL,
    name character varying(32) NOT NULL,
    note character varying(4096)
);


--
-- Name: weapons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE weapons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: weapons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE weapons_id_seq OWNED BY weapons.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY basevalues ALTER COLUMN id SET DEFAULT nextval('basevalues_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY char_kampftechniken ALTER COLUMN id SET DEFAULT nextval('char_kampftechniken_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY char_vorteile ALTER COLUMN id SET DEFAULT nextval('char_vorteile_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY char_weapons ALTER COLUMN id SET DEFAULT nextval('char_weapons_id_seq'::regclass);


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

ALTER TABLE ONLY kampftechniken ALTER COLUMN id SET DEFAULT nextval('kampftechniken_id_seq'::regclass);


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
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY weapons ALTER COLUMN id SET DEFAULT nextval('weapons_id_seq'::regclass);


--
-- Data for Name: basevalues; Type: TABLE DATA; Schema: public; Owner: -
--

COPY basevalues (id, character_id, le_used, le_mod, le_bought, au_used, au_mod, au_bought, ae_used, ae_mod, ae_bought, mr_used, mr_mod, mr_bought, ini_mod, at_mod, pa_mod, fk_mod) FROM stdin;
1	1	\N	15	3	\N	10	\N	\N	97	10	\N	5	4	0	0	0	0
\.


--
-- Name: basevalues_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('basevalues_id_seq', 1, true);


--
-- Data for Name: char_kampftechniken; Type: TABLE DATA; Schema: public; Owner: -
--

COPY char_kampftechniken (id, kampftechnik_id, at, pa, character_id) FROM stdin;
20	15	8	13	1
33	13	1	0	1
26	12	0	0	1
36	9	0	0	1
38	11	0	0	2
37	10	1	0	2
17	4	6	4	1
35	11	0	0	1
19	10	1	1	1
32	14	11	7	1
\.


--
-- Name: char_kampftechniken_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('char_kampftechniken_id_seq', 38, true);


--
-- Data for Name: char_vorteile; Type: TABLE DATA; Schema: public; Owner: -
--

COPY char_vorteile (id, character_id, vorteil_id, note, value) FROM stdin;
4	1	1	\N	\N
1	1	2	\N	\N
16	1	3	2	1
17	3	1	\N	\N
18	3	9	\N	\N
19	1	10	\N	\N
\.


--
-- Name: char_vorteile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('char_vorteile_id_seq', 21, true);


--
-- Data for Name: char_weapons; Type: TABLE DATA; Schema: public; Owner: -
--

COPY char_weapons (id, character_id, weapon_id, ini, wm, at, pa, bf, tpkk, note, tp) FROM stdin;
1	1	1	0	\N	0	0	0	\N	\N	\N
\.


--
-- Name: char_weapons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('char_weapons_id_seq', 1, true);


--
-- Data for Name: character_eigenschaften; Type: TABLE DATA; Schema: public; Owner: -
--

COPY character_eigenschaften (id, "character", eigenschaft, base, modifier, zugekauft, note) FROM stdin;
1	1	1	16	\N	8	\N
3	1	2	16	0	8	\N
7	1	7	11	0	6	\N
9	3	3	16	1	8	\N
8	1	8	12	0	3	\N
10	3	4	16	1	8	\N
11	3	5	16	0	8	\N
12	3	2	13	0	7	\N
13	3	7	14	0	7	\N
14	3	8	16	0	8	\N
15	3	1	15	0	8	\N
16	3	6	9	0	5	\N
2	1	3	16	0	8	\N
5	1	6	13	0	2	\N
17	2	3	5	0	0	\N
18	2	6	5	0	0	\N
19	2	4	5	0	0	\N
20	2	5	5	0	0	\N
21	2	2	5	0	0	\N
22	2	7	5	0	0	\N
23	2	8	5	0	0	\N
24	2	1	5	0	0	\N
4	1	5	15	0	4	\N
6	1	4	14	0	2	\N
\.


--
-- Name: character_eigenschaften_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('character_eigenschaften_id_seq', 24, true);


--
-- Data for Name: characters; Type: TABLE DATA; Schema: public; Owner: -
--

COPY characters (id, name, rasse, kultur, profession, geschlecht, grosse, gewicht, haarfarbe, augenfarbe, aussehen, alter, ap) FROM stdin;
2	Phronna	Imperialer Mensch	Cantaresen	Dancer	Weiblich	\N	\N	Black	\N	Test	22	\N
3	RiUa	Amaunir	Stadt- Amaunir	BaLoa	Female	178	66	Black	Green	Golden fur with black tiger stripes at the sides and over bottom length tail	18	\N
1	Cyrotherias	Imperialer Mensch	Cantaresen	Optimat (Wesenbeschwörer)	Male	166	61	Black	Grau	\N	22	77
\.


--
-- Name: characters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('characters_id_seq', 8, true);


--
-- Data for Name: kampftechniken; Type: TABLE DATA; Schema: public; Owner: -
--

COPY kampftechniken (id, name, be, skt, unarmed) FROM stdin;
4	Dolche	-1	D	f
12	Säbel	-2	D	f
13	Wurfmesser	-3	C	f
14	Speere	-2	D	f
15	Stäbe	-2	D	f
10	Raufen	0	C	t
11	Ringen	0	D	t
9	Hiebwaffen	-4	D	f
\.


--
-- Name: kampftechniken_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('kampftechniken_id_seq', 15, true);


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
3	Verpflichtungen	f	12	\N	Variable	Myranische Helden haben oftmals Verpflichtungen gegenüber ihrem Cirkel oder einem bestimmten Optimatenhaus. Ebenso haben Sklaven selbstredend Verpflichtungen gegenüber ihren Herren.\n\nAnsonsten siehe AH 117.
11	Kampfgespür	t	\N	300	INI + 2	Ein Kämpfer mit Kampfgespür bewegt sich mit schier traumwandlerischer Sicherheit über das Kampffeld: Sein Initiative-Basiswert steigt um 2 Punkte (zusätzlich zu den 4 Punkten aus der Sonderfertigkeit Kampfreflexe), und ein Passierschlag gegen ihn ist um 2 Punkte erschwert (zusätzlich zu den 4 Punkten aus Aufmerksamkeit und den normalen 4 Punkten; Seite 83).\n\nEr kann jederzeit Aktionen in Reaktionen umwandeln und umgekehrt, ohne dies vorher ankündigen zu müssen - die Probenerschwernis von 4 Punkten gilt jedoch auch für ihn. Außerdem ist seine IN-Probe, um zu verhindern, dass er überrascht wird (WdS, Seite 78), um 4 Punkte erleichtert (ebenfalls zusätzlich zu den 4 Punkten aus Aufmerksamkeit).\n\nEin Kämpfer, der diese Fähigkeit mit den Sonderfertigkeiten Klingensturm (WdS, Seite 75) oder Klingenwand (ebenfalls WdS, Seite 75) kombiniert, ist zudem in der Lage, seinen AT- oder PA-Wert nach Belieben aufzuspalten, anstatt ihn jeweils zu halbieren.\n\nVoraussetzungen: IN 15; SF Aufmerksamkeit und Kampfreflexe\nVerbreitung: 3, bei erfahren en Einzelkämpfern
2	Optimat	t	10	\N	Besonderer Besitz: 3GP, SO +2	Der Held entstammt einer alten Familie des Imperiums und ist für eine höhere Karriere vorgesehen; er hat Anspruch auf den Titel Exzellenz und unterliegt in vielen Bereichen nicht mehr der gewöhnlichen Gerichtsbarkeit.\n\nUm Optimat zu sein, muss man einen Sozialstatus von mindestens 8 aufweisen. Magier müssen einem Optimatenhaus entstammen bzw. sie werden im Zuge ihrer Ausbildung zu Optimaten gemacht.\n\nDieser Vorteil verbilligt den Vorteil Besonderer Besitz auf 3 GP und bringt gleichzeitig einen SO-Bonus von 2 Punkten.
9	RiUa	t	\N	\N	IMBA	You are the char of the GM, you have unlimited luck and the eternal support of fate^^
1	Vollzauberer	t	15	\N	Gives (MU + IN + CH)/2 + 18 AsP and all (dis-) advantages coming with it.	Der Held besitzt in vollem Umfang magische Kräfte und hat im Rahmen seiner Kultur oder Profession (meist Magier eines Optimatenhauses) eine längerfristige magische Ausbildung hinter sich gebracht, die ihm ermöglicht, bestimmte Instruktionen und Matrizen (nach Profession beziehungsweise zugehörigem Haus) zu erlernen und anzuwenden.\nEr verfügt über (MU + IN + CH)/2 (aufgerundet) AsP + 18AsP sowie eventuell weitere Vor- und Nachteile. Darüber hinaus beherrscht er die für seine Ausbildung typischen Instruktionen und Quellen, seine traditions-abhängige Ritualkenntnis sowie einige magische Sonderfertigkeiten (vornehmlich Stabzauber).\nDie jeweiligen Boni auf bestimmte Talente, Instruktionen, Domänen und Matrizen sowie Grundwerte wie etwa Magieresistenz finden Sie in der Beschreibung des gewählten Optimatenhauses (Seite 22ff.) beziehungsweise in den Beschreibungen der sonstigen Vollzauberer-Traditionen (die wir für Folgepublikation planen).\nEin Held, der Vollzauberer gewählt hat, kann nicht gleichzeitig Halb- oder Viertelzauberer sein.\n\nExpertenanmerkung für Selbstgestalter: Dieser Vorteil beinhaltet 120 VP; siehe auch Seite 197.
10	Gefäß der Sterne	t	\N	250	AE = (MU + IN + CH + CH) / 5	Der Zauberer ist in der Lage, das 'Gefäß', das die Astralkraft aufnimmt, zu vergrößern, d.h., er ist in der Lage, mehr permanente AE speichern, er wird 'strahlender'.\n\nIn die Berechnung der AE-Basis geht der Charisma-Wert doppelt ein d.h. (MU + IN + CH + CH)/5. Wenn er in der Lage ist, die Große Meditation zu vollführen, kann er hierbei auf Wunsch auch Charisma als Leiteigenschaft wählen (anstatt KL oder IN) und so CH/3 plus RkP*/10 aus einer (MU/CH/CH)-Probe auf die Ritualkenntnis als AsP hinzugewinnen. Zudem ist er nicht mehr gezwungen, für die Große Meditation mehr gezwungen, für die Große Meditation das Ritual durchführen, wo es ihm beliebt.\n\nDruiden, Geoden und Hexen sehen die Zauberkraft als 'Erdkraft', weswegen diese SF bei ihnen als 'Sumus Fülle' bekannt ist.\n\nVoraussetzungen: CH 15, IN 13\nVerbreitung: 3
12	Kampfreflexe	t	\N	300	INI + 4	Ein Kämpfer mit dieser Fähigkeit hat einen um 4 Punkte erhöhten Initiative-Wert und ist daher im Kampf häufig als erster an der Reihe.\nDiese Fähigkeit kommt nur dann zum Tragen, wenn der Kämpfer eine Rüstung mit einer BE von maximal 4 trägt (Rüstungsgewöhnung gilt).\n\nVoraussetzungen: INI-Basiswert 10\nVerbreitung: 4, professionelle Kämpfer
\.


--
-- Name: vorteile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('vorteile_id_seq', 12, true);


--
-- Data for Name: weapons; Type: TABLE DATA; Schema: public; Owner: -
--

COPY weapons (id, tp, tpkk, gewicht, lange, bf, ini, preis, wm, dk, kampftechnik_id, name, note) FROM stdin;
1	1D6+1	12/5	20	30	2	0	10	0/-1	H	4	Dolch	Besonderheiten: Mit einem Dolch können die Schläge von Kettenwaffen, Zweihandhiebwaffen (und Zweihandschwertern und -säbeln) nicht pariert werden. Ein Dolch lässt sich auch improvisiert werfen.\n\nWaffenmeisterschaft: Ein Waffenmeister (Dolch) kann diese Waffe als reguläre, nicht improvisierte Wurfwaffe verwenden. Außerdem hat er einen INI-Wert von +1 und seine TP/KK beträgt 11/4. Bei einem Gezielten Stich kann er den Probenzuschlag durch den RS des Gegners ignorieren.\n\nHerkunft: (18) ANTH, CANT, CENT, CORA, CRAN, DEME, GATH, GYLD, HALD, HARP, KARO, KORO, MAKS, MAYE, NARI, OCHO, SERO, SEVA, SHIN, TALA, THAR, VALA\n\nIn Myranor ist der alltägliche Dolch eine fast universelle Zweitwaffe (oder Reservewaffe) aller Kämpfer und bei vielen anderen Leuten auch als Hauptwaffe zu sehen. Neben der Scheide am Gürtel ist eine Halterung am oder im Stiefel oder auf eine Scheide auf Kniehöhe am obersten Sandalenriemen oft zu sehen, von einfallsreicheren Verstecken ganz zu schweigen. Dabei gibt es Dolche für alle sozialen Schichten - ein entflohener Sklave mag sich ebenso mit einem kurzen und leicht zu verbergenden Dolch ausrüsten wie ein Honorat, der mit dieser leichten und kleinen (und dann oft edel verzierten) Waffe demonstriert, dass er fast überall bewaffnet einhergehen darf, ohne sich groß zu belasten.\nDie meisten Dolche sind etwa einen Spann lang und beidseitig geschärft, als (eher notdürftige) Parierhilfen dienen eine meist recht kleine Stange oder Scheibe zwischen Klinge und Griff.
2	1D6+1	13/3	90	140	5	0	10	0/-1	S	14	Dreizack	
4	1D6+10	12/5	60	35	-8	4	8000	3/3	HN	4	Schatten Tanz (Drepani)	Persöhnliche waffen: \nNamen: Schatten Tanz\nZwei Drepani aus Flammstahl, wo Titanium (Silbern, reflektiert oranges Licht) mit Endurium verschmieded wurden. Die drepani haben anstelle eines zweiten Griffs and der spitze eine Dünne klinge die zum stechen verwended werden kann während die Hauptklinge am arm anliegt.\nShatten hat auf den Endurium Stellen bilder von schleichenden und jagenden Amaunir eingraviert\nTanz hat auf den Titanium Stellen bilder eingraviert, die eine Amaunir im Tanz darstellen.\n\n\nUnzerstörbar, Magisch
5	1D6+10	12/5	60	35	-8	4	8000	3/3	HN	9	Schatten Tanz (Hiebwaffen)	Persöhnliche waffen: \nNamen: Schatten Tanz\nZwei Drepani aus Flammstahl, wo Titanium (Silbern, reflektiert oranges Licht) mit Endurium verschmieded wurden. Die drepani haben anstelle eines zweiten Griffs and der spitze eine Dünne klinge die zum stechen verwended werden kann während die Hauptklinge am arm anliegt.\nShatten hat auf den Endurium Stellen bilder von schleichenden und jagenden Amaunir eingraviert\nTanz hat auf den Titanium Stellen bilder eingraviert, die eine Amaunir im Tanz darstellen.\n\n\nUnzerstörbar, Magisch
6	1D6+10	12/5	60	35	-8	4	4000	3/5	HN	4	Tanz (Parierwaffe, Drepanos)	Persöhnliche waffe: \r\nName: Tanz\r\nEin Drepanos aus Flammstahl, wo Titanium (Silbern, reflektiert oranges Licht) mit Endurium verschmieded wurden. Das Drepanos hat anstelle eines zweiten Griffs an der spitze eine Dünne klinge die zum stechen verwendet werden kann während die Hauptklinge am arm anliegt.\r\nTanz hat auf den Titanium Stellen bilder eingraviert, die eine Amaunir im Tanz darstellen.\r\n\r\n\r\nUnzerstörbar, Magisch
\.


--
-- Name: weapons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('weapons_id_seq', 8, true);


--
-- Name: basevalues_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY basevalues
    ADD CONSTRAINT basevalues_pkey PRIMARY KEY (id);


--
-- Name: char_kampftechniken_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY char_kampftechniken
    ADD CONSTRAINT char_kampftechniken_pkey PRIMARY KEY (id);


--
-- Name: char_vorteile_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY char_vorteile
    ADD CONSTRAINT char_vorteile_pkey PRIMARY KEY (id);


--
-- Name: char_weapons_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY char_weapons
    ADD CONSTRAINT char_weapons_pkey PRIMARY KEY (id);


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
-- Name: kampftechniken_name_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY kampftechniken
    ADD CONSTRAINT kampftechniken_name_key UNIQUE (name);


--
-- Name: kampftechniken_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY kampftechniken
    ADD CONSTRAINT kampftechniken_pkey PRIMARY KEY (id);


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
-- Name: weapons_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY weapons
    ADD CONSTRAINT weapons_pkey PRIMARY KEY (id);


--
-- Name: basevalues_character_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX basevalues_character_id_idx ON basevalues USING btree (character_id);


--
-- Name: char_kampftechniken_character_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX char_kampftechniken_character_id_idx ON char_kampftechniken USING btree (character_id);


--
-- Name: char_kampftechniken_kampftechnik_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX char_kampftechniken_kampftechnik_id_idx ON char_kampftechniken USING btree (kampftechnik_id);


--
-- Name: char_vorteile_character_id_vorteil_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX char_vorteile_character_id_vorteil_id_idx ON char_vorteile USING btree (character_id, vorteil_id);


--
-- Name: char_weapons_character_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX char_weapons_character_id_idx ON char_weapons USING btree (character_id);


--
-- Name: talente_category_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX talente_category_idx ON talente USING btree (category);


--
-- Name: weapons_name_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX weapons_name_idx ON weapons USING btree (name);


--
-- Name: basevalues_character_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY basevalues
    ADD CONSTRAINT basevalues_character_id_fkey FOREIGN KEY (character_id) REFERENCES characters(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: char_kampftechniken_character_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY char_kampftechniken
    ADD CONSTRAINT char_kampftechniken_character_id_fkey FOREIGN KEY (character_id) REFERENCES characters(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: char_kampftechniken_kampftechnik_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY char_kampftechniken
    ADD CONSTRAINT char_kampftechniken_kampftechnik_id_fkey FOREIGN KEY (kampftechnik_id) REFERENCES kampftechniken(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: char_vorteile_character_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY char_vorteile
    ADD CONSTRAINT char_vorteile_character_id_fkey FOREIGN KEY (character_id) REFERENCES characters(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: char_vorteile_vorteil_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY char_vorteile
    ADD CONSTRAINT char_vorteile_vorteil_id_fkey FOREIGN KEY (vorteil_id) REFERENCES vorteile(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: char_weapons_character_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY char_weapons
    ADD CONSTRAINT char_weapons_character_id_fkey FOREIGN KEY (character_id) REFERENCES characters(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: char_weapons_weapon_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY char_weapons
    ADD CONSTRAINT char_weapons_weapon_id_fkey FOREIGN KEY (weapon_id) REFERENCES weapons(id) ON UPDATE CASCADE ON DELETE CASCADE;


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
-- Name: weapons_kampftechnik_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY weapons
    ADD CONSTRAINT weapons_kampftechnik_id_fkey FOREIGN KEY (kampftechnik_id) REFERENCES kampftechniken(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: -
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: basevalues; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE basevalues FROM PUBLIC;
REVOKE ALL ON TABLE basevalues FROM andre;
GRANT ALL ON TABLE basevalues TO andre;
GRANT ALL ON TABLE basevalues TO nginx;


--
-- Name: basevalues_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE basevalues_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE basevalues_id_seq FROM andre;
GRANT ALL ON SEQUENCE basevalues_id_seq TO andre;
GRANT ALL ON SEQUENCE basevalues_id_seq TO nginx;


--
-- Name: char_kampftechniken; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE char_kampftechniken FROM PUBLIC;
REVOKE ALL ON TABLE char_kampftechniken FROM andre;
GRANT ALL ON TABLE char_kampftechniken TO andre;
GRANT ALL ON TABLE char_kampftechniken TO nginx;


--
-- Name: char_kampftechniken_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE char_kampftechniken_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE char_kampftechniken_id_seq FROM andre;
GRANT ALL ON SEQUENCE char_kampftechniken_id_seq TO andre;
GRANT ALL ON SEQUENCE char_kampftechniken_id_seq TO nginx;


--
-- Name: char_vorteile; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE char_vorteile FROM PUBLIC;
REVOKE ALL ON TABLE char_vorteile FROM andre;
GRANT ALL ON TABLE char_vorteile TO andre;
GRANT ALL ON TABLE char_vorteile TO nginx;


--
-- Name: char_vorteile_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE char_vorteile_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE char_vorteile_id_seq FROM andre;
GRANT ALL ON SEQUENCE char_vorteile_id_seq TO andre;
GRANT ALL ON SEQUENCE char_vorteile_id_seq TO nginx;


--
-- Name: char_weapons; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE char_weapons FROM PUBLIC;
REVOKE ALL ON TABLE char_weapons FROM andre;
GRANT ALL ON TABLE char_weapons TO andre;
GRANT ALL ON TABLE char_weapons TO nginx;


--
-- Name: char_weapons_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE char_weapons_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE char_weapons_id_seq FROM andre;
GRANT ALL ON SEQUENCE char_weapons_id_seq TO andre;
GRANT ALL ON SEQUENCE char_weapons_id_seq TO nginx;


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
-- Name: kampftechniken; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE kampftechniken FROM PUBLIC;
REVOKE ALL ON TABLE kampftechniken FROM andre;
GRANT ALL ON TABLE kampftechniken TO andre;
GRANT ALL ON TABLE kampftechniken TO nginx;


--
-- Name: kampftechniken_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE kampftechniken_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE kampftechniken_id_seq FROM andre;
GRANT ALL ON SEQUENCE kampftechniken_id_seq TO andre;
GRANT ALL ON SEQUENCE kampftechniken_id_seq TO nginx;


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
-- Name: weapons; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE weapons FROM PUBLIC;
REVOKE ALL ON TABLE weapons FROM andre;
GRANT ALL ON TABLE weapons TO andre;
GRANT ALL ON TABLE weapons TO nginx;


--
-- Name: weapons_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE weapons_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE weapons_id_seq FROM andre;
GRANT ALL ON SEQUENCE weapons_id_seq TO andre;
GRANT ALL ON SEQUENCE weapons_id_seq TO nginx;


--
-- PostgreSQL database dump complete
--
