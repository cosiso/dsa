PGDMP     7    /                r           dsa    9.3.4    9.3.4 �    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            �           1262    17750    dsa    DATABASE     u   CREATE DATABASE dsa WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';
    DROP DATABASE dsa;
             nginx    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             postgres    false            �           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  postgres    false    5            �           0    0    public    ACL     �   REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;
                  postgres    false    5            �            3079    12670    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false            �           0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    194            �            1255    17955    calc_at(integer)    FUNCTION     �   CREATE FUNCTION calc_at(cid integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
   DECLARE
      my_at INT;
   BEGIN
      SELECT ROUND((calc_mu(cid) + calc_ge(cid) + calc_kk(cid)) / 5.0) INTO my_at;
      RETURN my_at;
   END;
$$;
 +   DROP FUNCTION public.calc_at(cid integer);
       public       andre    false    194    5            �            1255    17964    calc_ch(integer)    FUNCTION     �  CREATE FUNCTION calc_ch(cid integer) RETURNS integer
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
 +   DROP FUNCTION public.calc_ch(cid integer);
       public       andre    false    194    5            �            1255    17965    calc_ff(integer)    FUNCTION     �  CREATE FUNCTION calc_ff(cid integer) RETURNS integer
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
 +   DROP FUNCTION public.calc_ff(cid integer);
       public       andre    false    194    5            �            1255    17958    calc_ge(integer)    FUNCTION     �  CREATE FUNCTION calc_ge(cid integer) RETURNS integer
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
 +   DROP FUNCTION public.calc_ge(cid integer);
       public       andre    false    5    194            �            1255    17960    calc_in(integer)    FUNCTION     �  CREATE FUNCTION calc_in(cid integer) RETURNS integer
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
 +   DROP FUNCTION public.calc_in(cid integer);
       public       andre    false    5    194            �            1255    17968    calc_ini(integer)    FUNCTION     �   CREATE FUNCTION calc_ini(cid integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
   DECLARE
      my_ini INT;
   BEGIN
      SELECT ROUND( (calc_mu(cid) * 2 + calc_in(cid) + calc_ge(cid)) / 5.0 ) INTO my_ini;
      RETURN my_ini;
   END;
$$;
 ,   DROP FUNCTION public.calc_ini(cid integer);
       public       andre    false    194    5            �            1255    17959    calc_kk(integer)    FUNCTION     �  CREATE FUNCTION calc_kk(cid integer) RETURNS integer
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
 +   DROP FUNCTION public.calc_kk(cid integer);
       public       andre    false    5    194            �            1255    17963    calc_kl(integer)    FUNCTION     �  CREATE FUNCTION calc_kl(cid integer) RETURNS integer
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
 +   DROP FUNCTION public.calc_kl(cid integer);
       public       andre    false    194    5            �            1255    17966    calc_ko(integer)    FUNCTION     �  CREATE FUNCTION calc_ko(cid integer) RETURNS integer
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
 +   DROP FUNCTION public.calc_ko(cid integer);
       public       andre    false    5    194            �            1255    17957    calc_mu(integer)    FUNCTION     �  CREATE FUNCTION calc_mu(cid integer) RETURNS integer
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
 +   DROP FUNCTION public.calc_mu(cid integer);
       public       andre    false    5    194            �            1255    17961    calc_pa(integer)    FUNCTION     �   CREATE FUNCTION calc_pa(cid integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
   DECLARE
      my_pa INT;
   BEGIN
      SELECT ROUND((calc_in(cid) + calc_ge(cid) + calc_kk(cid)) / 5.0) INTO my_pa;
      RETURN my_pa;
   END;
$$;
 +   DROP FUNCTION public.calc_pa(cid integer);
       public       andre    false    5    194            �            1255    17962 $   kk_bonus(integer, character varying)    FUNCTION     �  CREATE FUNCTION kk_bonus(cid integer, tpkk character varying) RETURNS integer
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
 D   DROP FUNCTION public.kk_bonus(cid integer, tpkk character varying);
       public       andre    false    194    5            �            1259    17880 
   basevalues    TABLE     �  CREATE TABLE basevalues (
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
    DROP TABLE public.basevalues;
       public         andre    false    5            �           0    0 
   basevalues    ACL     �   REVOKE ALL ON TABLE basevalues FROM PUBLIC;
REVOKE ALL ON TABLE basevalues FROM andre;
GRANT ALL ON TABLE basevalues TO andre;
GRANT ALL ON TABLE basevalues TO nginx;
            public       andre    false    185            �            1259    17878    basevalues_id_seq    SEQUENCE     s   CREATE SEQUENCE basevalues_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.basevalues_id_seq;
       public       andre    false    185    5            �           0    0    basevalues_id_seq    SEQUENCE OWNED BY     9   ALTER SEQUENCE basevalues_id_seq OWNED BY basevalues.id;
            public       andre    false    184            �           0    0    basevalues_id_seq    ACL     �   REVOKE ALL ON SEQUENCE basevalues_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE basevalues_id_seq FROM andre;
GRANT ALL ON SEQUENCE basevalues_id_seq TO andre;
GRANT ALL ON SEQUENCE basevalues_id_seq TO nginx;
            public       andre    false    184            �            1259    17927    char_kampftechniken    TABLE     �   CREATE TABLE char_kampftechniken (
    id integer NOT NULL,
    kampftechnik_id integer NOT NULL,
    at integer DEFAULT 0 NOT NULL,
    pa integer DEFAULT 0 NOT NULL,
    character_id integer NOT NULL
);
 '   DROP TABLE public.char_kampftechniken;
       public         andre    false    5            �           0    0    char_kampftechniken    ACL     �   REVOKE ALL ON TABLE char_kampftechniken FROM PUBLIC;
REVOKE ALL ON TABLE char_kampftechniken FROM andre;
GRANT ALL ON TABLE char_kampftechniken TO andre;
GRANT ALL ON TABLE char_kampftechniken TO nginx;
            public       andre    false    191            �            1259    17925    char_kampftechniken_id_seq    SEQUENCE     |   CREATE SEQUENCE char_kampftechniken_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.char_kampftechniken_id_seq;
       public       andre    false    5    191            �           0    0    char_kampftechniken_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE char_kampftechniken_id_seq OWNED BY char_kampftechniken.id;
            public       andre    false    190            �           0    0    char_kampftechniken_id_seq    ACL     �   REVOKE ALL ON SEQUENCE char_kampftechniken_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE char_kampftechniken_id_seq FROM andre;
GRANT ALL ON SEQUENCE char_kampftechniken_id_seq TO andre;
GRANT ALL ON SEQUENCE char_kampftechniken_id_seq TO nginx;
            public       andre    false    190            �            1259    17858    char_vorteile    TABLE     �   CREATE TABLE char_vorteile (
    id integer NOT NULL,
    character_id integer NOT NULL,
    vorteil_id integer NOT NULL,
    note character varying(1024),
    value integer
);
 !   DROP TABLE public.char_vorteile;
       public         andre    false    5            �           0    0    char_vorteile    ACL     �   REVOKE ALL ON TABLE char_vorteile FROM PUBLIC;
REVOKE ALL ON TABLE char_vorteile FROM andre;
GRANT ALL ON TABLE char_vorteile TO andre;
GRANT ALL ON TABLE char_vorteile TO nginx;
            public       andre    false    183            �            1259    17856    char_vorteile_id_seq    SEQUENCE     v   CREATE SEQUENCE char_vorteile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.char_vorteile_id_seq;
       public       andre    false    183    5            �           0    0    char_vorteile_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE char_vorteile_id_seq OWNED BY char_vorteile.id;
            public       andre    false    182            �           0    0    char_vorteile_id_seq    ACL     �   REVOKE ALL ON SEQUENCE char_vorteile_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE char_vorteile_id_seq FROM andre;
GRANT ALL ON SEQUENCE char_vorteile_id_seq TO andre;
GRANT ALL ON SEQUENCE char_vorteile_id_seq TO nginx;
            public       andre    false    182            �            1259    17971    char_weapons    TABLE     ^  CREATE TABLE char_weapons (
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
     DROP TABLE public.char_weapons;
       public         andre    false    5            �           0    0    char_weapons    ACL     �   REVOKE ALL ON TABLE char_weapons FROM PUBLIC;
REVOKE ALL ON TABLE char_weapons FROM andre;
GRANT ALL ON TABLE char_weapons TO andre;
GRANT ALL ON TABLE char_weapons TO nginx;
            public       andre    false    193            �            1259    17969    char_weapons_id_seq    SEQUENCE     u   CREATE SEQUENCE char_weapons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.char_weapons_id_seq;
       public       andre    false    193    5            �           0    0    char_weapons_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE char_weapons_id_seq OWNED BY char_weapons.id;
            public       andre    false    192            �           0    0    char_weapons_id_seq    ACL     �   REVOKE ALL ON SEQUENCE char_weapons_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE char_weapons_id_seq FROM andre;
GRANT ALL ON SEQUENCE char_weapons_id_seq TO andre;
GRANT ALL ON SEQUENCE char_weapons_id_seq TO nginx;
            public       andre    false    192            �            1259    17826    character_eigenschaften    TABLE     �   CREATE TABLE character_eigenschaften (
    id integer NOT NULL,
    "character" integer NOT NULL,
    eigenschaft integer NOT NULL,
    base integer NOT NULL,
    modifier integer,
    zugekauft integer,
    note character varying(255)
);
 +   DROP TABLE public.character_eigenschaften;
       public         andre    false    5            �           0    0    character_eigenschaften    ACL     �   REVOKE ALL ON TABLE character_eigenschaften FROM PUBLIC;
REVOKE ALL ON TABLE character_eigenschaften FROM andre;
GRANT ALL ON TABLE character_eigenschaften TO andre;
GRANT ALL ON TABLE character_eigenschaften TO nginx;
            public       andre    false    179            �            1259    17824    character_eigenschaften_id_seq    SEQUENCE     �   CREATE SEQUENCE character_eigenschaften_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.character_eigenschaften_id_seq;
       public       andre    false    5    179            �           0    0    character_eigenschaften_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE character_eigenschaften_id_seq OWNED BY character_eigenschaften.id;
            public       andre    false    178            �           0    0    character_eigenschaften_id_seq    ACL       REVOKE ALL ON SEQUENCE character_eigenschaften_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE character_eigenschaften_id_seq FROM andre;
GRANT ALL ON SEQUENCE character_eigenschaften_id_seq TO andre;
GRANT ALL ON SEQUENCE character_eigenschaften_id_seq TO nginx;
            public       andre    false    178            �            1259    17811 
   characters    TABLE     �  CREATE TABLE characters (
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
    DROP TABLE public.characters;
       public         andre    false    5            �           0    0 
   characters    ACL     �   REVOKE ALL ON TABLE characters FROM PUBLIC;
REVOKE ALL ON TABLE characters FROM andre;
GRANT ALL ON TABLE characters TO andre;
GRANT ALL ON TABLE characters TO nginx;
            public       andre    false    177            �            1259    17809    characters_id_seq    SEQUENCE     s   CREATE SEQUENCE characters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.characters_id_seq;
       public       andre    false    5    177            �           0    0    characters_id_seq    SEQUENCE OWNED BY     9   ALTER SEQUENCE characters_id_seq OWNED BY characters.id;
            public       andre    false    176            �           0    0    characters_id_seq    ACL     �   REVOKE ALL ON SEQUENCE characters_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE characters_id_seq FROM andre;
GRANT ALL ON SEQUENCE characters_id_seq TO andre;
GRANT ALL ON SEQUENCE characters_id_seq TO nginx;
            public       andre    false    176            �            1259    17893    kampftechniken    TABLE     �   CREATE TABLE kampftechniken (
    id integer NOT NULL,
    name character varying(32) NOT NULL,
    be integer,
    skt character(1),
    unarmed boolean DEFAULT false
);
 "   DROP TABLE public.kampftechniken;
       public         andre    false    5            �           0    0    kampftechniken    ACL     �   REVOKE ALL ON TABLE kampftechniken FROM PUBLIC;
REVOKE ALL ON TABLE kampftechniken FROM andre;
GRANT ALL ON TABLE kampftechniken TO andre;
GRANT ALL ON TABLE kampftechniken TO nginx;
            public       andre    false    187            �            1259    17891    kampftechniken_id_seq    SEQUENCE     w   CREATE SEQUENCE kampftechniken_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.kampftechniken_id_seq;
       public       andre    false    187    5            �           0    0    kampftechniken_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE kampftechniken_id_seq OWNED BY kampftechniken.id;
            public       andre    false    186            �           0    0    kampftechniken_id_seq    ACL     �   REVOKE ALL ON SEQUENCE kampftechniken_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE kampftechniken_id_seq FROM andre;
GRANT ALL ON SEQUENCE kampftechniken_id_seq TO andre;
GRANT ALL ON SEQUENCE kampftechniken_id_seq TO nginx;
            public       andre    false    186            �            1259    17771    talente    TABLE     @  CREATE TABLE talente (
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
    DROP TABLE public.talente;
       public         andre    false    5            �           0    0    talente    ACL     �   REVOKE ALL ON TABLE talente FROM PUBLIC;
REVOKE ALL ON TABLE talente FROM andre;
GRANT ALL ON TABLE talente TO andre;
GRANT ALL ON TABLE talente TO nginx;
            public       andre    false    175            �            1259    17769    talente_id_seq    SEQUENCE     p   CREATE SEQUENCE talente_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.talente_id_seq;
       public       andre    false    175    5            �           0    0    talente_id_seq    SEQUENCE OWNED BY     3   ALTER SEQUENCE talente_id_seq OWNED BY talente.id;
            public       andre    false    174            �           0    0    talente_id_seq    ACL     �   REVOKE ALL ON SEQUENCE talente_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE talente_id_seq FROM andre;
GRANT ALL ON SEQUENCE talente_id_seq TO andre;
GRANT ALL ON SEQUENCE talente_id_seq TO nginx;
            public       andre    false    174            �            1259    17761    talenten_cat    TABLE     ~   CREATE TABLE talenten_cat (
    id integer NOT NULL,
    name character varying(32) NOT NULL,
    default_skt character(1)
);
     DROP TABLE public.talenten_cat;
       public         andre    false    5            �           0    0    talenten_cat    ACL     �   REVOKE ALL ON TABLE talenten_cat FROM PUBLIC;
REVOKE ALL ON TABLE talenten_cat FROM andre;
GRANT ALL ON TABLE talenten_cat TO andre;
GRANT ALL ON TABLE talenten_cat TO nginx;
            public       andre    false    173            �            1259    17759    talenten_cat_id_seq    SEQUENCE     u   CREATE SEQUENCE talenten_cat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.talenten_cat_id_seq;
       public       andre    false    173    5            �           0    0    talenten_cat_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE talenten_cat_id_seq OWNED BY talenten_cat.id;
            public       andre    false    172            �           0    0    talenten_cat_id_seq    ACL     �   REVOKE ALL ON SEQUENCE talenten_cat_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE talenten_cat_id_seq FROM andre;
GRANT ALL ON SEQUENCE talenten_cat_id_seq TO andre;
GRANT ALL ON SEQUENCE talenten_cat_id_seq TO nginx;
            public       andre    false    172            �            1259    17753    traits    TABLE     h   CREATE TABLE traits (
    id integer NOT NULL,
    name character varying(20),
    abbr character(2)
);
    DROP TABLE public.traits;
       public         andre    false    5            �           0    0    traits    ACL     �   REVOKE ALL ON TABLE traits FROM PUBLIC;
REVOKE ALL ON TABLE traits FROM andre;
GRANT ALL ON TABLE traits TO andre;
GRANT ALL ON TABLE traits TO nginx;
            public       andre    false    171            �            1259    17751    traits_id_seq    SEQUENCE     o   CREATE SEQUENCE traits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.traits_id_seq;
       public       andre    false    5    171            �           0    0    traits_id_seq    SEQUENCE OWNED BY     1   ALTER SEQUENCE traits_id_seq OWNED BY traits.id;
            public       andre    false    170            �           0    0    traits_id_seq    ACL     �   REVOKE ALL ON SEQUENCE traits_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE traits_id_seq FROM andre;
GRANT ALL ON SEQUENCE traits_id_seq TO andre;
GRANT ALL ON SEQUENCE traits_id_seq TO nginx;
            public       andre    false    170            �            1259    17844    vorteile    TABLE     �   CREATE TABLE vorteile (
    id integer NOT NULL,
    name character varying(64) NOT NULL,
    vorteil boolean NOT NULL,
    gp integer,
    ap integer,
    effect character varying(256),
    description character varying(2048)
);
    DROP TABLE public.vorteile;
       public         andre    false    5                        0    0    vorteile    ACL     �   REVOKE ALL ON TABLE vorteile FROM PUBLIC;
REVOKE ALL ON TABLE vorteile FROM andre;
GRANT ALL ON TABLE vorteile TO andre;
GRANT ALL ON TABLE vorteile TO nginx;
            public       andre    false    181            �            1259    17842    vorteile_id_seq    SEQUENCE     q   CREATE SEQUENCE vorteile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.vorteile_id_seq;
       public       andre    false    5    181                       0    0    vorteile_id_seq    SEQUENCE OWNED BY     5   ALTER SEQUENCE vorteile_id_seq OWNED BY vorteile.id;
            public       andre    false    180                       0    0    vorteile_id_seq    ACL     �   REVOKE ALL ON SEQUENCE vorteile_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE vorteile_id_seq FROM andre;
GRANT ALL ON SEQUENCE vorteile_id_seq TO andre;
GRANT ALL ON SEQUENCE vorteile_id_seq TO nginx;
            public       andre    false    180            �            1259    17906    weapons    TABLE     �  CREATE TABLE weapons (
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
    DROP TABLE public.weapons;
       public         andre    false    5                       0    0    weapons    ACL     �   REVOKE ALL ON TABLE weapons FROM PUBLIC;
REVOKE ALL ON TABLE weapons FROM andre;
GRANT ALL ON TABLE weapons TO andre;
GRANT ALL ON TABLE weapons TO nginx;
            public       andre    false    189            �            1259    17904    weapons_id_seq    SEQUENCE     p   CREATE SEQUENCE weapons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.weapons_id_seq;
       public       andre    false    189    5                       0    0    weapons_id_seq    SEQUENCE OWNED BY     3   ALTER SEQUENCE weapons_id_seq OWNED BY weapons.id;
            public       andre    false    188                       0    0    weapons_id_seq    ACL     �   REVOKE ALL ON SEQUENCE weapons_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE weapons_id_seq FROM andre;
GRANT ALL ON SEQUENCE weapons_id_seq TO andre;
GRANT ALL ON SEQUENCE weapons_id_seq TO nginx;
            public       andre    false    188                       2604    17883    id    DEFAULT     `   ALTER TABLE ONLY basevalues ALTER COLUMN id SET DEFAULT nextval('basevalues_id_seq'::regclass);
 <   ALTER TABLE public.basevalues ALTER COLUMN id DROP DEFAULT;
       public       andre    false    184    185    185                       2604    17930    id    DEFAULT     r   ALTER TABLE ONLY char_kampftechniken ALTER COLUMN id SET DEFAULT nextval('char_kampftechniken_id_seq'::regclass);
 E   ALTER TABLE public.char_kampftechniken ALTER COLUMN id DROP DEFAULT;
       public       andre    false    190    191    191                       2604    17861    id    DEFAULT     f   ALTER TABLE ONLY char_vorteile ALTER COLUMN id SET DEFAULT nextval('char_vorteile_id_seq'::regclass);
 ?   ALTER TABLE public.char_vorteile ALTER COLUMN id DROP DEFAULT;
       public       andre    false    182    183    183                       2604    17974    id    DEFAULT     d   ALTER TABLE ONLY char_weapons ALTER COLUMN id SET DEFAULT nextval('char_weapons_id_seq'::regclass);
 >   ALTER TABLE public.char_weapons ALTER COLUMN id DROP DEFAULT;
       public       andre    false    193    192    193                       2604    17829    id    DEFAULT     z   ALTER TABLE ONLY character_eigenschaften ALTER COLUMN id SET DEFAULT nextval('character_eigenschaften_id_seq'::regclass);
 I   ALTER TABLE public.character_eigenschaften ALTER COLUMN id DROP DEFAULT;
       public       andre    false    179    178    179                       2604    17814    id    DEFAULT     `   ALTER TABLE ONLY characters ALTER COLUMN id SET DEFAULT nextval('characters_id_seq'::regclass);
 <   ALTER TABLE public.characters ALTER COLUMN id DROP DEFAULT;
       public       andre    false    176    177    177                       2604    17896    id    DEFAULT     h   ALTER TABLE ONLY kampftechniken ALTER COLUMN id SET DEFAULT nextval('kampftechniken_id_seq'::regclass);
 @   ALTER TABLE public.kampftechniken ALTER COLUMN id DROP DEFAULT;
       public       andre    false    187    186    187                       2604    17774    id    DEFAULT     Z   ALTER TABLE ONLY talente ALTER COLUMN id SET DEFAULT nextval('talente_id_seq'::regclass);
 9   ALTER TABLE public.talente ALTER COLUMN id DROP DEFAULT;
       public       andre    false    174    175    175                       2604    17764    id    DEFAULT     d   ALTER TABLE ONLY talenten_cat ALTER COLUMN id SET DEFAULT nextval('talenten_cat_id_seq'::regclass);
 >   ALTER TABLE public.talenten_cat ALTER COLUMN id DROP DEFAULT;
       public       andre    false    173    172    173            
           2604    17756    id    DEFAULT     X   ALTER TABLE ONLY traits ALTER COLUMN id SET DEFAULT nextval('traits_id_seq'::regclass);
 8   ALTER TABLE public.traits ALTER COLUMN id DROP DEFAULT;
       public       andre    false    170    171    171                       2604    17847    id    DEFAULT     \   ALTER TABLE ONLY vorteile ALTER COLUMN id SET DEFAULT nextval('vorteile_id_seq'::regclass);
 :   ALTER TABLE public.vorteile ALTER COLUMN id DROP DEFAULT;
       public       andre    false    180    181    181                       2604    17909    id    DEFAULT     Z   ALTER TABLE ONLY weapons ALTER COLUMN id SET DEFAULT nextval('weapons_id_seq'::regclass);
 9   ALTER TABLE public.weapons ALTER COLUMN id DROP DEFAULT;
       public       andre    false    188    189    189            �          0    17880 
   basevalues 
   TABLE DATA               �   COPY basevalues (id, character_id, le_used, le_mod, le_bought, au_used, au_mod, au_bought, ae_used, ae_mod, ae_bought, mr_used, mr_mod, mr_bought, ini_mod, at_mod, pa_mod, fk_mod) FROM stdin;
    public       andre    false    185   "�                  0    0    basevalues_id_seq    SEQUENCE SET     8   SELECT pg_catalog.setval('basevalues_id_seq', 1, true);
            public       andre    false    184            �          0    17927    char_kampftechniken 
   TABLE DATA               Q   COPY char_kampftechniken (id, kampftechnik_id, at, pa, character_id) FROM stdin;
    public       andre    false    191   [�                  0    0    char_kampftechniken_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('char_kampftechniken_id_seq', 38, true);
            public       andre    false    190            �          0    17858    char_vorteile 
   TABLE DATA               K   COPY char_vorteile (id, character_id, vorteil_id, note, value) FROM stdin;
    public       andre    false    183   ��                  0    0    char_vorteile_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('char_vorteile_id_seq', 21, true);
            public       andre    false    182            �          0    17971    char_weapons 
   TABLE DATA               a   COPY char_weapons (id, character_id, weapon_id, ini, wm, at, pa, bf, tpkk, note, tp) FROM stdin;
    public       andre    false    193   ��       	           0    0    char_weapons_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('char_weapons_id_seq', 3, true);
            public       andre    false    192            �          0    17826    character_eigenschaften 
   TABLE DATA               i   COPY character_eigenschaften (id, "character", eigenschaft, base, modifier, zugekauft, note) FROM stdin;
    public       andre    false    179   J�       
           0    0    character_eigenschaften_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('character_eigenschaften_id_seq', 24, true);
            public       andre    false    178            �          0    17811 
   characters 
   TABLE DATA               �   COPY characters (id, name, rasse, kultur, profession, geschlecht, grosse, gewicht, haarfarbe, augenfarbe, aussehen, alter, ap) FROM stdin;
    public       andre    false    177   ��                  0    0    characters_id_seq    SEQUENCE SET     8   SELECT pg_catalog.setval('characters_id_seq', 8, true);
            public       andre    false    176            �          0    17893    kampftechniken 
   TABLE DATA               =   COPY kampftechniken (id, name, be, skt, unarmed) FROM stdin;
    public       andre    false    187   ��                  0    0    kampftechniken_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('kampftechniken_id_seq', 15, true);
            public       andre    false    186            �          0    17771    talente 
   TABLE DATA               g   COPY talente (id, name, be, komp, eigenschaft1, eigenschaft2, eigenschaft3, category, skt) FROM stdin;
    public       andre    false    175   {�                  0    0    talente_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('talente_id_seq', 1, false);
            public       andre    false    174            �          0    17761    talenten_cat 
   TABLE DATA               6   COPY talenten_cat (id, name, default_skt) FROM stdin;
    public       andre    false    173   ��                  0    0    talenten_cat_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('talenten_cat_id_seq', 9, true);
            public       andre    false    172            �          0    17753    traits 
   TABLE DATA               )   COPY traits (id, name, abbr) FROM stdin;
    public       andre    false    171   +�                  0    0    traits_id_seq    SEQUENCE SET     5   SELECT pg_catalog.setval('traits_id_seq', 25, true);
            public       andre    false    170            �          0    17844    vorteile 
   TABLE DATA               K   COPY vorteile (id, name, vorteil, gp, ap, effect, description) FROM stdin;
    public       andre    false    181   ��                  0    0    vorteile_id_seq    SEQUENCE SET     7   SELECT pg_catalog.setval('vorteile_id_seq', 12, true);
            public       andre    false    180            �          0    17906    weapons 
   TABLE DATA               m   COPY weapons (id, tp, tpkk, gewicht, lange, bf, ini, preis, wm, dk, kampftechnik_id, name, note) FROM stdin;
    public       andre    false    189   ��                  0    0    weapons_id_seq    SEQUENCE SET     5   SELECT pg_catalog.setval('weapons_id_seq', 8, true);
            public       andre    false    188            :           2606    17885    basevalues_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY basevalues
    ADD CONSTRAINT basevalues_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.basevalues DROP CONSTRAINT basevalues_pkey;
       public         andre    false    185    185            E           2606    17934    char_kampftechniken_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY char_kampftechniken
    ADD CONSTRAINT char_kampftechniken_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.char_kampftechniken DROP CONSTRAINT char_kampftechniken_pkey;
       public         andre    false    191    191            7           2606    17866    char_vorteile_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY char_vorteile
    ADD CONSTRAINT char_vorteile_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.char_vorteile DROP CONSTRAINT char_vorteile_pkey;
       public         andre    false    183    183            H           2606    17982    char_weapons_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY char_weapons
    ADD CONSTRAINT char_weapons_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.char_weapons DROP CONSTRAINT char_weapons_pkey;
       public         andre    false    193    193            0           2606    17831    character_eigenschaften_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY character_eigenschaften
    ADD CONSTRAINT character_eigenschaften_pkey PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.character_eigenschaften DROP CONSTRAINT character_eigenschaften_pkey;
       public         andre    false    179    179            ,           2606    17818    characters_name_key 
   CONSTRAINT     R   ALTER TABLE ONLY characters
    ADD CONSTRAINT characters_name_key UNIQUE (name);
 H   ALTER TABLE ONLY public.characters DROP CONSTRAINT characters_name_key;
       public         andre    false    177    177            .           2606    17816    characters_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY characters
    ADD CONSTRAINT characters_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.characters DROP CONSTRAINT characters_pkey;
       public         andre    false    177    177            <           2606    17903    kampftechniken_name_key 
   CONSTRAINT     Z   ALTER TABLE ONLY kampftechniken
    ADD CONSTRAINT kampftechniken_name_key UNIQUE (name);
 P   ALTER TABLE ONLY public.kampftechniken DROP CONSTRAINT kampftechniken_name_key;
       public         andre    false    187    187            >           2606    17901    kampftechniken_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY kampftechniken
    ADD CONSTRAINT kampftechniken_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.kampftechniken DROP CONSTRAINT kampftechniken_pkey;
       public         andre    false    187    187            (           2606    17778    talente_name_key 
   CONSTRAINT     L   ALTER TABLE ONLY talente
    ADD CONSTRAINT talente_name_key UNIQUE (name);
 B   ALTER TABLE ONLY public.talente DROP CONSTRAINT talente_name_key;
       public         andre    false    175    175            *           2606    17776    talente_pkey 
   CONSTRAINT     K   ALTER TABLE ONLY talente
    ADD CONSTRAINT talente_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.talente DROP CONSTRAINT talente_pkey;
       public         andre    false    175    175            #           2606    17768    talenten_cat_name_key 
   CONSTRAINT     V   ALTER TABLE ONLY talenten_cat
    ADD CONSTRAINT talenten_cat_name_key UNIQUE (name);
 L   ALTER TABLE ONLY public.talenten_cat DROP CONSTRAINT talenten_cat_name_key;
       public         andre    false    173    173            %           2606    17766    talenten_cat_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY talenten_cat
    ADD CONSTRAINT talenten_cat_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.talenten_cat DROP CONSTRAINT talenten_cat_pkey;
       public         andre    false    173    173            !           2606    17758    traits_pkey 
   CONSTRAINT     I   ALTER TABLE ONLY traits
    ADD CONSTRAINT traits_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.traits DROP CONSTRAINT traits_pkey;
       public         andre    false    171    171            2           2606    17854    vorteile_name_key 
   CONSTRAINT     N   ALTER TABLE ONLY vorteile
    ADD CONSTRAINT vorteile_name_key UNIQUE (name);
 D   ALTER TABLE ONLY public.vorteile DROP CONSTRAINT vorteile_name_key;
       public         andre    false    181    181            4           2606    17852    vorteile_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY vorteile
    ADD CONSTRAINT vorteile_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.vorteile DROP CONSTRAINT vorteile_pkey;
       public         andre    false    181    181            A           2606    17917    weapons_pkey 
   CONSTRAINT     K   ALTER TABLE ONLY weapons
    ADD CONSTRAINT weapons_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.weapons DROP CONSTRAINT weapons_pkey;
       public         andre    false    189    189            8           1259    17997    basevalues_character_id_idx    INDEX     S   CREATE INDEX basevalues_character_id_idx ON basevalues USING btree (character_id);
 /   DROP INDEX public.basevalues_character_id_idx;
       public         andre    false    185            B           1259    17994 $   char_kampftechniken_character_id_idx    INDEX     e   CREATE INDEX char_kampftechniken_character_id_idx ON char_kampftechniken USING btree (character_id);
 8   DROP INDEX public.char_kampftechniken_character_id_idx;
       public         andre    false    191            C           1259    17995 '   char_kampftechniken_kampftechnik_id_idx    INDEX     k   CREATE INDEX char_kampftechniken_kampftechnik_id_idx ON char_kampftechniken USING btree (kampftechnik_id);
 ;   DROP INDEX public.char_kampftechniken_kampftechnik_id_idx;
       public         andre    false    191            5           1259    17877 )   char_vorteile_character_id_vorteil_id_idx    INDEX     w   CREATE UNIQUE INDEX char_vorteile_character_id_vorteil_id_idx ON char_vorteile USING btree (character_id, vorteil_id);
 =   DROP INDEX public.char_vorteile_character_id_vorteil_id_idx;
       public         andre    false    183    183            F           1259    17993    char_weapons_character_id_idx    INDEX     W   CREATE INDEX char_weapons_character_id_idx ON char_weapons USING btree (character_id);
 1   DROP INDEX public.char_weapons_character_id_idx;
       public         andre    false    193            &           1259    17996    talente_category_idx    INDEX     E   CREATE INDEX talente_category_idx ON talente USING btree (category);
 (   DROP INDEX public.talente_category_idx;
       public         andre    false    175            ?           1259    17923    weapons_name_idx    INDEX     D   CREATE UNIQUE INDEX weapons_name_idx ON weapons USING btree (name);
 $   DROP INDEX public.weapons_name_idx;
       public         andre    false    189            Q           2606    17886    basevalues_character_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY basevalues
    ADD CONSTRAINT basevalues_character_id_fkey FOREIGN KEY (character_id) REFERENCES characters(id) ON UPDATE CASCADE ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.basevalues DROP CONSTRAINT basevalues_character_id_fkey;
       public       andre    false    2862    177    185            T           2606    17944 %   char_kampftechniken_character_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY char_kampftechniken
    ADD CONSTRAINT char_kampftechniken_character_id_fkey FOREIGN KEY (character_id) REFERENCES characters(id) ON UPDATE CASCADE ON DELETE CASCADE;
 c   ALTER TABLE ONLY public.char_kampftechniken DROP CONSTRAINT char_kampftechniken_character_id_fkey;
       public       andre    false    2862    177    191            S           2606    17935 (   char_kampftechniken_kampftechnik_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY char_kampftechniken
    ADD CONSTRAINT char_kampftechniken_kampftechnik_id_fkey FOREIGN KEY (kampftechnik_id) REFERENCES kampftechniken(id) ON UPDATE CASCADE ON DELETE CASCADE;
 f   ALTER TABLE ONLY public.char_kampftechniken DROP CONSTRAINT char_kampftechniken_kampftechnik_id_fkey;
       public       andre    false    191    2878    187            O           2606    17867    char_vorteile_character_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY char_vorteile
    ADD CONSTRAINT char_vorteile_character_id_fkey FOREIGN KEY (character_id) REFERENCES characters(id) ON UPDATE CASCADE ON DELETE CASCADE;
 W   ALTER TABLE ONLY public.char_vorteile DROP CONSTRAINT char_vorteile_character_id_fkey;
       public       andre    false    177    2862    183            P           2606    17872    char_vorteile_vorteil_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY char_vorteile
    ADD CONSTRAINT char_vorteile_vorteil_id_fkey FOREIGN KEY (vorteil_id) REFERENCES vorteile(id) ON UPDATE CASCADE ON DELETE CASCADE;
 U   ALTER TABLE ONLY public.char_vorteile DROP CONSTRAINT char_vorteile_vorteil_id_fkey;
       public       andre    false    183    181    2868            U           2606    17983    char_weapons_character_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY char_weapons
    ADD CONSTRAINT char_weapons_character_id_fkey FOREIGN KEY (character_id) REFERENCES characters(id) ON UPDATE CASCADE ON DELETE CASCADE;
 U   ALTER TABLE ONLY public.char_weapons DROP CONSTRAINT char_weapons_character_id_fkey;
       public       andre    false    177    193    2862            V           2606    17988    char_weapons_weapon_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY char_weapons
    ADD CONSTRAINT char_weapons_weapon_id_fkey FOREIGN KEY (weapon_id) REFERENCES weapons(id) ON UPDATE CASCADE ON DELETE CASCADE;
 R   ALTER TABLE ONLY public.char_weapons DROP CONSTRAINT char_weapons_weapon_id_fkey;
       public       andre    false    193    2881    189            M           2606    17832 &   character_eigenschaften_character_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY character_eigenschaften
    ADD CONSTRAINT character_eigenschaften_character_fkey FOREIGN KEY ("character") REFERENCES characters(id) ON UPDATE CASCADE ON DELETE CASCADE;
 h   ALTER TABLE ONLY public.character_eigenschaften DROP CONSTRAINT character_eigenschaften_character_fkey;
       public       andre    false    179    177    2862            N           2606    17837 (   character_eigenschaften_eigenschaft_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY character_eigenschaften
    ADD CONSTRAINT character_eigenschaften_eigenschaft_fkey FOREIGN KEY (eigenschaft) REFERENCES traits(id) ON UPDATE CASCADE ON DELETE CASCADE;
 j   ALTER TABLE ONLY public.character_eigenschaften DROP CONSTRAINT character_eigenschaften_eigenschaft_fkey;
       public       andre    false    171    179    2849            L           2606    17794    talente_category_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY talente
    ADD CONSTRAINT talente_category_fkey FOREIGN KEY (category) REFERENCES talenten_cat(id) ON UPDATE CASCADE ON DELETE RESTRICT;
 G   ALTER TABLE ONLY public.talente DROP CONSTRAINT talente_category_fkey;
       public       andre    false    175    173    2853            I           2606    17779    talente_eigenschaft1_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY talente
    ADD CONSTRAINT talente_eigenschaft1_fkey FOREIGN KEY (eigenschaft1) REFERENCES traits(id) ON UPDATE CASCADE ON DELETE RESTRICT;
 K   ALTER TABLE ONLY public.talente DROP CONSTRAINT talente_eigenschaft1_fkey;
       public       andre    false    171    175    2849            J           2606    17784    talente_eigenschaft2_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY talente
    ADD CONSTRAINT talente_eigenschaft2_fkey FOREIGN KEY (eigenschaft2) REFERENCES traits(id) ON UPDATE CASCADE ON DELETE RESTRICT;
 K   ALTER TABLE ONLY public.talente DROP CONSTRAINT talente_eigenschaft2_fkey;
       public       andre    false    175    171    2849            K           2606    17789    talente_eigenschaft3_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY talente
    ADD CONSTRAINT talente_eigenschaft3_fkey FOREIGN KEY (eigenschaft3) REFERENCES traits(id) ON UPDATE CASCADE ON DELETE RESTRICT;
 K   ALTER TABLE ONLY public.talente DROP CONSTRAINT talente_eigenschaft3_fkey;
       public       andre    false    2849    175    171            R           2606    17918    weapons_kampftechnik_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY weapons
    ADD CONSTRAINT weapons_kampftechnik_id_fkey FOREIGN KEY (kampftechnik_id) REFERENCES kampftechniken(id) ON UPDATE CASCADE ON DELETE CASCADE;
 N   ALTER TABLE ONLY public.weapons DROP CONSTRAINT weapons_kampftechnik_id_fkey;
       public       andre    false    189    2878    187            �   )   x�3�4���44�4� �,͡lSNN����� �2�      �   N   x�5���0C��0U�4�t�9
D9 ?�k��9D�JDG��%�ľ�����V�Q3.�qQ�(�ޠ�S��{H�^6      �   3   x�3�4�? ���`l3 ��5�242�j,�K��� ʋ���� �V      �   >   x�3�4B�? a a�dd+$&��&��T* ٹ�
)���E@Y.#�z#4`����� �b      �   �   x�M���0D��a��-�	������ l��T�6�~�¯9�(\�'��Զ8~=��5���<� ե���u�p3VD��aՔΞ��'C6��Q�L������2~���������Ƽ^��b�I�07Z��>	9��:q6���Wk��9�      �   �   x�}�MN�@���)��H	R�-mE�D�n�qӌ��D���q.�K$/�����Up?H��z�Xy�rH� +
J�)t,�c�zg��6��S���'N
Uekq��r�98�G�^��W.�&\�h�lP�?W6��g}�_f����졺�Q%7qBRԁ1�>��c|3���qD��`9%�\d�V�-a���-�&u��?�eٲ���a9��7����0͹��n�b^��Flc      �   w   x�=�1�0F��K�28���..@�
	�i!^țp1(&���=���P^t��Z�P�_�/��#T�*I�!Ϫ���w�u�xN��c�Q��`�������)Q�x� ��$\      �      x������ � �      �   �   x�3�tO-N��)N�HL+��L�HUI�I�+I�t�2��>��� �Uː�;1� �$59#/3;5(d��XRZ���m��Y\��W\��.(J�������Q�	4#�ӑ˒�#1/�<�(�1z\\\ �@6�      �   }   x��M�0���7�1�uO,�]�s��R&`!�4��x1#�7ϻF�͝�(;�2�<�3��e1�+��$ŠmP��18G�fˋ��ߏNA{����6�!����v��ۧ�-�:�cED?�(�      �   �  x��X�RG=���(���8���1PL���+U����D����Yd�gr�|���H@*�*�vv�����o�۹�n����͵�d�����s��QI�;�ߝ��_��t�jK�J��B�JO�6�\���.юL�tEo�����hc�M�}0U����)�V��� ;��=�rR�|z]&>8����:�"H���W�Վ���|�7�h8�y�1vNT5�r���;�	����N���^Шs`,�,n��V&��r�?�y��ׅ<6�SM5S6-��]�(4�S��^�|M�����	Fs����?�{mpFSш�;	���_܆9'O�/ۇ� 1���&��e�Ng����=j�!�z�<@q��TyD �?�~�,�����q�U�M���d>��ځ)���̱��ݮ���DYK��n��'�Ԗc�t����.�l�T���ՅՔ��v���ŝM�`�ŝ���ϋ��� �25�o�&��2p052U~d\w�3@����K�bF�3����/;�9v��.��q�=@��w
'����������󫮼���R3�w�X3U���gZpW���0N��-n��#�b��1y��Ii��|h\��^7�t���룥��J��P,Fn��Vz�r�'`Z�Ǎ�����UHw_��7G�`����PfTBݿЗFP���	�ju�Fk��a.����H��9ʮ6��.qx�7_�n�oP�L���Н�r��k7F�VҠ*��}�Vd�_M�c��s`�^�:o�5�*�
H�("	s��NU�%O����T^�d��B�b����9N�� z�C�a�B�����F(�I�?�8%|Ch�y�)��D��sc47�>vd)C/3+�B�I�r=�����D9FS��T-5���%�Q�bP�,ł_�s�I�:6�+n�mO�8X��;�S���.{9��	r�"'�ـ��fܯP���4��1�Px��2EY9��M�Q����r�8}��%�5^)Y�y���O�+���� �8�G�\����˼?��k��\;���sa>�8����t���nH��c�P�W~?<����	�q\i��:����7$�Ѩ�U%�f:E��j�\��scع��r����g��񉇘E��N?a�U^Л�����W4��1z��R��]R鍲-��F�r\(x`w"�DN�H��S�),�PS1'nq�-�1[Q�UT2��!N�"�J��3��*ͭ�r���uNhߍ=R.n��.�tF���+\�n�8�s�8�BOf�)*4R������=�Lpؓ�~F!�S���-��p=��Q^X����PEG��|d�w�͔�73xQ3�J���/=œ:m����Е�q����3d�a�B��Gg�-`�ܗ��8_�Z�rq@�@K���GHT�8Wߧ��}��Q�V��1����J
���b�ʉ�6�dnc��X-�3�j�guQ�t�*���!�Fn���t��&}(�G6(Ch-���+����1�C���$�C3��dg��S�J�Ng��Q��� ���bUg	�-�'f�;0���(��'̑�چ:�!�W2]m���%�>$�]]�z�$��(^@�RaC��;8:����#�v�E�Ú�a���ǿ~؀Y-ʷ)?���0fd$�K1�Е��н�G��Y��(�p�CW翶F_<[o���Ρ�����GfA�Q`G{;�����F��h��D¾,#f�Y�,l�7۽7㟌�$����2�z�5���{H6��bУ���	P*��@�~*3���2�|LQ�6�MA����<��9�aw�(Y�7�!�W*:���Nu)�Cbz���}FSJ��r�Q ]���T�d�E�/�Z�[j)"��I�c~n�_��eP����\>&13��5f��򝼏�:>�Jw����h{܅Z]L���)��)m�92�f=� �Do�l�J�k��X���K����k��z>���E�>���X��!Qڸ���YM�C�x�֣�Ƥ��P�i�SGp�<6Y���Hߖ�Ho����;Ӑ�<.���se`��j���v��;(�&r�]�{=qػ����p�Yu׏/�/�^����+w��?�_���v�n/�r��ZW!�0�6�s�E0ȕQX}�M���[=W�s��5�2�+��J=g�rZ/�N�s�T"���U� �%�=��[˵�����C��v�9^��ÝGX�����t�н�l��`cc�v���      �   6  x��V�R�H>��裩�	�7'f1e0�͒ʖ/c4�f-��ɮ�er�r��ۯ{����ڭT�r�H��韯��v/�޼�E�Ã����F�Q7�u���^/FGѠ*�����M�˵��=�+S�6V�$��|�V[J���}^l3M���H׸�Ri�mL��ɕMr��a�:�M���>_iWkg�����q��K���5=(gpL�I�ݧ3c[�0�}Mb�,�|p���gy�ڟٙ� VKm<���J�S���uD�.-�����
ONg:�~�4�ƥ-�[i+����g���\:'�Y�_�}`�W=������F4׵�5�zG��N��s�6� �4�9hqja�n\5�v� �Be�4|0���q7��Lf+��f�ݢ��G�w�K���0��x`=��z��:�c�]��t�g�󏗃����Nnb�'�X�y�ꏦ�~���?������ӳ��w�9^@�m��P��٩KW�������}�50)�n�/��
�5@���ª:d�S��	��Z�vY�F���!�C?�K�
���K�0�B*N�P5��u�\�ݱ�3����&O����P����P!a����C����R�4�n�`cd��7_rQ��:/i��
�"�%>������'E��i�C�����fʮE��d�@q����[p��A�"_��cט�x�c�m��r�B-5�`��"��+*��bѸ��]h�8��!�L*�M�j��<I�+��3�@U�3k��t��V�u%]%�``t�ae-�vj�XY_KO�Z�=W��h��7���Z��˜3�\S�#Sg��g�J��(����>����`O[����P`D˾�_��2�̠Ťp�YׁYG��$$��{#�07E/k�Ut)�7 ���$n�Aߕ�\�مsg�t��y.�>x��@8�F�/�;� �Z��E�sĻa���9��N0<N�]|@�p�/V<����}�ov�������\8����_��6�\���e��o�*K_���iUѭA��)�35��rp:-���Y !XO�̚]!ҙE��K	�_Z5a�p��\����T�	��G�;ύC(�L�24�<a<"4�5�q12��c"i[h��c��MD\�N{]@9����j0m��Ó����4W-�M�^qg� MA
����j��_*tP�N�SKFlf%]/�o!�F��[��-�?�D�M(��_;3��]sg�|qs�0*T���9�7�z�-��ۿ����X�%֛�(�8�����e�;qˎ��Z`��:��Cm/�/�R�o{��?P�'U����sh�� ������ �ޔ     