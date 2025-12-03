USE TwitchStreamingPlatform;
GO

CREATE FUNCTION fn_GetSubscriptionPrice (@Tier TINYINT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Price DECIMAL(10,2);

    IF (@Tier = 1) SET @Price = 4.99;
    ELSE IF (@Tier = 2) SET @Price = 9.99;
    ELSE IF (@Tier = 3) SET @Price = 24.99;
    ELSE SET @Price = 0;

    RETURN @Price;
END;
GO