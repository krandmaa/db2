CREATE OR REPLACE FUNCTION f_lopeta_laud(p_laua_kood laud.laua_kood%TYPE)
RETURNS VOID AS $$
UPDATE laud SET laua_seisundi_liik_kood=4
WHERE laua_kood=p_laua_kood AND
(laud.laua_seisundi_liik_kood = 2 OR
laud.laua_seisundi_liik_kood = 3);
$$ LANGUAGE SQL SECURITY DEFINER
SET search_path=public, pg_temp;