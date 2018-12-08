/* DROP VIEW */

DROP VIEW IF EXISTS laud_aktiivne_mitteaktiivne;
DROP VIEW IF EXISTS laud_koik_seisundid;
DROP VIEW IF EXISTS laud_detailid;
DROP VIEW IF EXISTS laud_kategooria;
DROP VIEW IF EXISTS laud_koondaruanne;

/* CREATE VIEW */

CREATE OR REPLACE VIEW laud_aktiivne_mitteaktiivne WITH (security_barrier) AS SELECT Laud.laua_kood, Laua_asukoht.nimetus AS asukoht, Laua_seisundi_liik.nimetus AS laua_seisund
FROM Laud, Laua_asukoht, Laua_seisundi_liik
WHERE Laua_seisundi_liik.laua_seisundi_liik_kood = Laud.laua_seisundi_liik_kood AND Laud.laua_asukoht_kood = Laua_asukoht.laua_asukoht_kood AND Laud.laua_seisundi_liik_kood In (2,3);
COMMENT ON VIEW laud_aktiivne_mitteaktiivne IS 'Vaade leiab andmed aktiivsetest ja mitteaktiivsetest laudadest. Vaates näidatakse ka laua asukohta, mis annab töötajale ülevaate sellest, kus aktiivsed ja mitteaktiivsed lauad asuvad.';

CREATE OR REPLACE VIEW laud_koik_seisundid WITH (security_barrier) AS SELECT Laud.laua_kood, Laua_asukoht.nimetus AS asukoha_kirjeldus, Laua_seisundi_liik.nimetus AS laua_seisund
FROM Laud, Laua_seisundi_liik, Laua_asukoht
WHERE Laua_seisundi_liik.laua_seisundi_liik_kood=Laud.laua_seisundi_liik_kood AND Laud.laua_asukoht_kood = Laua_asukoht.laua_asukoht_kood AND laua_kood IN (SELECT laua_kood FROM Laua_kategooria_omamine);
COMMENT ON VIEW laud_koik_seisundid IS 'Vaade leiab andmed mistahes seisundites olevatest laudadest. Vaates näidatakse ka laua asukohta, mis annab töötajale ülevaate sellest, kus lauad asuvad.';

CREATE OR REPLACE VIEW laud_detailid WITH (security_barrier) AS SELECT Laud.laua_kood, Laud.reg_aeg, Laud.kohtade_arv, Laua_asukoht.nimetus AS asukoha_kirjeldus, (Coalesce(Isik.eesnimi,'') || ' ' || Coalesce(Isik.perenimi, '')) AS registreerija, Isik.e_meil, Laua_seisundi_liik.nimetus AS laua_seisund, Laua_materjal.nimetus, Laud.kommentaar AS kommentaar
FROM Laud, Isik, Laua_seisundi_liik, Laua_materjal, Laua_asukoht
WHERE (Laud.isik_id=Isik.isik_id) And Laua_seisundi_liik.laua_seisundi_liik_kood=Laud.laua_seisundi_liik_kood And Laud.laua_materjali_kood=Laua_materjal.materjali_kood And Laud.laua_asukoht_kood=Laua_asukoht.laua_asukoht_kood;
COMMENT ON VIEW laud_detailid IS 'Vaade leiab andmed kõikide laudade ja nende detailide kohta. Detailides sisaldub registreerimise aeg, registreerija, registreerija e-mail, laua asukoht, kohtade arv, laua seisund, kommentaar, laua materjal ning laua kategooria(d).';

CREATE OR REPLACE VIEW laud_kategooria WITH (security_barrier) AS SELECT Laud.laua_kood, Laua_kategooria.nimetus || ' (' || Laua_kategooria_tyyp.nimetus || ')' AS kategooria
FROM Laud, Laua_kategooria, Laua_kategooria_omamine, Laua_kategooria_tyyp
WHERE Laud.laua_kood = Laua_kategooria_omamine.laua_kood
AND Laua_kategooria.laua_kategooria_kood = Laua_kategooria_omamine.laua_kategooria_kood
AND Laua_kategooria_tyyp.laua_kategooria_tyyp_kood = Laua_kategooria.laua_kategooria_tyyp_kood
ORDER BY Laud.laua_kood;
COMMENT ON VIEW laud_kategooria IS 'Vaade leiab andmed laudadest, mis kuuluvad mõnda kategooriasse. Vaates näidatakse ka laua kategooria tüüpi, mida kuvatakse laua kategooria veerus sulgudes.';

CREATE OR REPLACE VIEW laud_koondaruanne WITH (security_barrier) AS SELECT Laua_seisundi_liik.laua_seisundi_liik_kood, UPPER(Laua_seisundi_liik.nimetus) AS seisund, COUNT(Laud.laua_kood) AS laudade_arv
FROM Laud RIGHT JOIN Laua_seisundi_liik ON Laud.laua_seisundi_liik_kood = Laua_seisundi_liik.laua_seisundi_liik_kood
GROUP BY Laua_seisundi_liik.laua_seisundi_liik_kood, Laua_seisundi_liik.nimetus
ORDER BY COUNT(Laud.laua_kood) DESC;
COMMENT ON VIEW laud_koondaruanne IS 'Vaade leiab koondtulemused kõikide laudade seisunditest. Vaates näidatakse ka laudade arvu, mis vastavasse seisundisse kuulub. Tulemus on sorteeritud laudade arvu järgi kahanevalt.';

/* SELECT VIEW */

SELECT * FROM laud_aktiivne_mitteaktiivne;
SELECT * FROM laud_koik_seisundid;
SELECT * FROM laud_detailid;
SELECT * FROM laud_kategooria;
SELECT * FROM laud_koondaruanne;

