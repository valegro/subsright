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
-- Name: active_admin_comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE active_admin_comments (
    id integer NOT NULL,
    namespace character varying,
    body text,
    resource_id character varying NOT NULL,
    resource_type character varying NOT NULL,
    author_id integer,
    author_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE active_admin_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE active_admin_comments_id_seq OWNED BY active_admin_comments.id;


--
-- Name: admin_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE admin_users (
    id integer NOT NULL,
    name character varying DEFAULT ''::character varying NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: admin_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE admin_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admin_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE admin_users_id_seq OWNED BY admin_users.id;


--
-- Name: campaigns; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE campaigns (
    id integer NOT NULL,
    name character varying NOT NULL,
    start date,
    finish date,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: campaigns_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE campaigns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: campaigns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE campaigns_id_seq OWNED BY campaigns.id;


--
-- Name: campaigns_offers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE campaigns_offers (
    campaign_id integer NOT NULL,
    offer_id integer NOT NULL
);


--
-- Name: configurations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE configurations (
    id integer NOT NULL,
    key character varying NOT NULL,
    value text,
    form_type character varying NOT NULL,
    form_collection_command character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: configurations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE configurations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: configurations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE configurations_id_seq OWNED BY configurations.id;


--
-- Name: customer_discounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE customer_discounts (
    id integer NOT NULL,
    customer_id integer NOT NULL,
    discount_id integer NOT NULL,
    reference character varying,
    expiry date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: customer_discounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE customer_discounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customer_discounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE customer_discounts_id_seq OWNED BY customer_discounts.id;


--
-- Name: customer_publications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE customer_publications (
    id integer NOT NULL,
    customer_id integer NOT NULL,
    publication_id integer NOT NULL,
    subscribed date NOT NULL,
    expiry date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: customer_publications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE customer_publications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customer_publications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE customer_publications_id_seq OWNED BY customer_publications.id;


--
-- Name: customers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE customers (
    id integer NOT NULL,
    name character varying NOT NULL,
    email character varying,
    phone character varying,
    address text,
    country character varying,
    postcode character varying,
    currency character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE customers_id_seq OWNED BY customers.id;


--
-- Name: discounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE discounts (
    id integer NOT NULL,
    name character varying NOT NULL,
    requestable boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: discounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE discounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: discounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE discounts_id_seq OWNED BY discounts.id;


--
-- Name: discounts_prices; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE discounts_prices (
    discount_id integer NOT NULL,
    price_id integer NOT NULL
);


--
-- Name: offer_products; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE offer_products (
    id integer NOT NULL,
    offer_id integer NOT NULL,
    product_id integer NOT NULL,
    optional boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: offer_products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE offer_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: offer_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE offer_products_id_seq OWNED BY offer_products.id;


--
-- Name: offer_publications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE offer_publications (
    id integer NOT NULL,
    offer_id integer NOT NULL,
    publication_id integer NOT NULL,
    quantity integer NOT NULL,
    unit character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: offer_publications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE offer_publications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: offer_publications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE offer_publications_id_seq OWNED BY offer_publications.id;


--
-- Name: offers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE offers (
    id integer NOT NULL,
    name character varying NOT NULL,
    start date,
    finish date,
    trial_period integer,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: offers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE offers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: offers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE offers_id_seq OWNED BY offers.id;


--
-- Name: offers_prices; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE offers_prices (
    offer_id integer NOT NULL,
    price_id integer NOT NULL
);


--
-- Name: prices; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE prices (
    id integer NOT NULL,
    currency character varying NOT NULL,
    name character varying NOT NULL,
    amount_cents integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: prices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE prices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: prices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE prices_id_seq OWNED BY prices.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE products (
    id integer NOT NULL,
    name character varying NOT NULL,
    stock integer,
    image_file_name character varying,
    image_content_type character varying,
    image_file_size integer,
    image_updated_at timestamp without time zone,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
-- Name: publications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE publications (
    id integer NOT NULL,
    name character varying NOT NULL,
    website character varying NOT NULL,
    image_file_name character varying,
    image_content_type character varying,
    image_file_size integer,
    image_updated_at timestamp without time zone,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: publications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE publications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: publications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE publications_id_seq OWNED BY publications.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY active_admin_comments ALTER COLUMN id SET DEFAULT nextval('active_admin_comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY admin_users ALTER COLUMN id SET DEFAULT nextval('admin_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY campaigns ALTER COLUMN id SET DEFAULT nextval('campaigns_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY configurations ALTER COLUMN id SET DEFAULT nextval('configurations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY customer_discounts ALTER COLUMN id SET DEFAULT nextval('customer_discounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY customer_publications ALTER COLUMN id SET DEFAULT nextval('customer_publications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY customers ALTER COLUMN id SET DEFAULT nextval('customers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY discounts ALTER COLUMN id SET DEFAULT nextval('discounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY offer_products ALTER COLUMN id SET DEFAULT nextval('offer_products_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY offer_publications ALTER COLUMN id SET DEFAULT nextval('offer_publications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY offers ALTER COLUMN id SET DEFAULT nextval('offers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY prices ALTER COLUMN id SET DEFAULT nextval('prices_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY products ALTER COLUMN id SET DEFAULT nextval('products_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY publications ALTER COLUMN id SET DEFAULT nextval('publications_id_seq'::regclass);


--
-- Name: active_admin_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY active_admin_comments
    ADD CONSTRAINT active_admin_comments_pkey PRIMARY KEY (id);


--
-- Name: admin_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY admin_users
    ADD CONSTRAINT admin_users_pkey PRIMARY KEY (id);


--
-- Name: campaigns_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY campaigns
    ADD CONSTRAINT campaigns_pkey PRIMARY KEY (id);


--
-- Name: configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY configurations
    ADD CONSTRAINT configurations_pkey PRIMARY KEY (id);


--
-- Name: customer_discounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY customer_discounts
    ADD CONSTRAINT customer_discounts_pkey PRIMARY KEY (id);


--
-- Name: customer_publications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY customer_publications
    ADD CONSTRAINT customer_publications_pkey PRIMARY KEY (id);


--
-- Name: customers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: discounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY discounts
    ADD CONSTRAINT discounts_pkey PRIMARY KEY (id);


--
-- Name: offer_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY offer_products
    ADD CONSTRAINT offer_products_pkey PRIMARY KEY (id);


--
-- Name: offer_publications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY offer_publications
    ADD CONSTRAINT offer_publications_pkey PRIMARY KEY (id);


--
-- Name: offers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY offers
    ADD CONSTRAINT offers_pkey PRIMARY KEY (id);


--
-- Name: prices_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY prices
    ADD CONSTRAINT prices_pkey PRIMARY KEY (id);


--
-- Name: products_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: publications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY publications
    ADD CONSTRAINT publications_pkey PRIMARY KEY (id);


--
-- Name: index_active_admin_comments_on_author_type_and_author_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_author_type_and_author_id ON active_admin_comments USING btree (author_type, author_id);


--
-- Name: index_active_admin_comments_on_namespace; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_namespace ON active_admin_comments USING btree (namespace);


--
-- Name: index_active_admin_comments_on_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_resource_type_and_resource_id ON active_admin_comments USING btree (resource_type, resource_id);


--
-- Name: index_admin_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admin_users_on_confirmation_token ON admin_users USING btree (confirmation_token);


--
-- Name: index_admin_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admin_users_on_email ON admin_users USING btree (email);


--
-- Name: index_admin_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admin_users_on_reset_password_token ON admin_users USING btree (reset_password_token);


--
-- Name: index_admin_users_on_unlock_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admin_users_on_unlock_token ON admin_users USING btree (unlock_token);


--
-- Name: index_campaigns_offers_on_campaign_id_and_offer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_campaigns_offers_on_campaign_id_and_offer_id ON campaigns_offers USING btree (campaign_id, offer_id);


--
-- Name: index_configurations_on_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_configurations_on_key ON configurations USING btree (key);


--
-- Name: index_customer_discounts_on_customer_id_and_discount_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_customer_discounts_on_customer_id_and_discount_id ON customer_discounts USING btree (customer_id, discount_id);


--
-- Name: index_customer_publications_on_customer_id_and_publication_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_customer_publications_on_customer_id_and_publication_id ON customer_publications USING btree (customer_id, publication_id);


--
-- Name: index_discounts_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_discounts_on_name ON discounts USING btree (name);


--
-- Name: index_discounts_prices_on_discount_id_and_price_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_discounts_prices_on_discount_id_and_price_id ON discounts_prices USING btree (discount_id, price_id);


--
-- Name: index_offer_products_on_offer_id_and_product_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_offer_products_on_offer_id_and_product_id ON offer_products USING btree (offer_id, product_id);


--
-- Name: index_offer_publications_on_offer_id_and_publication_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_offer_publications_on_offer_id_and_publication_id ON offer_publications USING btree (offer_id, publication_id);


--
-- Name: index_offers_prices_on_offer_id_and_price_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_offers_prices_on_offer_id_and_price_id ON offers_prices USING btree (offer_id, price_id);


--
-- Name: index_prices_on_currency_and_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_prices_on_currency_and_name ON prices USING btree (currency, name);


--
-- Name: index_products_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_products_on_name ON products USING btree (name);


--
-- Name: index_publications_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_publications_on_name ON publications USING btree (name);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_233b827326; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY customer_publications
    ADD CONSTRAINT fk_rails_233b827326 FOREIGN KEY (publication_id) REFERENCES publications(id);


--
-- Name: fk_rails_7f4e35a9b6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY customer_publications
    ADD CONSTRAINT fk_rails_7f4e35a9b6 FOREIGN KEY (customer_id) REFERENCES customers(id);


--
-- Name: fk_rails_82814ea6c7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY offers_prices
    ADD CONSTRAINT fk_rails_82814ea6c7 FOREIGN KEY (price_id) REFERENCES prices(id);


--
-- Name: fk_rails_8de0e6694c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY offer_publications
    ADD CONSTRAINT fk_rails_8de0e6694c FOREIGN KEY (publication_id) REFERENCES publications(id);


--
-- Name: fk_rails_9b76ac0276; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY offer_publications
    ADD CONSTRAINT fk_rails_9b76ac0276 FOREIGN KEY (offer_id) REFERENCES offers(id);


--
-- Name: fk_rails_a14f06721e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY offers_prices
    ADD CONSTRAINT fk_rails_a14f06721e FOREIGN KEY (offer_id) REFERENCES offers(id);


--
-- Name: fk_rails_a9ae35ca88; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY offer_products
    ADD CONSTRAINT fk_rails_a9ae35ca88 FOREIGN KEY (offer_id) REFERENCES offers(id);


--
-- Name: fk_rails_aba2be40a4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY discounts_prices
    ADD CONSTRAINT fk_rails_aba2be40a4 FOREIGN KEY (discount_id) REFERENCES discounts(id);


--
-- Name: fk_rails_beaddbe013; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY campaigns_offers
    ADD CONSTRAINT fk_rails_beaddbe013 FOREIGN KEY (campaign_id) REFERENCES campaigns(id);


--
-- Name: fk_rails_d30bc7a030; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY campaigns_offers
    ADD CONSTRAINT fk_rails_d30bc7a030 FOREIGN KEY (offer_id) REFERENCES offers(id);


--
-- Name: fk_rails_e472f80643; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY customer_discounts
    ADD CONSTRAINT fk_rails_e472f80643 FOREIGN KEY (discount_id) REFERENCES discounts(id);


--
-- Name: fk_rails_f08974d62d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY customer_discounts
    ADD CONSTRAINT fk_rails_f08974d62d FOREIGN KEY (customer_id) REFERENCES customers(id);


--
-- Name: fk_rails_f60819046f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY discounts_prices
    ADD CONSTRAINT fk_rails_f60819046f FOREIGN KEY (price_id) REFERENCES prices(id);


--
-- Name: fk_rails_f8c9422a0e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY offer_products
    ADD CONSTRAINT fk_rails_f8c9422a0e FOREIGN KEY (product_id) REFERENCES products(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20141110091050');

INSERT INTO schema_migrations (version) VALUES ('20141110091053');

INSERT INTO schema_migrations (version) VALUES ('20150107131931');

INSERT INTO schema_migrations (version) VALUES ('20150210013631');

INSERT INTO schema_migrations (version) VALUES ('20150210051847');

INSERT INTO schema_migrations (version) VALUES ('20150210060735');

INSERT INTO schema_migrations (version) VALUES ('20150224061319');

INSERT INTO schema_migrations (version) VALUES ('20150405024749');

INSERT INTO schema_migrations (version) VALUES ('20150408070342');

INSERT INTO schema_migrations (version) VALUES ('20150408080305');

INSERT INTO schema_migrations (version) VALUES ('20150414055657');

INSERT INTO schema_migrations (version) VALUES ('20150414055940');

INSERT INTO schema_migrations (version) VALUES ('20150414071040');

INSERT INTO schema_migrations (version) VALUES ('20150416101046');

INSERT INTO schema_migrations (version) VALUES ('20150420081806');

INSERT INTO schema_migrations (version) VALUES ('20150503140739');

INSERT INTO schema_migrations (version) VALUES ('20150510060753');

