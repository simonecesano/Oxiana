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
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: update_modified_column(); Type: FUNCTION; Schema: public; Owner: cesansim
--

CREATE FUNCTION update_modified_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.saved = now();
    RETURN NEW;	
END;
$$;


ALTER FUNCTION public.update_modified_column() OWNER TO cesansim;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: book_items; Type: TABLE; Schema: public; Owner: cesansim; Tablespace: 
--

CREATE TABLE book_items (
    id integer NOT NULL,
    book_id integer NOT NULL,
    chapter_id integer NOT NULL,
    poi_id integer NOT NULL,
    item_sequence integer,
    item_type character varying(64),
    path character varying(512),
    content text,
    saved integer
);


ALTER TABLE public.book_items OWNER TO cesansim;

--
-- Name: book_items_id_seq; Type: SEQUENCE; Schema: public; Owner: cesansim
--

CREATE SEQUENCE book_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.book_items_id_seq OWNER TO cesansim;

--
-- Name: book_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: cesansim
--

ALTER SEQUENCE book_items_id_seq OWNED BY book_items.id;


--
-- Name: books; Type: TABLE; Schema: public; Owner: cesansim; Tablespace: 
--

CREATE TABLE books (
    id integer NOT NULL,
    user_id character varying(32),
    name character varying(64),
    saved integer,
    can_read text,
    can_write text
);


ALTER TABLE public.books OWNER TO cesansim;

--
-- Name: books_id_seq; Type: SEQUENCE; Schema: public; Owner: cesansim
--

CREATE SEQUENCE books_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.books_id_seq OWNER TO cesansim;

--
-- Name: books_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: cesansim
--

ALTER SEQUENCE books_id_seq OWNED BY books.id;


--
-- Name: chapters; Type: TABLE; Schema: public; Owner: cesansim; Tablespace: 
--

CREATE TABLE chapters (
    id integer NOT NULL,
    name character varying(64),
    book_id integer NOT NULL,
    map_id integer NOT NULL
);


ALTER TABLE public.chapters OWNER TO cesansim;

--
-- Name: maps; Type: TABLE; Schema: public; Owner: cesansim; Tablespace: 
--

CREATE TABLE maps (
    id integer NOT NULL,
    user_id character varying(32),
    name character varying(64),
    saved integer,
    can_read text,
    can_write text,
    center_lat double precision,
    center_lon double precision
);


ALTER TABLE public.maps OWNER TO cesansim;

--
-- Name: maps_id_seq; Type: SEQUENCE; Schema: public; Owner: cesansim
--

CREATE SEQUENCE maps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.maps_id_seq OWNER TO cesansim;

--
-- Name: maps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: cesansim
--

ALTER SEQUENCE maps_id_seq OWNED BY maps.id;


--
-- Name: pictures; Type: TABLE; Schema: public; Owner: cesansim; Tablespace: 
--

CREATE TABLE pictures (
    id integer NOT NULL,
    caption character varying(256),
    type character varying(32),
    base64 text
);


ALTER TABLE public.pictures OWNER TO cesansim;

--
-- Name: pictures_id_seq; Type: SEQUENCE; Schema: public; Owner: cesansim
--

CREATE SEQUENCE pictures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pictures_id_seq OWNER TO cesansim;

--
-- Name: pictures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: cesansim
--

ALTER SEQUENCE pictures_id_seq OWNED BY pictures.id;


--
-- Name: pois; Type: TABLE; Schema: public; Owner: cesansim; Tablespace: 
--

CREATE TABLE pois (
    id integer NOT NULL,
    map_id integer,
    name character varying(64),
    lon double precision,
    lat double precision,
    description text,
    extended_data text,
    poi_type character varying(32),
    saved timestamp without time zone
);


ALTER TABLE public.pois OWNER TO cesansim;

--
-- Name: pois_id_seq; Type: SEQUENCE; Schema: public; Owner: cesansim
--

CREATE SEQUENCE pois_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pois_id_seq OWNER TO cesansim;

--
-- Name: pois_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: cesansim
--

ALTER SEQUENCE pois_id_seq OWNED BY pois.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: cesansim; Tablespace: 
--

CREATE TABLE roles (
    id integer NOT NULL,
    role text
);


ALTER TABLE public.roles OWNER TO cesansim;

--
-- Name: user_role; Type: TABLE; Schema: public; Owner: cesansim; Tablespace: 
--

CREATE TABLE user_role (
    user_id character varying(128) NOT NULL,
    role_id integer NOT NULL
);


ALTER TABLE public.user_role OWNER TO cesansim;

--
-- Name: users; Type: TABLE; Schema: public; Owner: cesansim; Tablespace: 
--

CREATE TABLE users (
    id character varying(128) NOT NULL,
    username character varying(128),
    given_name character varying(128),
    family_name character varying(128),
    email character varying(128),
    password character varying(128),
    uid character varying(64)
);


ALTER TABLE public.users OWNER TO cesansim;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: cesansim
--

ALTER TABLE ONLY book_items ALTER COLUMN id SET DEFAULT nextval('book_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: cesansim
--

ALTER TABLE ONLY books ALTER COLUMN id SET DEFAULT nextval('books_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: cesansim
--

ALTER TABLE ONLY maps ALTER COLUMN id SET DEFAULT nextval('maps_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: cesansim
--

ALTER TABLE ONLY pictures ALTER COLUMN id SET DEFAULT nextval('pictures_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: cesansim
--

ALTER TABLE ONLY pois ALTER COLUMN id SET DEFAULT nextval('pois_id_seq'::regclass);


--
-- Name: book_items_pkey; Type: CONSTRAINT; Schema: public; Owner: cesansim; Tablespace: 
--

ALTER TABLE ONLY book_items
    ADD CONSTRAINT book_items_pkey PRIMARY KEY (id);


--
-- Name: books_pkey; Type: CONSTRAINT; Schema: public; Owner: cesansim; Tablespace: 
--

ALTER TABLE ONLY books
    ADD CONSTRAINT books_pkey PRIMARY KEY (id);


--
-- Name: maps_pkey; Type: CONSTRAINT; Schema: public; Owner: cesansim; Tablespace: 
--

ALTER TABLE ONLY maps
    ADD CONSTRAINT maps_pkey PRIMARY KEY (id);


--
-- Name: pictures_pkey; Type: CONSTRAINT; Schema: public; Owner: cesansim; Tablespace: 
--

ALTER TABLE ONLY pictures
    ADD CONSTRAINT pictures_pkey PRIMARY KEY (id);


--
-- Name: pois_pkey; Type: CONSTRAINT; Schema: public; Owner: cesansim; Tablespace: 
--

ALTER TABLE ONLY pois
    ADD CONSTRAINT pois_pkey PRIMARY KEY (id);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: cesansim; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: user_role_pkey; Type: CONSTRAINT; Schema: public; Owner: cesansim; Tablespace: 
--

ALTER TABLE ONLY user_role
    ADD CONSTRAINT user_role_pkey PRIMARY KEY (user_id, role_id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: cesansim; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: update_customer_modtime; Type: TRIGGER; Schema: public; Owner: cesansim
--

CREATE TRIGGER update_customer_modtime BEFORE UPDATE ON pois FOR EACH ROW EXECUTE PROCEDURE update_modified_column();


--
-- Name: user_role_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: cesansim
--

ALTER TABLE ONLY user_role
    ADD CONSTRAINT user_role_role_id_fkey FOREIGN KEY (role_id) REFERENCES roles(id);


--
-- Name: user_role_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: cesansim
--

ALTER TABLE ONLY user_role
    ADD CONSTRAINT user_role_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: cesansim
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM cesansim;
GRANT ALL ON SCHEMA public TO cesansim;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

