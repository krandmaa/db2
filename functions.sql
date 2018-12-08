CREATE OR REPLACE FUNCTION f_lopeta_laud(p_laua_kood laud.laua_kood%TYPE)
RETURNS VOID AS $$
UPDATE laud SET laua_seisundi_liik_kood=4
WHERE laua_kood=p_laua_kood AND
(laud.laua_seisundi_liik_kood = 2 OR
laud.laua_seisundi_liik_kood = 3);
$$ LANGUAGE SQL SECURITY DEFINER
SET search_path=public, pg_temp;

CREATE OR REPLACE FUNCTION f_registreeri_laud(
p_laua_kood laud.laua_kood%TYPE,
p_kohtade_arv laud.kohtade_arv%TYPE,
p_reg_aeg laud.reg_aeg%TYPE,
p_kommentaar laud.kommentaar%TYPE,
p_laua_asukoht_kood laud.laua_asukoht_kood%TYPE,
p_laua_materjali_kood laud.laua_materjali_kood%TYPE,
p_isik_id laud.isik_id%TYPE)
RETURNS laud.laua_kood%TYPE AS $$
INSERT INTO laud
(laua_kood, kohtade_arv, reg_aeg, kommentaar, laua_asukoht_kood, laua_materjali_kood, isik_id) VALUES
(p_laua_kood, p_kohtade_arv, p_reg_aeg, p_kommentaar, p_laua_asukoht_kood, p_laua_materjali_kood, p_isik_id)
ON CONFLICT DO NOTHING
RETURNING laua_kood;
$$ LANGUAGE SQL SECURITY DEFINER
SET search_path=public, pg_temp;

