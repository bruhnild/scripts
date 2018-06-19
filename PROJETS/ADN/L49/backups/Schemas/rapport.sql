--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

-- Started on 2018-05-02 09:44:02

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 18 (class 2615 OID 156527)
-- Name: rapport; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA rapport;


ALTER SCHEMA rapport OWNER TO postgres;

SET search_path = rapport, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 308 (class 1259 OID 157093)
-- Name: opportunites_synthese; Type: TABLE; Schema: rapport; Owner: postgres
--

CREATE TABLE opportunites_synthese (
    id bigint NOT NULL,
    id_opp character varying,
    nom character varying(254),
    com_dep character varying(254),
    emprise character varying,
    travaux character varying(254),
    prev_starr character varying,
    cables character varying,
    typ_cable character varying,
    prog_dsp character varying(254),
    debut_trvx character varying,
    moa character varying,
    nb_suf bigint,
    longueur bigint,
    nb_chb_exists bigint,
    nb_chb_a_creer bigint,
    nb_chb_desserte bigint,
    nb_chb_transport bigint,
    nb_chb_indef bigint
);


ALTER TABLE opportunites_synthese OWNER TO postgres;

--
-- TOC entry 309 (class 1259 OID 157099)
-- Name: opportunites_typegc; Type: TABLE; Schema: rapport; Owner: postgres
--

CREATE TABLE opportunites_typegc (
    id bigint NOT NULL,
    id_opp character varying,
    prev_starr character varying,
    lg_prev_st integer,
    gc_typ_mut character varying,
    lg_typ_mut bigint,
    gc_typ_int character varying,
    lg_typ_int bigint,
    longueur bigint,
    com_dep character varying(254)
);


ALTER TABLE opportunites_typegc OWNER TO postgres;

--
-- TOC entry 5572 (class 0 OID 157093)
-- Dependencies: 308
-- Data for Name: opportunites_synthese; Type: TABLE DATA; Schema: rapport; Owner: postgres
--

COPY opportunites_synthese (id, id_opp, nom, com_dep, emprise, travaux, prev_starr, cables, typ_cable, prog_dsp, debut_trvx, moa, nb_suf, longueur, nb_chb_exists, nb_chb_a_creer, nb_chb_desserte, nb_chb_transport, nb_chb_indef) FROM stdin;
1	OPP_4-6_LT_26165_LVON_002	COO_2018_LivronSurDrome_EnfouissementDeloche	LIVRON-SUR-DROME	Depart Deloche - PS Loriol	Enfouissement HTA	Aerien BT	1 X 720	X Cables >720	2018	Hiver 2018	Enedis	50	3018	\N	7	2	5	0
\.


--
-- TOC entry 5573 (class 0 OID 157099)
-- Dependencies: 309
-- Data for Name: opportunites_typegc; Type: TABLE DATA; Schema: rapport; Owner: postgres
--

COPY opportunites_typegc (id, id_opp, prev_starr, lg_prev_st, gc_typ_mut, lg_typ_mut, gc_typ_int, lg_typ_int, longueur, com_dep) FROM stdin;
1	OPP_3-XX_LT_26168_LLCH_001	GC a creer	640	Superieur	640	Axe mi-chaussee	640	640	LUS-LA-CROIX-HAUTE
2	OPP_4-36_LT_26146_GGAN_001	Conduite FT	318	Identique	318	Axe mi-chaussee	318	318	CHAMARET
3	OPP_4-36_LT_26146_GGAN_001	Conduite FT	322	Identique	312	Axe mi-chaussee	312	312	CHAMARET
\.


--
-- TOC entry 5380 (class 2606 OID 163756)
-- Name: opportunites_synthese opportunites_synthese_pkey; Type: CONSTRAINT; Schema: rapport; Owner: postgres
--

ALTER TABLE ONLY opportunites_synthese
    ADD CONSTRAINT opportunites_synthese_pkey PRIMARY KEY (id);


--
-- TOC entry 5382 (class 2606 OID 163758)
-- Name: opportunites_typegc opportunites_typegc_pkey; Type: CONSTRAINT; Schema: rapport; Owner: postgres
--

ALTER TABLE ONLY opportunites_typegc
    ADD CONSTRAINT opportunites_typegc_pkey PRIMARY KEY (id);


--
-- TOC entry 5578 (class 0 OID 0)
-- Dependencies: 18
-- Name: rapport; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA rapport TO fdridi;


--
-- TOC entry 5579 (class 0 OID 0)
-- Dependencies: 308
-- Name: opportunites_synthese; Type: ACL; Schema: rapport; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE opportunites_synthese TO vrobert;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE opportunites_synthese TO fdridi;


--
-- TOC entry 5580 (class 0 OID 0)
-- Dependencies: 309
-- Name: opportunites_typegc; Type: ACL; Schema: rapport; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE opportunites_typegc TO vrobert;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE opportunites_typegc TO fdridi;


-- Completed on 2018-05-02 09:44:05

--
-- PostgreSQL database dump complete
--

