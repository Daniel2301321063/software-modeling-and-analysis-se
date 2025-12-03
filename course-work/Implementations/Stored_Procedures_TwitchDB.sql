USE TwitchStreamingPlatform;
GO

CREATE PROCEDURE sp_StartStream
    @ChannelId INT,
    @Title NVARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;

    -- Проверка за вече активен стрийм
    IF EXISTS (SELECT 1 FROM Streams WHERE ChannelId = @ChannelId AND IsLive = 1)
    BEGIN
        RAISERROR(N'Каналът вече има активен стрийм.', 16, 1);
        RETURN;
    END;

    INSERT INTO Streams(ChannelId, Title, StartedAt, IsLive, IsVOD)
    VALUES (@ChannelId, @Title, SYSUTCDATETIME(), 1, 0);
END;
GO