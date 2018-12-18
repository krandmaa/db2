UPDATE isik SET parool = t164844.crypt(parool, t164844.gen_salt('bf',11));

CREATE OR REPLACE FUNCTION f_on_kasutaja(p_kasutajanimi
text, p_parool text)
RETURNS boolean AS $$
DECLARE
rslt boolean;
BEGIN
SELECT INTO rslt (parool = public.crypt(p_parool,
parool)) FROM Isik WHERE
Upper(e_meil)=Upper(p_kasutajanimi) AND amet_r_id
BETWEEN 1 AND 9 AND tootaja_seisundi_liik_r_id IN (2, 3);
RETURN coalesce(rslt, FALSE);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER STABLE
SET search_path = public, pg_temp;
COMMENT ON FUNCTION f_on_kasutaja(p_kasutajanimi text,
p_parool text) IS 'Selle funktsiooni abil autenditakse
õppejõudu. Parameetri p_kasutajanimi oodatav väärtus on
tõstutundetu kasutajanimi ja p_parool oodatav väärtus on
tõstutundlik avatekstiline parool. Õppejõul on õigus
süsteemi siseneda, vaid siis kui tema seisundiks on tööl
või haiguslehel.';