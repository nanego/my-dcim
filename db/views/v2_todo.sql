SELECT
  "server".id,
  "server".name,
  "server".numero,
  "modele".name AS modele_name,
  "manufacturer".name AS manufacturer_name,
  "category".name = 'Pdu' AS is_pdu,
  NULL AS islet_name,
  NULL AS room_name,
  'Server' AS record_type
FROM servers "server"
LEFT JOIN modeles "modele" ON "modele".id = "server".modele_id
LEFT JOIN categories "category" ON "category".id = "modele".category_id
LEFT JOIN manufacturers "manufacturer" ON "manufacturer".id = "modele".manufacturer_id

UNION ALL

SELECT
  "frame".id,
  "frame".name,
  NULL,
  NULL,
  NULL,
  NULL,
  (SELECT name FROM islets "islet" WHERE "islet".id = "frame".id LIMIT 1) AS islet_name,
  (SELECT name FROM rooms "room" WHERE "room".id = "frame".id LIMIT 1) AS room_name,
  'Frame' AS record_type
FROM frames "frame";
