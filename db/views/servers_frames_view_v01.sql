SELECT
  s.id,
  s.name,
  s.numero,
  mo.name AS modele_name,
  m.name AS manufacturer_name,
  NULL AS islet_name,
  NULL AS room_name,
  'Server' AS record_type
FROM servers s
LEFT JOIN modeles mo ON mo.id = s.modele_id
LEFT JOIN manufacturers m ON m.id = mo.manufacturer_id

UNION ALL

SELECT
  f.id,
  f.name,
  NULL,
  NULL,
  NULL,
  (SELECT name FROM islets i WHERE i.id = f.id LIMIT 1) AS islet_name,
  (SELECT name FROM rooms r WHERE r.id = f.id LIMIT 1) AS room_name,
  'Frame' AS record_type
FROM frames f;
