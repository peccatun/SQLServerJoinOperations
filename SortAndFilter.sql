SELECT TOP 5
	t.CountryName AS Country,
	CASE
	WHEN t.PeakName IS NULL THEN '(no highest peak)'
	ELSE t.PeakName
	END AS [Highest Peak Name],
	CASE
	WHEN t.Elevation IS NULL THEN '0'
	ELSE t.Elevation
	END AS [Highest Peak Elevation],
	CASE
	WHEN t.MountainRange IS NULL THEN '(no mountain)'
	ELSE t.MountainRange
	END AS Mountain
 FROM
(
SELECT
c.CountryName,
p.PeakName,
p.Elevation,
m.MountainRange,
DENSE_RANK() OVER(PARTITION BY c.CountryName ORDER BY p.Elevation DESC) AS HighestPeakRank
FROM Countries AS c
LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
LEFT JOIN Mountains AS m ON mc.MountainId = m.Id
LEFT JOIN Peaks AS p ON m.Id = p.MountainId) AS t
WHERE HighestPeakRank = 1
ORDER BY t.CountryName, t.PeakName