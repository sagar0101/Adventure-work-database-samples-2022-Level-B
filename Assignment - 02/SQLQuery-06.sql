--2. Function to Format Date as YYYYMMDD
CREATE FUNCTION dbo.FormatDateYYYYMMDD (@InputDate DATETIME)
RETURNS VARCHAR(8)
AS
BEGIN
    RETURN CONVERT(VARCHAR(8), @InputDate, 112);
END;
