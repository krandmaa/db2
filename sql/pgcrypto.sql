UPDATE isik SET parool = t164844.crypt(parool, t164844.gen_salt('bf',11));

CREATE OR REPLACE FUNCTION f_on_kasutaja(p_kasutajanimi
text, p_parool text)
RETURNS boolean AS $$
DECLARE
rslt boolean;
BEGIN
SELECT INTO rslt (parool = t164844.crypt(p_parool,
parool)) FROM Isik WHERE
Upper(e_meil)=Upper(p_kasutajanimi) AND isiku_seisundi_liik_kood = 1
AND isik_id IN (SELECT isik_id FROM tootaja WHERE tootaja_seisundi_liik_kood BETWEEN 1 AND 4);
RETURN coalesce(rslt, FALSE);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER STABLE
SET search_path = public, pg_temp;
COMMENT ON FUNCTION f_on_kasutaja(p_kasutajanimi text,
p_parool text) IS 'Selle funktsiooni abil autenditakse
restorani töötajat. Parameetri p_kasutajanimi oodatav väärtus on
tõstutundetu kasutaja e-mail ja p_parool oodatav väärtus on
tõstutundlik avatekstiline parool. Töötajal on õigus
süsteemi siseneda, vaid siis kui tema seisundiks on tööl, katseajal, puhkusel
või haiguslehel.';

SELECT f_on_kasutaja(p_kasutajanimi:='hello@gmail.com',p_parool:='password');

SELECT * FROM isik where isik_id IN (SELECT isik_id FROM tootaja WHERE tootaja_seisundi_liik_kood BETWEEN 1 AND 4);