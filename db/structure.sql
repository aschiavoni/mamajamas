--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
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


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: age_ranges; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE age_ranges (
    id integer NOT NULL,
    name character varying(255),
    "position" integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: age_ranges_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE age_ranges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: age_ranges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE age_ranges_id_seq OWNED BY age_ranges.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE categories (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    slug character varying(255)
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


--
-- Name: friendly_id_slugs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE friendly_id_slugs (
    id integer NOT NULL,
    slug character varying(255) NOT NULL,
    sluggable_id integer NOT NULL,
    sluggable_type character varying(40),
    created_at timestamp without time zone
);


--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE friendly_id_slugs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE friendly_id_slugs_id_seq OWNED BY friendly_id_slugs.id;


--
-- Name: kids; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE kids (
    id integer NOT NULL,
    name character varying(255),
    gender character varying(255),
    birthday date,
    age_range_id integer,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: kids_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE kids_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: kids_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE kids_id_seq OWNED BY kids.id;


--
-- Name: list_item_images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE list_item_images (
    id integer NOT NULL,
    user_id integer,
    image character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: list_item_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE list_item_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: list_item_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE list_item_images_id_seq OWNED BY list_item_images.id;


--
-- Name: list_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE list_items (
    id integer NOT NULL,
    list_id integer,
    name character varying(255),
    owned boolean,
    link character varying(255),
    rating integer,
    priority integer,
    notes text,
    image_url character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    product_type_id integer,
    category_id integer,
    age_range_id integer,
    placeholder boolean DEFAULT false NOT NULL,
    product_type_name character varying(255),
    list_item_image_id integer,
    shared boolean DEFAULT false NOT NULL
);


--
-- Name: list_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE list_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: list_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE list_items_id_seq OWNED BY list_items.id;


--
-- Name: lists; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE lists (
    id integer NOT NULL,
    title character varying(255),
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    public boolean DEFAULT false NOT NULL,
    view_count integer DEFAULT 0 NOT NULL,
    public_view_count integer DEFAULT 0 NOT NULL
);


--
-- Name: lists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE lists_id_seq OWNED BY lists.id;


--
-- Name: product_type_queries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE product_type_queries (
    id integer NOT NULL,
    product_type_id integer,
    query character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: product_type_queries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE product_type_queries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_type_queries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE product_type_queries_id_seq OWNED BY product_type_queries.id;


--
-- Name: product_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE product_types (
    id integer NOT NULL,
    category_id integer,
    name character varying(255),
    priority integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    slug character varying(255),
    image_name character varying(255),
    age_range_id integer,
    user_id integer,
    plural_name character varying(255)
);


--
-- Name: product_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE product_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE product_types_id_seq OWNED BY product_types.id;


--
-- Name: product_types_products; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE product_types_products (
    id integer NOT NULL,
    product_type_id integer,
    product_id integer
);


--
-- Name: product_types_products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE product_types_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_types_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE product_types_products_id_seq OWNED BY product_types_products.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE products (
    id integer NOT NULL,
    vendor_id character varying(255),
    vendor character varying(255),
    name character varying(255),
    url character varying(255),
    rating integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    image_url character varying(255),
    sales_rank integer,
    brand character varying(255),
    manufacturer character varying(255),
    model character varying(255),
    department character varying(255),
    categories character varying(255),
    price character varying(255),
    medium_image_url character varying(255),
    large_image_url character varying(255)
);


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE products_id_seq OWNED BY products.id;


--
-- Name: relationships; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE relationships (
    id integer NOT NULL,
    follower_id integer,
    followed_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    delivered_notification_at timestamp without time zone
);


--
-- Name: relationships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE relationships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: relationships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE relationships_id_seq OWNED BY relationships.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    username character varying(255) DEFAULT ''::character varying NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    confirmation_token character varying(255),
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    provider character varying(255),
    uid character varying(255),
    access_token character varying(255),
    access_token_expires_at timestamp without time zone,
    first_name character varying(255),
    last_name character varying(255),
    facebook_friends text,
    facebook_friends_updated_at timestamp without time zone,
    relationships_created_at timestamp without time zone,
    birthday date,
    profile_picture character varying(255),
    slug character varying(255),
    notes text,
    zip_code character varying(255),
    guest boolean DEFAULT false NOT NULL,
    country_code character varying(255) DEFAULT 'US'::character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY age_ranges ALTER COLUMN id SET DEFAULT nextval('age_ranges_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY friendly_id_slugs ALTER COLUMN id SET DEFAULT nextval('friendly_id_slugs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY kids ALTER COLUMN id SET DEFAULT nextval('kids_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY list_item_images ALTER COLUMN id SET DEFAULT nextval('list_item_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY list_items ALTER COLUMN id SET DEFAULT nextval('list_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY lists ALTER COLUMN id SET DEFAULT nextval('lists_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY product_type_queries ALTER COLUMN id SET DEFAULT nextval('product_type_queries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY product_types ALTER COLUMN id SET DEFAULT nextval('product_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY product_types_products ALTER COLUMN id SET DEFAULT nextval('product_types_products_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY products ALTER COLUMN id SET DEFAULT nextval('products_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY relationships ALTER COLUMN id SET DEFAULT nextval('relationships_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: friendly_id_slugs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY friendly_id_slugs
    ADD CONSTRAINT friendly_id_slugs_pkey PRIMARY KEY (id);


--
-- Name: kids_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY kids
    ADD CONSTRAINT kids_pkey PRIMARY KEY (id);


--
-- Name: list_item_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY list_item_images
    ADD CONSTRAINT list_item_images_pkey PRIMARY KEY (id);


--
-- Name: list_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY list_items
    ADD CONSTRAINT list_items_pkey PRIMARY KEY (id);


--
-- Name: lists_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lists
    ADD CONSTRAINT lists_pkey PRIMARY KEY (id);


--
-- Name: product_type_queries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY product_type_queries
    ADD CONSTRAINT product_type_queries_pkey PRIMARY KEY (id);


--
-- Name: product_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY product_types
    ADD CONSTRAINT product_types_pkey PRIMARY KEY (id);


--
-- Name: product_types_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY product_types_products
    ADD CONSTRAINT product_types_products_pkey PRIMARY KEY (id);


--
-- Name: products_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: relationships_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY relationships
    ADD CONSTRAINT relationships_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: when_to_buy_suggestions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY age_ranges
    ADD CONSTRAINT when_to_buy_suggestions_pkey PRIMARY KEY (id);


--
-- Name: index_categories_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_categories_on_slug ON categories USING btree (slug);


--
-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type ON friendly_id_slugs USING btree (slug, sluggable_type);


--
-- Name: index_friendly_id_slugs_on_sluggable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_id ON friendly_id_slugs USING btree (sluggable_id);


--
-- Name: index_friendly_id_slugs_on_sluggable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_type ON friendly_id_slugs USING btree (sluggable_type);


--
-- Name: index_kids_on_age_range_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_kids_on_age_range_id ON kids USING btree (age_range_id);


--
-- Name: index_kids_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_kids_on_user_id ON kids USING btree (user_id);


--
-- Name: index_list_item_images_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_list_item_images_on_user_id ON list_item_images USING btree (user_id);


--
-- Name: index_list_items_on_category_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_list_items_on_category_id ON list_items USING btree (category_id);


--
-- Name: index_list_items_on_list_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_list_items_on_list_id ON list_items USING btree (list_id);


--
-- Name: index_lists_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_lists_on_user_id ON lists USING btree (user_id);


--
-- Name: index_product_type_queries_on_product_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_product_type_queries_on_product_type_id ON product_type_queries USING btree (product_type_id);


--
-- Name: index_product_types_on_category_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_product_types_on_category_id ON product_types USING btree (category_id);


--
-- Name: index_product_types_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_product_types_on_slug ON product_types USING btree (slug);


--
-- Name: index_relationships_on_followed_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_relationships_on_followed_id ON relationships USING btree (followed_id);


--
-- Name: index_relationships_on_follower_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_relationships_on_follower_id ON relationships USING btree (follower_id);


--
-- Name: index_relationships_on_follower_id_and_followed_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_relationships_on_follower_id_and_followed_id ON relationships USING btree (follower_id, followed_id);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_slug ON users USING btree (slug);


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_username ON users USING btree (username);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20121005151529');

INSERT INTO schema_migrations (version) VALUES ('20121016184106');

INSERT INTO schema_migrations (version) VALUES ('20121019193700');

INSERT INTO schema_migrations (version) VALUES ('20121024193404');

INSERT INTO schema_migrations (version) VALUES ('20121029220502');

INSERT INTO schema_migrations (version) VALUES ('20121030215922');

INSERT INTO schema_migrations (version) VALUES ('20121107203643');

INSERT INTO schema_migrations (version) VALUES ('20121107203814');

INSERT INTO schema_migrations (version) VALUES ('20121108220731');

INSERT INTO schema_migrations (version) VALUES ('20121109185633');

INSERT INTO schema_migrations (version) VALUES ('20121114161425');

INSERT INTO schema_migrations (version) VALUES ('20121115182005');

INSERT INTO schema_migrations (version) VALUES ('20121119215834');

INSERT INTO schema_migrations (version) VALUES ('20121121152029');

INSERT INTO schema_migrations (version) VALUES ('20121128181325');

INSERT INTO schema_migrations (version) VALUES ('20121129151932');

INSERT INTO schema_migrations (version) VALUES ('20121130170806');

INSERT INTO schema_migrations (version) VALUES ('20121204170720');

INSERT INTO schema_migrations (version) VALUES ('20121204174816');

INSERT INTO schema_migrations (version) VALUES ('20121204174922');

INSERT INTO schema_migrations (version) VALUES ('20121204183742');

INSERT INTO schema_migrations (version) VALUES ('20121204183756');

INSERT INTO schema_migrations (version) VALUES ('20121211180449');

INSERT INTO schema_migrations (version) VALUES ('20121211181547');

INSERT INTO schema_migrations (version) VALUES ('20121211193457');

INSERT INTO schema_migrations (version) VALUES ('20121213204732');

INSERT INTO schema_migrations (version) VALUES ('20121222054233');

INSERT INTO schema_migrations (version) VALUES ('20130102180822');

INSERT INTO schema_migrations (version) VALUES ('20130109023249');

INSERT INTO schema_migrations (version) VALUES ('20130121163520');

INSERT INTO schema_migrations (version) VALUES ('20130124194401');

INSERT INTO schema_migrations (version) VALUES ('20130125162246');

INSERT INTO schema_migrations (version) VALUES ('20130129181649');

INSERT INTO schema_migrations (version) VALUES ('20130201223038');

INSERT INTO schema_migrations (version) VALUES ('20130214152701');

INSERT INTO schema_migrations (version) VALUES ('20130214154635');

INSERT INTO schema_migrations (version) VALUES ('20130228204357');

INSERT INTO schema_migrations (version) VALUES ('20130305004902');

INSERT INTO schema_migrations (version) VALUES ('20130305144407');

INSERT INTO schema_migrations (version) VALUES ('20130305171848');

INSERT INTO schema_migrations (version) VALUES ('20130325154823');

INSERT INTO schema_migrations (version) VALUES ('20130325171327');

INSERT INTO schema_migrations (version) VALUES ('20130328181759');

INSERT INTO schema_migrations (version) VALUES ('20130401152046');

INSERT INTO schema_migrations (version) VALUES ('20130408152451');

INSERT INTO schema_migrations (version) VALUES ('20130416030254');

INSERT INTO schema_migrations (version) VALUES ('20130416044946');

INSERT INTO schema_migrations (version) VALUES ('20130503222311');

INSERT INTO schema_migrations (version) VALUES ('20130504140158');

INSERT INTO schema_migrations (version) VALUES ('20130514155705');

INSERT INTO schema_migrations (version) VALUES ('20130516222507');

INSERT INTO schema_migrations (version) VALUES ('20130611000152');

INSERT INTO schema_migrations (version) VALUES ('20130611162641');

INSERT INTO schema_migrations (version) VALUES ('20130621115725');

INSERT INTO schema_migrations (version) VALUES ('20130622184714');

INSERT INTO schema_migrations (version) VALUES ('20130624030937');