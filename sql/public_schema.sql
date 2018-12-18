/* ---------------------------------------------------- */
/*  Generated by Enterprise Architect Version 12.0 	*/
/*  Created On : 13-nov-2018 08:46:28 			*/
/*  DBMS       : PostgreSQL 				*/
/* ---------------------------------------------------- */

/* Drop Sequences for Autonumber Columns */

DROP SEQUENCE IF EXISTS isik_isik_id_seq
;

/* Drop Tables */

DROP TABLE IF EXISTS amet CASCADE
;

DROP TABLE IF EXISTS isiku_seisundi_liik CASCADE
;

DROP TABLE IF EXISTS kliendi_seisundi_liik CASCADE
;

DROP TABLE IF EXISTS laua_asukoht CASCADE
;

DROP TABLE IF EXISTS laua_kategooria_tyyp CASCADE
;

DROP TABLE IF EXISTS laua_kategooria CASCADE
;

DROP TABLE IF EXISTS laua_materjal CASCADE
;

DROP TABLE IF EXISTS laua_seisundi_liik CASCADE
;

DROP TABLE IF EXISTS riik CASCADE
;

DROP TABLE IF EXISTS tootaja_seisundi_liik CASCADE
;

DROP TABLE IF EXISTS isik CASCADE
;

DROP TABLE IF EXISTS klient CASCADE
;

DROP TABLE IF EXISTS tootaja CASCADE
;

DROP TABLE IF EXISTS laud CASCADE
;

DROP TABLE IF EXISTS laua_kategooria_omamine CASCADE
;

DROP FOREIGN TABLE IF EXISTS riik_jsonb CASCADE
;

DROP FOREIGN TABLE IF EXISTS isik_jsonb CASCADE
;

DROP USER MAPPING IF EXISTS FOR t164844 SERVER minu_testandmete_server_apex
;

DROP SERVER IF EXISTS minu_testandmete_server_apex CASCADE
;

DROP EXTENSION IF EXISTS postgres_fdw CASCADE
;

/* Drop Domains */

DROP DOMAIN IF EXISTS d_nimetus
;

DROP DOMAIN IF EXISTS d_reg_aeg
;

/* Create Domains */

CREATE DOMAIN d_nimetus VARCHAR(255) NOT NULL
CONSTRAINT chk_d_nimetus CHECK (trim(VALUE) <> '')
;

CREATE DOMAIN d_reg_aeg timestamp without time zone NOT NULL DEFAULT LOCALTIMESTAMP
CONSTRAINT chk_d_reg_aeg CHECK (VALUE BETWEEN '2010-01-01 00:00:00' AND '2100-12-31 23:59:59')
;

/* Create Tables */

CREATE TABLE amet
(
amet_kood SMALLINT NOT NULL,
nimetus d_nimetus,
kirjeldus TEXT NULL,
CONSTRAINT pk_amet_amet_kood PRIMARY KEY (amet_kood),
CONSTRAINT uc_amet_nimetus UNIQUE (nimetus),
CONSTRAINT chk_amet_kirjeldus CHECK (trim(kirjeldus) <> '' AND char_length(kirjeldus) <= 4000)
) WITH (fillfactor=90)
;

CREATE TABLE isiku_seisundi_liik
(
isiku_seisundi_liik_kood SMALLINT NOT NULL,
nimetus d_nimetus,
CONSTRAINT pk_isiku_seisundi_liik_isiku_seisundi_liik_kood PRIMARY KEY (isiku_seisundi_liik_kood),
CONSTRAINT uc_isiku_seisundi_liik_nimetus UNIQUE (nimetus)
)
;

CREATE TABLE kliendi_seisundi_liik
(
kliendi_seisundi_liik_kood SMALLINT NOT NULL,
nimetus d_nimetus,
CONSTRAINT pk_kliendi_seisundi_liik_kliendi_seisundi_liik_kood PRIMARY KEY (kliendi_seisundi_liik_kood),
CONSTRAINT uc_kliendi_seisundi_liik_nimetus UNIQUE (nimetus)
)
;

CREATE TABLE laua_asukoht
(
laua_asukoht_kood SMALLINT NOT NULL,
nimetus d_nimetus,
CONSTRAINT pk_laua_asukoht_laua_asukoht_kood PRIMARY KEY (laua_asukoht_kood),
CONSTRAINT uc_laua_asukoht_nimetus UNIQUE (nimetus)
)
;

CREATE TABLE laua_kategooria_tyyp
(
laua_kategooria_tyyp_kood SMALLINT NOT NULL,
nimetus d_nimetus,
CONSTRAINT pk_laua_kategooria_tyyp_laua_kategooria_tyyp_kood PRIMARY KEY (laua_kategooria_tyyp_kood),
CONSTRAINT uc_laua_kategooria_tyyp_nimetus UNIQUE (nimetus)
)
;

CREATE TABLE laua_kategooria
(
laua_kategooria_kood SMALLINT NOT NULL,
laua_kategooria_tyyp_kood SMALLINT NOT NULL,
nimetus d_nimetus,
CONSTRAINT pk_laua_kategooria_laua_kategooria_kood PRIMARY KEY (laua_kategooria_kood),
CONSTRAINT uc_laua_kategooria_nimetus UNIQUE (nimetus),
CONSTRAINT fk_laua_kategooria_laua_kategooria_tyyp_kood FOREIGN KEY (laua_kategooria_tyyp_kood) REFERENCES laua_kategooria_tyyp (laua_kategooria_tyyp_kood) ON DELETE NO ACTION ON UPDATE CASCADE
)
;

CREATE TABLE laua_materjal
(
laua_materjali_kood SMALLINT NOT NULL,
nimetus d_nimetus,
CONSTRAINT pk_laua_materjal_laua_materjali_kood PRIMARY KEY (laua_materjali_kood),
CONSTRAINT uc_laua_materjal_nimetus UNIQUE (nimetus)
)
;

CREATE TABLE laua_seisundi_liik
(
laua_seisundi_liik_kood SMALLINT NOT NULL,
nimetus d_nimetus,
CONSTRAINT pk_laua_seisundi_liik_laua_seisundi_liik_kood PRIMARY KEY (laua_seisundi_liik_kood),
CONSTRAINT uc_laua_seisundi_liik_nimetus UNIQUE (nimetus)
)
;

CREATE TABLE riik
(
riik_kood VARCHAR(3) NOT NULL,
nimetus d_nimetus,
CONSTRAINT pk_riik_riik_kood PRIMARY KEY (riik_kood),
CONSTRAINT uc_riik_nimetus UNIQUE (nimetus),
CONSTRAINT chk_riik_riik_kood CHECK (riik_kood ~ '^[A-Z]{3}$')
)
;

CREATE TABLE tootaja_seisundi_liik
(
tootaja_seisundi_liik_kood SMALLINT NOT NULL,
nimetus d_nimetus,
CONSTRAINT pk_tootaja_seisundi_liik_tootaja_seisundi_liik_kood PRIMARY KEY (tootaja_seisundi_liik_kood),
CONSTRAINT uc_tootaja_seisundi_liik_nimetus UNIQUE (nimetus)
)
;

CREATE TABLE isik
(
isik_id INTEGER NOT NULL DEFAULT nextval(('isik_isik_id_seq'::text)::regclass),
isiku_seisundi_liik_kood SMALLINT NOT NULL DEFAULT 1,
riik_kood VARCHAR(3) NOT NULL,
e_meil VARCHAR(254) NOT NULL,
parool VARCHAR(100) NOT NULL,
isikukood VARCHAR(50) NOT NULL,
reg_aeg d_reg_aeg,
synni_kp date NOT NULL,
eesnimi VARCHAR(1000) NULL,
perenimi VARCHAR(1000) NULL,
elukoht VARCHAR(1000) NULL,
CONSTRAINT pk_isik_isik_id PRIMARY KEY (isik_id),
CONSTRAINT uc_isik_riik_kood_isikukood UNIQUE (riik_kood,isikukood),
CONSTRAINT uc_isik_e_meil UNIQUE (e_meil),
CONSTRAINT chck_isik_eesnimi CHECK (trim(eesnimi) <> ''),
CONSTRAINT chck_isik_perenimi CHECK (trim(perenimi) <> ''),
CONSTRAINT chk_isik_eesnimi_perenimi CHECK (eesnimi IS NOT NULL OR perenimi IS NOT NULL),
CONSTRAINT chk_isik_e_meil CHECK (e_meil LIKE '%@%' AND 
e_meil NOT LIKE '%@%@%'),
CONSTRAINT chk_isik_isikukood CHECK (trim(isikukood) <> '' AND
isikukood ~* '^[a-z0-9 -\/]+$'),
CONSTRAINT chk_isik_parool CHECK (trim(parool) <> ''),
CONSTRAINT chk_isik_synni_kp_reg_aeg CHECK (synni_kp <= reg_aeg),
CONSTRAINT chk_isik_synni_kp CHECK (synni_kp >= '1900-01-01 00:00:00'::timestamp without time zone AND synni_kp <= '2100-12-31 23:59:59'::timestamp without time zone),
CONSTRAINT chk_isik_elukoht CHECK (trim(elukoht) <> ''),
CONSTRAINT fk_isik_isiku_seisundi_liik_kood FOREIGN KEY (isiku_seisundi_liik_kood) REFERENCES isiku_seisundi_liik (isiku_seisundi_liik_kood) ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT fk_isik_riik_kood FOREIGN KEY (riik_kood) REFERENCES Riik (riik_kood) ON DELETE NO ACTION ON UPDATE CASCADE
) WITH (fillfactor=90)
;

CREATE TABLE klient
(
isik_id INTEGER NOT NULL,
kliendi_seisundi_liik_kood SMALLINT NOT NULL DEFAULT 1,
on_nous_tylitamisega boolean NOT NULL DEFAULT false,
CONSTRAINT pk_klient_isik_id PRIMARY KEY (isik_id),
CONSTRAINT fk_klient_isik_id FOREIGN KEY (isik_id) REFERENCES isik (isik_id) ON DELETE CASCADE ON UPDATE NO ACTION,
CONSTRAINT fk_klient_kliendi_seisundi_liik_kood FOREIGN KEY (kliendi_seisundi_liik_kood) REFERENCES kliendi_seisundi_liik (kliendi_seisundi_liik_kood) ON DELETE NO ACTION ON UPDATE CASCADE
) WITH (fillfactor=90)
;

CREATE TABLE tootaja
(
isik_id INTEGER NOT NULL,
amet_kood SMALLINT NOT NULL,
tootaja_seisundi_liik_kood SMALLINT NOT NULL DEFAULT 1,
mentor INTEGER NULL,
CONSTRAINT pk_tootaja_isik_id PRIMARY KEY (isik_id),
CONSTRAINT chk_tootaja_mentor CHECK (mentor <> isik_id),
CONSTRAINT fk_tootaja_isik_id FOREIGN KEY (isik_id) REFERENCES isik (isik_id) ON DELETE CASCADE ON UPDATE NO ACTION,
CONSTRAINT fk_tootaja_amet_kood FOREIGN KEY (amet_kood) REFERENCES amet (amet_kood) ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT fk_tootaja_tootaja_seisundi_liik_kood FOREIGN KEY (tootaja_seisundi_liik_kood) REFERENCES tootaja_seisundi_liik (tootaja_seisundi_liik_kood) ON DELETE NO ACTION ON UPDATE CASCADE
) WITH (fillfactor=90)
;

CREATE TABLE laud
(
laua_kood SMALLINT NOT NULL,
laua_asukoht_kood SMALLINT NOT NULL,
laua_seisundi_liik_kood SMALLINT NOT NULL DEFAULT 1,
laua_materjali_kood SMALLINT NOT NULL,
registreerija_id INTEGER NOT NULL,
reg_aeg d_reg_aeg,
kohtade_arv SMALLINT NOT NULL,
laua_kategooria_tyyp_kood SMALLINT NOT NULL,
kommentaar TEXT NULL,
CONSTRAINT pk_laud_laua_kood PRIMARY KEY (laua_kood),
CONSTRAINT chk_laud_kommentaar CHECK (char_length(kommentaar) <= 4000),
CONSTRAINT chk_laud_kohtade_arv CHECK (kohtade_arv > 0 AND kohtade_arv < 17),
CONSTRAINT fk_laud_laua_asukoht_kood FOREIGN KEY (laua_asukoht_kood) REFERENCES laua_asukoht (laua_asukoht_kood) ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT fk_laud_laua_materjali_kood FOREIGN KEY (laua_materjali_kood) REFERENCES laua_materjal (laua_materjali_kood) ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT fk_laud_registreerija_id FOREIGN KEY (registreerija_id) REFERENCES tootaja (isik_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
CONSTRAINT fk_laud_laua_seisundi_liik_kood FOREIGN KEY (laua_seisundi_liik_kood) REFERENCES laua_seisundi_liik (laua_seisundi_liik_kood) ON DELETE NO ACTION ON UPDATE CASCADE
) WITH (fillfactor=90)
;

CREATE TABLE laua_kategooria_omamine
(
laua_kood SMALLINT NOT NULL,
laua_kategooria_kood SMALLINT NOT NULL,
CONSTRAINT pk_laua_kategooria_omamine_laua_kood_laua_kategooria_kood PRIMARY KEY (laua_kood,laua_kategooria_kood),
CONSTRAINT fk_laua_kategooria_omamine_laua_kood FOREIGN KEY (laua_kood) REFERENCES laud (laua_kood) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_laua_kategooria_omamine_laua_kategooria_kood FOREIGN KEY (laua_kategooria_kood) REFERENCES laua_kategooria (laua_kategooria_kood) ON DELETE NO ACTION ON UPDATE CASCADE
)
;

/* Create Table Comments, Sequences for Autonumber Columns */

CREATE SEQUENCE isik_isik_id_seq INCREMENT 1 START 1
;

/* Create Primary Keys, Indexes, Uniques, Checks */

CREATE INDEX ixfk_laua_kategooria_laua_kategooria_tyyp_kood ON laua_kategooria (laua_kategooria_tyyp_kood ASC)
;

CREATE INDEX ixfk_isik_isiku_seisundi_liik_kood ON isik (isiku_seisundi_liik_kood ASC)
;

CREATE INDEX ixfk_klient_kliendi_seisundi_liik_kood ON klient (kliendi_seisundi_liik_kood ASC)
;

CREATE INDEX ixfk_tootaja_tootaja_seisundi_liik_kood ON tootaja (tootaja_seisundi_liik_kood ASC)
;

CREATE INDEX ixfk_laud_laua_asukoht_kood ON laud (laua_asukoht_kood ASC)
;

CREATE INDEX ixfk_laud_laua_seisundi_liik_kood ON laud (laua_seisundi_liik_kood ASC)
;

CREATE INDEX ixfk_laud_registreerija_id ON laud (registreerija_id ASC)
;

CREATE INDEX ixfk_laua_kategooria_omamine_laua_kategooria_kood ON laua_kategooria_omamine (laua_kategooria_kood ASC)
;

CREATE INDEX ixfk_laud_laua_materjali_kood ON laud (laua_materjali_kood ASC)
;

CREATE INDEX ixfk_tootaja_amet_kood ON tootaja (amet_kood ASC)
;
