with tmp as (
    SELECT
      a.id AS adrid,
      t.batid,
      t.dist
    FROM ban.hsn_point_2154 a
      CROSS JOIN LATERAL
                 (SELECT
                    b.id                        AS batid,
                    st_distance(b.geom, a.geom) AS dist
                  FROM ban.batiments_hsn_polygon_2154 b
                  ORDER BY a.geom <-> b.geom
                  LIMIT 1) AS t
), tmp1 as (
    SELECT
      t.*,
      row_number()
      OVER (
        PARTITION BY t.batid
        ORDER BY t.dist ) AS rn
    FROM tmp t
) update ban.batiments_hsn_polygon_2154 b set adrid = t.adrid
from tmp1 t
where t.batid = b.id
and t.rn = 1;