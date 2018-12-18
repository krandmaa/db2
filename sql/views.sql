/* DROP VIEW */

DROP VIEW IF EXISTS laud_aktiivne_mitteaktiivne;
DROP VIEW IF EXISTS laud_koik_seisundid;
DROP VIEW IF EXISTS laud_detailid;
DROP VIEW IF EXISTS laud_kategooria;
DROP VIEW IF EXISTS laud_koondaruanne;

/* CREATE VIEW */

CREATE OR REPLACE VIEW laud_aktiivne_mitteaktiivne WITH (security_barrier) AS 
SELECT l.laua_kood, la.nimetus AS asukoht, lsl.nimetus AS laua_seisund
FROM laud l, laua_asukoht la, laua_seisundi_liik lsl
WHERE lsl.laua_seisundi_liik_kood = l.laua_seisundi_liik_kood AND l.laua_asukoht_kood = la.laua_asukoht_kood AND l.laua_seisundi_liik_kood IN (2,3);
COMMENT ON VIEW laud_aktiivne_mitteaktiivne IS 'Vaade leiab andmed aktiivsetest ja mitteaktiivsetest laudadest. Vaates näidatakse ka laua asukohta, mis annab töötajale ülevaate sellest, kus aktiivsed ja mitteaktiivsed lauad asuvad.';

CREATE OR REPLACE VIEW laud_koik_seisundid WITH (security_barrier) AS SELECT l.laua_kood, la.nimetus AS asukoha_kirjeldus, lsl.nimetus AS laua_seisund
FROM laud l, laua_seisundi_liik lsl, laua_asukoht la
WHERE lsl.laua_seisundi_liik_kood = l.laua_seisundi_liik_kood AND l.laua_asukoht_kood = la.laua_asukoht_kood;
COMMENT ON VIEW laud_koik_seisundid IS 'Vaade leiab andmed mistahes seisundites olevatest laudadest. Vaates näidatakse ka laua asukohta, mis annab töötajale ülevaate sellest, kus lauad asuvad.';

CREATE OR REPLACE VIEW laud_detailid WITH (security_barrier) AS SELECT l.laua_kood, l.reg_aeg, l.kohtade_arv, la.nimetus AS asukoha_kirjeldus, (COALESCE(i.eesnimi,'') || ' ' || COALESCE(i.perenimi, '')) AS registreerija, i.e_meil, lsl.nimetus AS laua_seisund, lm.nimetus, l.kommentaar AS kommentaar
FROM laud l, isik i, laua_seisundi_liik lsl, laua_materjal lm, laua_asukoht la
WHERE (l.registreerija_id = i.isik_id) AND lsl.laua_seisundi_liik_kood = l.laua_seisundi_liik_kood AND l.laua_materjali_kood = lm.laua_materjali_kood AND l.laua_asukoht_kood = la.laua_asukoht_kood;
COMMENT ON VIEW laud_detailid IS 'Vaade leiab andmed kõikide laudade ja nende detailide kohta. Detailides sisaldub registreerimise aeg, registreerija, registreerija e-mail, laua asukoht, kohtade arv, laua seisund, kommentaar, laua materjal ning laua kategooria(d).';

CREATE OR REPLACE VIEW laud_kategooria WITH (security_barrier) AS SELECT l.laua_kood, lk.nimetus || ' (' || lkt.nimetus || ')' AS kategooria
FROM laud l, laua_kategooria lk, laua_kategooria_omamine lko, laua_kategooria_tyyp lkt
WHERE l.laua_kood = lko.laua_kood
AND lk.laua_kategooria_kood = lko.laua_kategooria_kood
AND lkt.laua_kategooria_tyyp_kood = lk.laua_kategooria_tyyp_kood
ORDER BY l.laua_kood;
COMMENT ON VIEW laud_kategooria IS 'Vaade leiab andmed laudadest, mis kuuluvad mõnda kategooriasse. Vaates näidatakse ka laua kategooria tüüpi, mida kuvatakse laua kategooria veerus sulgudes.';

CREATE OR REPLACE VIEW laud_koondaruanne WITH (security_barrier) AS SELECT lsl.laua_seisundi_liik_kood, UPPER(lsl.nimetus) AS seisund, COUNT(l.laua_kood) AS laudade_arv
FROM laud l RIGHT JOIN laua_seisundi_liik lsl ON l.laua_seisundi_liik_kood = lsl.laua_seisundi_liik_kood
GROUP BY lsl.laua_seisundi_liik_kood, lsl.nimetus
ORDER BY COUNT(l.laua_kood) DESC;
COMMENT ON VIEW laud_koondaruanne IS 'Vaade leiab koondtulemused kõikide laudade seisunditest. Vaates näidatakse ka laudade arvu, mis vastavasse seisundisse kuulub. Tulemus on sorteeritud laudade arvu järgi kahanevalt.';


/* SELECT VIEW */

SELECT * FROM laud_aktiivne_mitteaktiivne;
SELECT * FROM laud_koik_seisundid;
SELECT * FROM laud_detailid;
SELECT * FROM laud_kategooria;
SELECT * FROM laud_koondaruanne;

