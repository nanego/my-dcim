select
  id,
  name,
  numero,
  (select name from modeles m where m.id = modele_id) as modele_name,
  NULL as islet_name,
  NULL as room_name,
  'Server' as record_type
from servers

UNION ALL

select
  id,
  name,
  NULL,
  NULL,
  (select name from islets i where i.id = f.id) as islet_name,
  (select name from rooms r where r.id = f.id) as room_name,
  'Frame' as record_type
from frames f;
