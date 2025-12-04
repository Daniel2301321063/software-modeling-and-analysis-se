USE TwitchStreamingPlatform;
GO

CREATE PROCEDURE sp_StartStream
    @ChannelId INT,
    @Title NVARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM Streams WHERE ChannelId = @ChannelId AND IsLive = 1)
    BEGIN
        RAISERROR(N'Êàíàëúò âå÷å èìà àêòèâåí ñòðèéì.', 16, 1);
        RETURN;
    END;

    INSERT INTO Streams(ChannelId, Title, StartedAt, IsLive, IsVOD)
    VALUES (@ChannelId, @Title, SYSUTCDATETIME(), 1, 0);
END;

GO
