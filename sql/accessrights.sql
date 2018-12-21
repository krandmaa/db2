/* Enne kasutaja kustutamist tuleb ära võtta sellele antud õigused. */

REVOKE CONNECT ON DATABASE t164844 TO t164844_juhataja;
REVOKE USAGE ON SCHEMA public TO t164844_juhataja;
REVOKE EXECUTE ON FUNCTION f_lopeta_laud TO t164844_juhataja;
REVOKE SELECT ON
laud_aktiivne_mitteaktiivne,
laud_detailid,
laud_kategooria,
laud_koik_seisundid,
laud_koondaruanne,
laud_ootel_mitteaktiivne
TO t164844_juhataja;

DROP USER IF EXISTS t164844_juhataja;

/* Luuakse rakendusele vastav kasutaja */

CREATE USER t164844_juhataja WITH PASSWORD '123';

/* Laiale avalikkusele (PUBLIC) vaikimisi antud õiguste äravõtmine. */

REVOKE CONNECT, TEMP ON DATABASE t164844 FROM PUBLIC;
REVOKE CREATE, USAGE ON SCHEMA public FROM PUBLIC;
REVOKE USAGE ON LANGUAGE plpgsql FROM PUBLIC;

REVOKE EXECUTE ON FUNCTION
f_laud_seisundi_kontroll(),
f_lopeta_laud (p_laua_kood laud.laua_kood % TYPE),
f_muuda_laud (p_laua_kood_vana laud.laua_kood % TYPE, p_laua_kood_uus laud.laua_kood % TYPE,
p_kohtade_arv laud.kohtade_arv % TYPE, p_kommentaar laud.kommentaar % TYPE, p_laua_materjali_kood laud.laua_materjali_kood % TYPE,
p_laua_asukoht_kood laud.laua_asukoht_kood % TYPE),
f_muuda_laud_aktiivseks(p_laua_kood laud.laua_kood % TYPE),
f_muuda_laud_mitteaktiivseks(p_laua_kood laud.laua_kood % TYPE),
f_on_kasutaja(p_kasutajanimi text, p_parool text),
f_registreeri_laud(p_laua_kood laud.laua_kood % TYPE,
p_kohtade_arv laud.kohtade_arv % TYPE,
p_kommentaar laud.kommentaar % TYPE,
p_laua_asukoht_kood laud.laua_asukoht_kood % TYPE,
p_laua_materjali_kood laud.laua_materjali_kood % TYPE,
p_registreerija_id laud.registreerija_id % TYPE),
f_unusta_laud(p_laua_kood laud.laua_kood % TYPE),
f_unusta_laud_kontroll()
FROM PUBLIC;

/* Võtan õigused ka kõigi laiendustesse kuuluvate funktsioonide suhtes. Antud projektis on need skeemis public */

REVOKE EXECUTE ON ALL FUNCTIONS IN SCHEMA public FROM PUBLIC;

/* Kasutajale t164844_juhataja õiguste andmine */

GRANT CONNECT ON DATABASE t164844 TO t164844_juhataja;
GRANT USAGE ON SCHEMA public TO t164844_juhataja;
GRANT EXECUTE ON FUNCTION f_lopeta_laud TO t164844_juhataja;
GRANT SELECT ON
laud_aktiivne_mitteaktiivne,
laud_detailid,
laud_kategooria,
laud_koik_seisundid,
laud_koondaruanne,
laud_ootel_mitteaktiivne
TO t164844_juhataja;

/* Vaikimisi õiguste muutmine tulevikus loodavate funktsioonide jaoks. See ei mõjuta olemasolevaid funktsioone. */
ALTER DEFAULT PRIVILEGES REVOKE EXECUTE ON FUNCTIONS FROM PUBLIC;