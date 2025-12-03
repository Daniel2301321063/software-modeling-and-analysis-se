USE TwitchStreamingPlatform;
GO

CREATE TRIGGER trg_Streams_OneActivePerChannel
ON Streams
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT ChannelId
        FROM Streams
        WHERE IsLive = 1
        GROUP BY ChannelId
        HAVING COUNT(*) > 1
    )
    BEGIN
        RAISERROR (N'Не може да има повече от един активен стрийм за канал.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;
GO

CREATE TRIGGER trg_Donations_MarkAnonymous
ON Donations
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE d
    SET IsAnonymous = 1
    FROM Donations d
    INNER JOIN inserted i ON d.DonationId = i.DonationId
    WHERE i.FromUserId IS NULL;
END;
GO