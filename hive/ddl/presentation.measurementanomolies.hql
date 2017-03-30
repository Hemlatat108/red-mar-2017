CREATE VIEW IF NOT EXISTS presentation.measurementanomolies AS
SELECT * ,
       CASE
           WHEN AMPLITUDE_1 > 0.995
                AND AMPLITUDE_3 > 0.995
                AND AMPLITUDE_2 < 0.005 THEN TRUE
           ELSE FALSE
       END AS isAnomaly
FROM presentation.measurements
