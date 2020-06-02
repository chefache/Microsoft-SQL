-- Problem 12.Countries Holding ‘A’ 3 or More Times
--12.1
SELECT CountryName, CountryCode
FROM Countries
WHERE CountryName LIKE ('%A%A%A%')
ORDER BY IsoCode
--12.2
SELECT CountryWithA, IsoCode FROM(SELECT REPLACE(CountryName, 'A', '')
AS CountryName, CountryName AS CountryWithA, IsoCode
FROM Countries) AS CWA
WHERE LEN(CountryWithA) - LEN(CountryName) >= 3
ORDER BY IsoCode