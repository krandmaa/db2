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

DROP USER MAPPING FOR t164844 SERVER minu_testandmete_server_apex
;

DROP SERVER IF EXISTS minu_testandmete_server_apex CASCADE
;

DROP EXTENSION IF EXISTS postgres_fdw CASCADE
;

/* Drop Domains */

DROP DOMAIN IF EXISTS d_nimetus_100
;

DROP DOMAIN IF EXISTS d_nimetus_255
;

/* Create Domains */

CREATE DOMAIN d_nimetus_100 varchar(100) NOT NULL
CONSTRAINT chk_d_nimetus_100 CHECK (trim(VALUE) <> '')
;

CREATE DOMAIN d_nimetus_255 varchar(255) NOT NULL
CONSTRAINT chk_d_nimetus_255 CHECK (trim(VALUE) <> '')
;


/* Create Tables */

CREATE TABLE amet
(
amet_kood smallint NOT NULL,
nimetus d_nimetus_255,
kirjeldus text NULL,
CONSTRAINT PK_amet_kood PRIMARY KEY (amet_kood),
CONSTRAINT UC_amet_nimetus UNIQUE (nimetus),
CONSTRAINT chk_amet_kirjeldus CHECK (trim(kirjeldus) <> '')
) WITH (fillfactor=90)
;

CREATE TABLE isiku_seisundi_liik
(
isiku_seisundi_liik_kood smallint NOT NULL,
nimetus d_nimetus_100,
CONSTRAINT PK_isiku_seisundi_liik PRIMARY KEY (isiku_seisundi_liik_kood),
CONSTRAINT UC_isiku_seisundi_liik_nimetus UNIQUE (nimetus)
)
;

CREATE TABLE kliendi_seisundi_liik
(
kliendi_seisundi_liik_kood smallint NOT NULL,
nimetus d_nimetus_100,
CONSTRAINT PK_kliendi_seisundi_liik PRIMARY KEY (kliendi_seisundi_liik_kood),
CONSTRAINT UC_kliendi_seisundi_liik_nimetus UNIQUE (nimetus)
)
;

CREATE TABLE laua_asukoht
(
laua_asukoht_kood smallint NOT NULL,
nimetus d_nimetus_255,
CONSTRAINT PK_laua_asukoht_kood PRIMARY KEY (laua_asukoht_kood),
CONSTRAINT UC_laua_asukoht_kirjeldus UNIQUE (nimetus)
)
;

CREATE TABLE laua_kategooria_tyyp
(
laua_kategooria_tyyp_kood smallint NOT NULL,
nimetus d_nimetus_100,
CONSTRAINT PK_laua_kategooria_tyyp PRIMARY KEY (laua_kategooria_tyyp_kood),
CONSTRAINT UC_laua_kategooria_tyyp_nimetus UNIQUE (nimetus)
)
;

CREATE TABLE laua_kategooria
(
laua_kategooria_kood smallint NOT NULL,
laua_kategooria_tyyp_kood smallint NULL,
nimetus d_nimetus_255,
CONSTRAINT PK_laua_kategooria PRIMARY KEY (laua_kategooria_kood),
CONSTRAINT UC_nimetus_tyyp_kood UNIQUE (nimetus),
CONSTRAINT FK_laua_kategooria_laua_kategooria_tyyp FOREIGN KEY (laua_kategooria_tyyp_kood) REFERENCES laua_kategooria_tyyp (laua_kategooria_tyyp_kood) ON DELETE No Action ON UPDATE Cascade
)
;

CREATE TABLE laua_materjal
(
materjali_kood smallint NOT NULL,
nimetus varchar(50) NOT NULL,
CONSTRAINT PK_laua_materjali_kood PRIMARY KEY (materjali_kood),
CONSTRAINT UC_laua_materjal UNIQUE (nimetus),
CONSTRAINT chk_laua_materjal_nimetus CHECK (trim(nimetus) <> '')
)
;

CREATE TABLE laua_seisundi_liik
(
laua_seisundi_liik_kood smallint NOT NULL,
nimetus d_nimetus_100,
CONSTRAINT PK_laua_seisundi_liik PRIMARY KEY (laua_seisundi_liik_kood),
CONSTRAINT UC_laua_seisundi_liik_nimetus UNIQUE (nimetus)
)
;

CREATE TABLE riik
(
riik_kood varchar(3) NOT NULL,
nimetus varchar(100) NOT NULL,
CONSTRAINT PK_riik PRIMARY KEY (riik_kood),
CONSTRAINT UC_riik_nimetus UNIQUE (nimetus),
CONSTRAINT chk_riik_nimetus CHECK (trim(nimetus) <> ''),
CONSTRAINT chk_riik_riik_kood CHECK (trim(riik_kood) <> '' AND
riik_kood LIKE '___')
)
;

CREATE TABLE tootaja_seisundi_liik
(
tootaja_seisundi_liik_kood smallint NOT NULL,
nimetus d_nimetus_100,
CONSTRAINT PK_tootaja_seisundi_liik PRIMARY KEY (tootaja_seisundi_liik_kood),
CONSTRAINT UC_tootaja_seisundi_liik_nimetus UNIQUE (nimetus)
)
;

CREATE TABLE isik
(
isik_id integer NOT NULL DEFAULT nextval(('isik_isik_id_seq'::text)::regclass),
isiku_seisundi_liik_kood smallint NOT NULL DEFAULT 1,
riik_kood varchar(3) NOT NULL,
eesnimi varchar(4000) NULL,
perenimi varchar(4000) NULL,
elukoht varchar(255) NULL,
e_meil varchar(254) NOT NULL,
parool varchar(100) NOT NULL,
isikukood varchar(50) NOT NULL,
reg_aeg timestamp without time zone NOT NULL DEFAULT now()::timestamp(0),
synni_kp date NOT NULL,
CONSTRAINT PK_isik PRIMARY KEY (isik_id),
CONSTRAINT UC_riik_isikukood UNIQUE (riik_kood,isikukood),
CONSTRAINT UC_e_meil UNIQUE (e_meil),
CONSTRAINT chk_isik_eesnimi_perenimi CHECK (trim(eesnimi) <> '' OR trim(perenimi) <> ''),
CONSTRAINT chk_isik_synni_kp CHECK (synni_kp <= reg_aeg AND
synni_kp BETWEEN '1900-01-01' AND '2100-12-31'),
CONSTRAINT chk_isik_e_meil CHECK (e_meil LIKE '%@%' AND 
e_meil NOT LIKE '%@%@%'),
CONSTRAINT chk_isik_isikukood CHECK (trim(isikukood) <> '' AND
isikukood ~ '^[a-zA-Z0-9\/-]+$'),
CONSTRAINT chk_isik_parool CHECK (trim(parool) <> ''),
CONSTRAINT chk_isik_reg_aeg CHECK (reg_aeg BETWEEN '2010-01-01' AND '2100-12-31'),
CONSTRAINT chk_isik_elukoht CHECK (trim(elukoht) <> '' AND
NOT(REPLACE(elukoht, ' ', '') ~ '^[0-9\.]+$')),
CONSTRAINT FK_isik_isiku_seisundi_liik FOREIGN KEY (isiku_seisundi_liik_kood) REFERENCES isiku_seisundi_liik (isiku_seisundi_liik_kood) ON DELETE No Action ON UPDATE Cascade,
CONSTRAINT FK_riik_kood FOREIGN KEY (riik_kood) REFERENCES Riik (riik_kood) ON DELETE No Action ON UPDATE Cascade
) WITH (fillfactor=90)
;

CREATE TABLE klient
(
isik_id integer NOT NULL,
kliendi_seisundi_liik_kood smallint NOT NULL DEFAULT 1,
on_nous_tylitamisega boolean NOT NULL DEFAULT false,
CONSTRAINT PK_klient_Isik PRIMARY KEY (isik_id),
CONSTRAINT FK_klient_Isik FOREIGN KEY (isik_id) REFERENCES isik (isik_id) ON DELETE Cascade ON UPDATE No Action,
CONSTRAINT FK_kliendi_seisundi_liik FOREIGN KEY (kliendi_seisundi_liik_kood) REFERENCES kliendi_seisundi_liik (kliendi_seisundi_liik_kood) ON DELETE No Action ON UPDATE Cascade
) WITH (fillfactor=90)
;

CREATE TABLE tootaja
(
isik_id integer NOT NULL,
amet_kood smallint NOT NULL,
tootaja_seisundi_liik_kood smallint NOT NULL DEFAULT 1,
mentor integer NULL,
CONSTRAINT PK_tootaja PRIMARY KEY (isik_id),
CONSTRAINT chk_tootaja_mentor CHECK (mentor <> isik_id),
CONSTRAINT FK_tootaja_isik FOREIGN KEY (isik_id) REFERENCES isik (isik_id) ON DELETE Cascade ON UPDATE No Action,
CONSTRAINT FK_amet_kood FOREIGN KEY (amet_kood) REFERENCES amet (amet_kood) ON DELETE No Action ON UPDATE Cascade,
CONSTRAINT FK_tootaja_seisundi_liik_kood FOREIGN KEY (tootaja_seisundi_liik_kood) REFERENCES tootaja_seisundi_liik (tootaja_seisundi_liik_kood) ON DELETE No Action ON UPDATE Cascade
) WITH (fillfactor=90)
;

CREATE TABLE laud
(
laua_kood integer NOT NULL,
laua_asukoht_kood smallint NOT NULL,
laua_seisundi_liik_kood smallint NOT NULL DEFAULT 1,
laua_materjali_kood smallint NOT NULL,
isik_id integer NOT NULL,
reg_aeg time without time zone NOT NULL,
kohtade_arv smallint NOT NULL,
laua_kategooria_tyyp_kood smallint NOT NULL,
kommentaar varchar(255)	 NULL,
CONSTRAINT PK_laua_kood PRIMARY KEY (laua_kood),
CONSTRAINT chk_laud_reg_aeg CHECK (reg_aeg BETWEEN '2010-01-01 00:00:00' AND '2100-12-31 23:59:59'),
CONSTRAINT chk_laud_kohtade_arv CHECK (kohtade_arv > 0 AND kohtade_arv < 17),
CONSTRAINT FK_laud_laua_asukoht FOREIGN KEY (laua_asukoht_kood) REFERENCES laua_asukoht (laua_asukoht_kood) ON DELETE No Action ON UPDATE Cascade,
CONSTRAINT FK_laud_laua_materjal FOREIGN KEY (laua_materjali_kood) REFERENCES laua_materjal (materjali_kood) ON DELETE No Action ON UPDATE Cascade,
CONSTRAINT FK_laud_tootaja FOREIGN KEY (isik_id) REFERENCES tootaja (isik_id) ON DELETE No Action ON UPDATE Cascade,
CONSTRAINT FK_laua_seisundi_liik_kood FOREIGN KEY (laua_seisundi_liik_kood) REFERENCES laua_seisundi_liik (laua_seisundi_liik_kood) ON DELETE No Action ON UPDATE Cascade
) WITH (fillfactor=90)
;

CREATE TABLE laua_kategooria_omamine
(
laua_kood smallint NOT NULL,
laua_kategooria_kood smallint NOT NULL,
CONSTRAINT PK_laua_kood_laua_kategooria_omamine PRIMARY KEY (laua_kood,laua_kategooria_kood),
CONSTRAINT FK_laua_kategooria_omamine FOREIGN KEY (laua_kood) REFERENCES laud (laua_kood) ON DELETE Cascade ON UPDATE Cascade,
CONSTRAINT FK_laua_kategooria_kood FOREIGN KEY (laua_kategooria_kood) REFERENCES laua_kategooria (laua_kategooria_kood) ON DELETE No Action ON UPDATE Cascade
)
;

/* Create Table Comments, Sequences for Autonumber Columns */

CREATE SEQUENCE isik_isik_id_seq INCREMENT 1 START 1
;

/* Create Primary Keys, Indexes, Uniques, Checks */

CREATE INDEX IXFK_Laua_kategooria_Laua_kategooria_tyyp ON laua_kategooria (laua_kategooria_tyyp_kood ASC)
;

CREATE INDEX IXFK_Isik_Isiku_seisundi_liik ON isik (isiku_seisundi_liik_kood ASC)
;

CREATE INDEX IXFK_riik_kood ON isik (riik_kood ASC)
;

CREATE INDEX IXFK_kliendi_seisundi_liik ON klient (kliendi_seisundi_liik_kood ASC)
;

CREATE INDEX IXFK_tootaja_seisundi_liik_kood ON tootaja (tootaja_seisundi_liik_kood ASC)
;

CREATE INDEX IXFK_laua_asukoht_kood ON laud (laua_asukoht_kood ASC)
;

CREATE INDEX IXFK_laua_seisundi_liik_kood ON laud (laua_seisundi_liik_kood ASC)
;

CREATE INDEX IXFK_Laud_Laua_asukoht ON laud (laua_asukoht_kood ASC)
;

CREATE INDEX IXFK_Laud_Tootaja ON laud (isik_id ASC)
;
