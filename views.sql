/* DROP VIEW */

DROP VIEW IF EXISTS laud_aktiivne_mitteaktiivne;
DROP VIEW IF EXISTS laud_koik_seisundid;
DROP VIEW IF EXISTS laud_detailid;
DROP VIEW IF EXISTS laud_kategooria;
DROP VIEW IF EXISTS laud_koondaruanne;

/* CREATE VIEW */

CREATE OR REPLACE VIEW laud_aktiivne_mitteaktiivne WITH (security_barrier) AS SELECT laud.laua_kood, laua_asukoht.nimetus AS asukoht, laua_seisundi_liik.nimetus AS laua_seisund
FROM laud, laua_asukoht, laua_seisundi_liik
WHERE laua_seisundi_liik.laua_seisundi_liik_kood = laud.laua_seisundi_liik_kood AND laud.laua_asukoht_kood = laua_asukoht.laua_asukoht_kood AND laud.laua_seisundi_liik_kood In (2,3);
COMMENT ON VIEW laud_aktiivne_mitteaktiivne IS 'Vaade leiab andmed aktiivsetest ja mitteaktiivsetest laudadest. Vaates näidatakse ka laua asukohta, mis annab töötajale ülevaate sellest, kus aktiivsed ja mitteaktiivsed lauad asuvad.';

CREATE OR REPLACE VIEW laud_koik_seisundid WITH (security_barrier) AS SELECT laud.laua_kood, laua_asukoht.nimetus AS asukoha_kirjeldus, laua_seisundi_liik.nimetus AS laua_seisund
FROM laud, laua_seisundi_liik, laua_asukoht
WHERE laua_seisundi_liik.laua_seisundi_liik_kood=laud.laua_seisundi_liik_kood AND laud.laua_asukoht_kood = laua_asukoht.laua_asukoht_kood AND laua_kood IN (SELECT laua_kood FROM laua_kategooria_omamine);
COMMENT ON VIEW laud_koik_seisundid IS 'Vaade leiab andmed mistahes seisundites olevatest laudadest. Vaates näidatakse ka laua asukohta, mis annab töötajale ülevaate sellest, kus lauad asuvad.';

CREATE OR REPLACE VIEW laud_detailid WITH (security_barrier) AS SELECT laud.laua_kood, laud.reg_aeg, laud.kohtade_arv, laua_asukoht.nimetus AS asukoha_kirjeldus, (Coalesce(isik.eesnimi,'') || ' ' || Coalesce(isik.perenimi, '')) AS registreerija, isik.e_meil, laua_seisundi_liik.nimetus AS laua_seisund, laua_materjal.nimetus, laud.kommentaar AS kommentaar
FROM laud, isik, laua_seisundi_liik, laua_materjal, laua_asukoht
WHERE (laud.isik_id=Isik.isik_id) And laua_seisundi_liik.laua_seisundi_liik_kood=laud.laua_seisundi_liik_kood And laud.laua_materjali_kood=laua_materjal.materjali_kood And laud.laua_asukoht_kood=laua_asukoht.laua_asukoht_kood;
COMMENT ON VIEW laud_detailid IS 'Vaade leiab andmed kõikide laudade ja nende detailide kohta. Detailides sisaldub registreerimise aeg, registreerija, registreerija e-mail, laua asukoht, kohtade arv, laua seisund, kommentaar, laua materjal ning laua kategooria(d).';

CREATE OR REPLACE VIEW laud_kategooria WITH (security_barrier) AS SELECT laud.laua_kood, laua_kategooria.nimetus || ' (' || laua_kategooria_tyyp.nimetus || ')' AS kategooria
FROM laud, laua_kategooria, laua_kategooria_omamine, laua_kategooria_tyyp
WHERE laud.laua_kood = laua_kategooria_omamine.laua_kood
AND laua_kategooria.laua_kategooria_kood = laua_kategooria_omamine.laua_kategooria_kood
AND laua_kategooria_tyyp.laua_kategooria_tyyp_kood = laua_kategooria.laua_kategooria_tyyp_kood
ORDER BY laud.laua_kood;
COMMENT ON VIEW laud_kategooria IS 'Vaade leiab andmed laudadest, mis kuuluvad mõnda kategooriasse. Vaates näidatakse ka laua kategooria tüüpi, mida kuvatakse laua kategooria veerus sulgudes.';

CREATE OR REPLACE VIEW laud_koondaruanne WITH (security_barrier) AS SELECT laua_seisundi_liik.laua_seisundi_liik_kood, UPPER(laua_seisundi_liik.nimetus) AS seisund, COUNT(laud.laua_kood) AS laudade_arv
FROM laud RIGHT JOIN laua_seisundi_liik ON laud.laua_seisundi_liik_kood = laua_seisundi_liik.laua_seisundi_liik_kood
GROUP BY laua_seisundi_liik.laua_seisundi_liik_kood, laua_seisundi_liik.nimetus
ORDER BY COUNT(laud.laua_kood) DESC;
COMMENT ON VIEW laud_koondaruanne IS 'Vaade leiab koondtulemused kõikide laudade seisunditest. Vaates näidatakse ka laudade arvu, mis vastavasse seisundisse kuulub. Tulemus on sorteeritud laudade arvu järgi kahanevalt.';

/* SELECT VIEW */

SELECT * FROM laud_aktiivne_mitteaktiivne;
SELECT * FROM laud_koik_seisundid;
SELECT * FROM laud_detailid;
SELECT * FROM laud_kategooria;
SELECT * FROM laud_koondaruanne;

