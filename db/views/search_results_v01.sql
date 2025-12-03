SELECT
  servers.id AS searchable_id,
  'Server' AS searchable_type,
  servers.name AS name,
  ARRAY[servers.domaine_id] AS domaine_ids,
  CONCAT_WS(
    ' ',
    servers.name,
    servers.numero,
    servers.numero,
    modeles.name,
    manufacturers.name
  ) AS term
FROM servers
LEFT JOIN modeles ON modeles.id = servers.modele_id
LEFT JOIN manufacturers ON manufacturers.id = modeles.manufacturer_id

UNION ALL

SELECT
  frames.id AS searchable_id,
  'Frame' AS searchable_type,
  frames.name AS name,
  ARRAY(SELECT DISTINCT domaine_id FROM servers s WHERE s.frame_id = frames.id) AS domaine_ids,
  CONCAT_WS(
    ' ',
    frames.name,
    (SELECT name FROM islets i WHERE i.id = frames.id LIMIT 1),
    (SELECT name FROM rooms r WHERE r.id = frames.id LIMIT 1)
  ) AS term
FROM frames;
