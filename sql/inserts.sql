INSERT INTO isiku_seisundi_liik (isiku_seisundi_liik_kood, nimetus) VALUES (1, 'Elus');
INSERT INTO isiku_seisundi_liik (isiku_seisundi_liik_kood, nimetus) VALUES (2, 'Surnud');

INSERT INTO kliendi_seisundi_liik (kliendi_seisundi_liik_kood, nimetus) VALUES (1, 'Aktiivne');
INSERT INTO kliendi_seisundi_liik (kliendi_seisundi_liik_kood, nimetus) VALUES (2, 'Mustas nimekirjas');

INSERT INTO laua_seisundi_liik (laua_seisundi_liik_kood, nimetus) VALUES (1, 'Ootel');
INSERT INTO laua_seisundi_liik (laua_seisundi_liik_kood, nimetus) VALUES (2, 'Aktiivne');
INSERT INTO laua_seisundi_liik (laua_seisundi_liik_kood, nimetus) VALUES (3, 'Mitteaktiivne');
INSERT INTO laua_seisundi_liik (laua_seisundi_liik_kood, nimetus) VALUES (4, 'Lõpetatud');

INSERT INTO laua_asukoht (laua_asukoht_kood, nimetus) VALUES (1, 'Saali keskel');
INSERT INTO laua_asukoht (laua_asukoht_kood, nimetus) VALUES (2, 'Tualettruumi juures');
INSERT INTO laua_asukoht (laua_asukoht_kood, nimetus) VALUES (3, 'Akna all');
INSERT INTO laua_asukoht (laua_asukoht_kood, nimetus) VALUES (4, 'Köögiukse juures');

CREATE EXTENSION IF NOT EXISTS postgres_fdw;

CREATE SERVER minu_testandmete_server_apex FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host 'apex.ttu.ee', dbname 'testandmed', port '5432');

CREATE USER MAPPING FOR t164844 SERVER minu_testandmete_server_apex OPTIONS (user 't164844', password '7b4ca47922');

CREATE FOREIGN TABLE riik_jsonb ( riik JSONB ) SERVER minu_testandmete_server_apex;

INSERT INTO riik (riik_kood, nimetus) SELECT riik->>'Alpha-3 code' AS riik_kood, riik->>'English short name lower case' AS nimetus FROM Riik_jsonb;

INSERT INTO laua_kategooria_tyyp (laua_kategooria_tyyp_kood, nimetus) VALUES (1, 'Peolaud');
INSERT INTO laua_kategooria_tyyp (laua_kategooria_tyyp_kood, nimetus) VALUES (2, 'Tavalaud');

INSERT INTO laua_kategooria (laua_kategooria_kood, nimetus, laua_kategooria_tyyp_kood) VALUES (1, 'Eralaud', 2);
INSERT INTO laua_kategooria (laua_kategooria_kood, nimetus, laua_kategooria_tyyp_kood) VALUES (2, 'Paarilaud', 2);
INSERT INTO laua_kategooria (laua_kategooria_kood, nimetus, laua_kategooria_tyyp_kood) VALUES (3, 'Pulmalaud', 1);
INSERT INTO laua_kategooria (laua_kategooria_kood, nimetus, laua_kategooria_tyyp_kood) VALUES (4, 'Peielaud', 1);

INSERT INTO amet (amet_kood, nimetus, kirjeldus) VALUES (1, 'Kokk', 'Valmistab toitu ja koordineerib tööd köögis');
INSERT INTO amet (amet_kood, nimetus, kirjeldus) VALUES (2, 'Kelner', 'Tegeleb klientide teenindamisega');
INSERT INTO amet (amet_kood, nimetus, kirjeldus) VALUES (3, 'Juhataja', 'Juhatab');

INSERT INTO tootaja_seisundi_liik (tootaja_seisundi_liik_kood, nimetus) VALUES (1, 'Katseajal');
INSERT INTO tootaja_seisundi_liik (tootaja_seisundi_liik_kood, nimetus) VALUES (2, 'Tööl');
INSERT INTO tootaja_seisundi_liik (tootaja_seisundi_liik_kood, nimetus) VALUES (3, 'Puhkusel');
INSERT INTO tootaja_seisundi_liik (tootaja_seisundi_liik_kood, nimetus) VALUES (4, 'Haiguslehel');
INSERT INTO tootaja_seisundi_liik (tootaja_seisundi_liik_kood, nimetus) VALUES (5, 'Töösuhe peatatud');
INSERT INTO tootaja_seisundi_liik (tootaja_seisundi_liik_kood, nimetus) VALUES (6, 'Töösuhe lõpetatud');
INSERT INTO tootaja_seisundi_liik (tootaja_seisundi_liik_kood, nimetus) VALUES (7, 'Vallandatud');

INSERT INTO laua_materjal (laua_materjali_kood, nimetus) VALUES (1, 'Puit');
INSERT INTO laua_materjal (laua_materjali_kood, nimetus) VALUES (2, 'Klaas');
INSERT INTO laua_materjal (laua_materjali_kood, nimetus) VALUES (3, 'Raud');
INSERT INTO laua_materjal (laua_materjali_kood, nimetus) VALUES (4, 'Paber');

INSERT INTO isik (e_meil, isikukood, parool, riik_kood, isiku_seisundi_liik_kood, synni_kp, reg_aeg, eesnimi, perenimi, elukoht) VALUES
('test@gmail.com', '397032198', 'parool', 'EST', 1, '1990-01-01', '2018-04-29 19:42:27', 'Mart', 'Mets', 'Rapla Võsa tn 6');

INSERT INTO isik (e_meil, isikukood, parool, riik_kood, isiku_seisundi_liik_kood, synni_kp, reg_aeg, eesnimi, perenimi, elukoht) VALUES
('hello@gmail.com', '397032148', 'password', 'EST', 1, '1990-02-01', '2018-04-30 19:47:31', 'Mihkel', 'Hass', 'Rapla');

INSERT INTO isik (e_meil, isikukood, parool, riik_kood, isiku_seisundi_liik_kood, synni_kp, reg_aeg, eesnimi, elukoht) VALUES
('student@example.com', '39948515', 'examplepass', 'EST', 1, '1999-01-01', '2018-05-25 15:43:11', 'Mati', 'Võru Tamme tn 6');

INSERT INTO isik (e_meil, isikukood, parool, riik_kood, isiku_seisundi_liik_kood, synni_kp, reg_aeg, perenimi, elukoht) VALUES
('student2831@example.com', '39948815', 'examplepass', 'EST', 1, '1999-01-01', '2018-05-25 15:43:11', 'Mass', 'Võru Tamme tn 6');

INSERT INTO isik (e_meil, isikukood, parool, riik_kood, isiku_seisundi_liik_kood, synni_kp, reg_aeg, elukoht) VALUES
('test1234@gmail.com', '394032198', 'parool', 'EST', 1, '1990-01-01', '2018-04-29 19:42:27', 'Rapla Võsa tn 6');

CREATE FOREIGN TABLE isik_jsonb ( isik JSONB ) SERVER minu_testandmete_server_apex;

INSERT INTO isik (riik_kood, isikukood, eesnimi, perenimi, e_meil, synni_kp, isiku_seisundi_liik_kood, parool, elukoht)
(SELECT riik_kood, isikukood, eesnimi, perenimi, e_mail, synni_kp::date, isiku_seisundi_liik_kood::smallint, parool, elukoht FROM
(SELECT isik->>'riik' AS riik_kood,
jsonb_array_elements(isik->'isikud')->>'isikukood' AS isikukood, jsonb_array_elements(isik->'isikud')->>'eesnimi' AS eesnimi, jsonb_array_elements(isik->'isikud')->>'perekonnanimi' AS perenimi, jsonb_array_elements(isik->'isikud')->>'email' AS e_mail, jsonb_array_elements(isik->'isikud')->>'synni_aeg' AS synni_kp, jsonb_array_elements(isik->'isikud')->>'seisund' AS isiku_seisundi_liik_kood, jsonb_array_elements(isik->'isikud')->>'parool' AS parool, jsonb_array_elements(isik->'isikud')->>'aadress' AS elukoht
FROM isik_jsonb)
AS lahteandmed WHERE isiku_seisundi_liik_kood::smallint=1);

INSERT INTO klient (isik_id, kliendi_seisundi_liik_kood, on_nous_tylitamisega) VALUES (8,1,false);

INSERT INTO tootaja (isik_id, amet_kood, tootaja_seisundi_liik_kood) VALUES (8,3,1);
INSERT INTO tootaja (isik_id, amet_kood, tootaja_seisundi_liik_kood, mentor) VALUES (13,2,1,8);

INSERT INTO laud (laua_kood, reg_aeg, kohtade_arv, laua_asukoht_kood, laua_seisundi_liik_kood, isik_id, laua_materjali_kood, kommentaar, laua_kategooria_tyyp_kood) VALUES
(2, '2018-04-27 14:32:23', 1, 1, 2, 8, 3, 'uus laud', 1);

INSERT INTO laud (laua_kood, reg_aeg, kohtade_arv, laua_asukoht_kood, laua_seisundi_liik_kood, isik_id, laua_materjali_kood, kommentaar, laua_kategooria_tyyp_kood) VALUES
(3, '2018-05-27 13:23:22', 16, 2, 2, 8, 2, 'Vajab tõhusamat puhastust', 2);

INSERT INTO laud (laua_kood, reg_aeg, kohtade_arv, laua_asukoht_kood, laua_seisundi_liik_kood, isik_id, laua_materjali_kood, kommentaar, laua_kategooria_tyyp_kood) VALUES
(45, '2018-05-12 19:46:01', 6, 3, 3, 8, 1, '', 2);

INSERT INTO laua_kategooria_omamine (laua_kood, laua_kategooria_kood) VALUES (2,2);
INSERT INTO laua_kategooria_omamine (laua_kood, laua_kategooria_kood) VALUES (2,4);
INSERT INTO laua_kategooria_omamine (laua_kood, laua_kategooria_kood) VALUES (3,2);
INSERT INTO laua_kategooria_omamine (laua_kood, laua_kategooria_kood) VALUES (45,2);
