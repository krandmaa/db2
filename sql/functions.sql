/* Drop triggers and functions */

DROP TRIGGER IF EXISTS t_kontrolli_laua_seisundit ON laud;

DROP FUNCTION IF EXISTS f_lopeta_laud(p_laua_kood SMALLINT);

DROP FUNCTION IF EXISTS f_registreeri_laud(p_laua_kood SMALLINT,
p_kohtade_arv SMALLINT,
p_kommentaar TEXT,
p_laua_asukoht_kood SMALLINT,
p_laua_materjali_kood SMALLINT,
p_registreerija_id INTEGER);

DROP FUNCTION IF EXISTS f_unusta_laud(p_laua_kood SMALLINT);

DROP FUNCTION IF EXISTS f_muuda_laud(p_laua_kood_vana SMALLINT,
p_laua_kood_uus SMALLINT,
p_kohtade_arv SMALLINT,
p_kommentaar TEXT,
p_laua_materjali_kood SMALLINT,
p_laua_asukoht_kood SMALLINT);

DROP FUNCTION IF EXISTS f_muuda_laud_aktiivseks(p_laua_kood SMALLINT);

DROP FUNCTION IF EXISTS f_muuda_laud_mitteaktiivseks(p_laua_kood SMALLINT);

DROP FUNCTION IF EXISTS f_kontrolli_laua_seisundit();


/* Create functions */

CREATE OR REPLACE FUNCTION f_lopeta_laud(p_laua_kood laud.laua_kood % TYPE)
RETURNS VOID AS $$
UPDATE laud SET laua_seisundi_liik_kood=4
WHERE laua_kood=p_laua_kood AND
(laua_seisundi_liik_kood = 2 OR
laua_seisundi_liik_kood = 3);
$$ LANGUAGE SQL SECURITY DEFINER
SET search_path=public, pg_temp;
COMMENT ON FUNCTION f_lopeta_laud IS 'OP5 Lõpeta laud. Funktsioon seab aktiivse või mitteaktiivse laua lõpetatud olekusse.';

CREATE OR REPLACE FUNCTION f_registreeri_laud(
p_laua_kood laud.laua_kood % TYPE,
p_kohtade_arv laud.kohtade_arv % TYPE,
p_kommentaar laud.kommentaar % TYPE,
p_laua_asukoht_kood laud.laua_asukoht_kood % TYPE,
p_laua_materjali_kood laud.laua_materjali_kood % TYPE,
p_registreerija_id laud.registreerija_id % TYPE)
RETURNS SMALLINT AS $$
INSERT INTO laud
(laua_kood, kohtade_arv, reg_aeg, kommentaar, laua_asukoht_kood, laua_materjali_kood, reistreerija_id) VALUES
(p_laua_kood, p_kohtade_arv, current_timestamp(0), p_kommentaar, p_laua_asukoht_kood, p_laua_materjali_kood, p_isik_id)
ON CONFLICT DO NOTHING
RETURNING laua_kood;
$$ LANGUAGE SQL SECURITY DEFINER
SET search_path=public, pg_temp;
COMMENT ON FUNCTION f_registreeri_laud IS 'OP1 Registreeri laud. Funktsioon lisab andmebaasi uue laua, millega kliendid saavad tulevikus hakata tehinguid tegema.';


CREATE OR REPLACE FUNCTION f_unusta_laud(p_laua_kood laud.laua_kood % TYPE)
RETURNS VOID AS $$
DELETE FROM laud 
WHERE laua_kood=p_laua_kood AND
laud.laua_seisundi_liik_kood = 1;
$$ LANGUAGE SQL SECURITY DEFINER
SET search_path=public, pg_temp;
COMMENT ON FUNCTION f_unusta_laud IS 'OP2 Unusta laud. Funktsioon kustutab süsteemist ootel laua ette antud laua koodi järgi.';


CREATE OR REPLACE FUNCTION f_muuda_laud(
p_laua_kood_vana laud.laua_kood % TYPE,
p_laua_kood_uus laud.laua_kood % TYPE,
p_kohtade_arv laud.kohtade_arv % TYPE,
p_kommentaar laud.kommentaar % TYPE,
p_laua_materjali_kood laud.laua_materjali_kood % TYPE,
p_laua_asukoht_kood laud.laua_asukoht_kood % TYPE
)
RETURNS VOID AS $$
UPDATE laud SET laua_kood = p_laua_kood_uus, kohtade_arv = p_kohtade_arv, kommentaar = p_kommentaar, laua_asukoht_kood = p_laua_asukoht_kood, laua_materjali_kood = p_laua_materjali_kood
WHERE laua_kood = p_laua_kood_vana
$$ LANGUAGE SQL SECURITY DEFINER
SET search_path = public, pg_temp;
COMMENT ON FUNCTION f_muuda_laud IS 'OP6 Muuda laua andmeid. Funktsiooniga uuendab andmebaasis laua koodi, kohtade arvu, kommentaari, matejali koodi ja laua asukohta.';


CREATE OR REPLACE FUNCTION f_muuda_laud_aktiivseks(p_laua_kood laud.laua_kood % TYPE)
RETURNS VOID AS $$
UPDATE laud SET laua_seisundi_liik_kood = 2
WHERE laua_kood = p_laua_kood AND
(laua_seisundi_liik_kood = 1 OR laua_seisundi_liik_kood = 3);
$$ LANGUAGE SQL SECURITY DEFINER
SET search_path = public, pg_temp;
COMMENT ON FUNCTION f_muuda_laud_aktiivseks IS 'OP3 Aktiveeri laud. Funktsioon muudab andmebaasis laua mitteaktiivsest või ootel olekust aktiivsesse olekusse.';

CREATE OR REPLACE FUNCTION f_muuda_laud_mitteaktiivseks(p_laua_kood laud.laua_kood % TYPE)
RETURNS VOID AS $$
UPDATE laud SET laua_seisundi_liik_kood = 3
WHERE laua_kood = p_laua_kood AND
laua_seisundi_liik_kood = 2;
$$ LANGUAGE SQL SECURITY DEFINER
SET search_path = public, pg_temp;
COMMENT ON FUNCTION f_muuda_laud_mitteaktiivseks IS 'OP4 Muuda laud mitteaktiivseks lauaks. Funktsioon muudab andmebaasis laua aktiivsest olekust mitteaktiivsesse olekusse.';


/* Create triggers */

CREATE OR REPLACE FUNCTION f_kontrolli_laua_seisundit() RETURNS TRIGGER AS $f_kontrolli_laua_seisundit$ 
BEGIN 
IF NOT(OLD.laua_seisundi_liik_kood = 1 OR OLD.laua_seisundi_liik_kood = 3) THEN 
RAISE EXCEPTION 'Laua muutmine ebakorrektses seisundis!'; 
END IF;
END; 
$f_kontrolli_laua_seisundit$ LANGUAGE plpgsql;
CREATE COMMENT ON FUNCTION f_kontrolli_laua_seisundit IS 'Funktsioon kontrollib, et laud oleks seisundis ootel või mitteaktiivne.'

CREATE TRIGGER t_kontrolli_laua_seisundit BEFORE UPDATE ON laud
FOR EACH ROW EXECUTE PROCEDURE f_kontrolli_laua_seisundit();
CREATE COMMENT ON TRIGGER t_kontrolli_laua_seisundit IS 'Kontrollib, et laua andmeid ei saaks muuta, kui see on aktiivses või lõpetatud seisundis.'

