CREATE DATABASE TwitchStreamingPlatform;
GO

USE TwitchStreamingPlatform;
GO

CREATE TABLE Users (
    UserId          INT IDENTITY(1,1) PRIMARY KEY,
    Email           NVARCHAR(255) NOT NULL UNIQUE,
    PasswordHash    NVARCHAR(255) NOT NULL,
    DisplayName     NVARCHAR(100) NOT NULL,
    CreatedAt       DATETIME2      NOT NULL DEFAULT SYSUTCDATETIME(),
    IsActive        BIT            NOT NULL DEFAULT 1
);
GO

CREATE TABLE Categories (
    CategoryId   INT IDENTITY(1,1) PRIMARY KEY,
    Name         NVARCHAR(100) NOT NULL,
    Description  NVARCHAR(255) NULL
);
GO

CREATE TABLE Channels (
    ChannelId     INT IDENTITY(1,1) PRIMARY KEY,
    OwnerUserId   INT NOT NULL,
    CategoryId    INT NULL,
    Name          NVARCHAR(100) NOT NULL,
    Description   NVARCHAR(500) NULL,
    CreatedAt     DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    IsActive      BIT       NOT NULL DEFAULT 1,
    CONSTRAINT UQ_Channels_Name UNIQUE (Name),
    CONSTRAINT FK_Channels_Owner FOREIGN KEY (OwnerUserId) REFERENCES Users(UserId),
    CONSTRAINT FK_Channels_Category FOREIGN KEY (CategoryId) REFERENCES Categories(CategoryId)
);
GO

CREATE TABLE Streams (
    StreamId     INT IDENTITY(1,1) PRIMARY KEY,
    ChannelId    INT NOT NULL,
    Title        NVARCHAR(200) NOT NULL,
    StartedAt    DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    EndedAt      DATETIME2 NULL,
    IsLive       BIT NOT NULL DEFAULT 1,
    IsVOD        BIT NOT NULL DEFAULT 0,
    MaxViewers   INT NULL,
    CONSTRAINT FK_Streams_Channel FOREIGN KEY (ChannelId) REFERENCES Channels(ChannelId)
);
GO

CREATE TABLE Subscriptions (
    SubscriptionId INT IDENTITY(1,1) PRIMARY KEY,
    UserId         INT NOT NULL,
    ChannelId      INT NOT NULL,
    Tier           TINYINT NOT NULL,               -- 1,2,3
    StartDate      DATE    NOT NULL,
    EndDate        DATE    NOT NULL,
    IsActive       BIT     NOT NULL,
    AutoRenew      BIT     NOT NULL DEFAULT 0,
    CONSTRAINT FK_Subscriptions_User FOREIGN KEY (UserId) REFERENCES Users(UserId),
    CONSTRAINT FK_Subscriptions_Channel FOREIGN KEY (ChannelId) REFERENCES Channels(ChannelId)
);
GO

CREATE UNIQUE NONCLUSTERED INDEX IX_Subscriptions_Active_Unique
ON Subscriptions(UserId, ChannelId)
WHERE IsActive = 1;
GO

CREATE TABLE Donations (
    DonationId   INT IDENTITY(1,1) PRIMARY KEY,
    FromUserId   INT NULL,   -- може да е NULL за анонимен
    ToChannelId  INT NOT NULL,
    StreamId     INT NULL,
    Amount       DECIMAL(10,2) NOT NULL,
    CurrencyCode CHAR(3) NOT NULL DEFAULT 'EUR',
    DonatedAt    DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    IsAnonymous  BIT       NOT NULL DEFAULT 0,
    Comment      NVARCHAR(250) NULL,
    CONSTRAINT FK_Donations_FromUser FOREIGN KEY (FromUserId) REFERENCES Users(UserId),
    CONSTRAINT FK_Donations_Channel FOREIGN KEY (ToChannelId) REFERENCES Channels(ChannelId),
    CONSTRAINT FK_Donations_Stream FOREIGN KEY (StreamId) REFERENCES Streams(StreamId)
);
GO

CREATE TABLE ChatMessages (
    MessageId   INT IDENTITY(1,1) PRIMARY KEY,
    StreamId    INT NOT NULL,
    FromUserId  INT NOT NULL,
    MessageText NVARCHAR(500) NOT NULL,
    SentAt      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    IsDeleted   BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_ChatMessages_Stream FOREIGN KEY (StreamId) REFERENCES Streams(StreamId),
    CONSTRAINT FK_ChatMessages_User FOREIGN KEY (FromUserId) REFERENCES Users(UserId)
);
GO

INSERT INTO Users(Email, PasswordHash, DisplayName, IsActive)
VALUES
('alice@example.com',   'hash_alice',   N'Alice',   1),
('bob@example.com',     'hash_bob',     N'Bob',     1),
('charlie@example.com', 'hash_charlie', N'Charlie', 1),
('diana@example.com',   'hash_diana',   N'Diana',   1),
('emil@example.com',    'hash_emil',    N'Emil',    1),
('filip@example.com',   'hash_filip',   N'Filip',   1),
('gabi@example.com',    'hash_gabi',    N'Gabi',    1),
('hristo@example.com',  'hash_hristo',  N'Hristo',  1);
GO

INSERT INTO Categories(Name, Description)
VALUES
(N'Just Chatting', N'Casual talks with viewers'),
(N'Gaming',        N'Playing video games'),
(N'Music',         N'Live music performances'),
(N'IRL',           N'Real-life streaming'),
(N'Education',     N'Programming, tutorials, study');
GO

INSERT INTO Channels(OwnerUserId, CategoryId, Name, Description)
VALUES
(3, 2, N'BG_FPS_Queen',   N'Bulgarian FPS competitive stream'),
(4, 3, N'Chill_Music_BG', N'Chill / lofi / piano sets'),
(5, 5, N'CodeWithEmil',   N'Programming and live coding'),
(6, 1, N'ChatWithFilip',  N'Just chatting, community talks'),
(7, 2, N'EsportsDailyBG', N'Esports news and tournaments'),
(8, 4, N'RetroTimeBG',    N'Retro games evenings'),
(1, 1, N'JustChatBG',     N'Morning coffee & chat'),
(2, 2, N'IndieGamesBob',  N'Indie games discoveries');
GO

INSERT INTO Streams(ChannelId, Title, StartedAt, EndedAt, IsLive, IsVOD, MaxViewers)
VALUES
(1, N'Ranked grind #1',           '2025-09-01T18:00:00', '2025-09-01T20:30:00', 0, 1, 850),
(1, N'Community games night',     '2025-09-05T19:00:00', '2025-09-05T22:00:00', 0, 1, 620),
(2, N'LoFi BG set',               '2025-09-03T21:00:00', '2025-09-03T23:00:00', 0, 1, 340),
(2, N'Piano chill evening',       '2025-09-10T20:00:00', '2025-09-10T22:00:00', 0, 1, 410),
(3, N'Intro to SQL',              '2025-09-07T18:30:00', '2025-09-07T20:00:00', 0, 1, 210),
(3, N'Live coding: Twitch clone', '2025-09-15T19:00:00', '2025-09-15T22:30:00', 0, 1, 320),
(4, N'Q&A with chat',             '2025-09-12T19:30:00', '2025-09-12T21:00:00', 0, 1, 180),
(5, N'Esports news daily',        '2025-11-27T18:00:00', NULL,                    1, 0, 950),
(6, N'Retro night: NES classics', '2025-09-20T20:00:00', '2025-09-20T23:30:00', 0, 1, 270),
(8, N'Indie Friday',              '2025-09-25T19:00:00', '2025-09-25T22:00:00', 0, 1, 190);
GO

INSERT INTO Subscriptions(UserId, ChannelId, Tier, StartDate, EndDate, IsActive, AutoRenew)
VALUES
(2, 1, 1, '2025-09-01', '2025-10-01', 0, 0),
(2, 1, 2, '2025-10-02', '2025-11-02', 1, 1),

(3, 2, 1, '2025-09-15', '2025-10-15', 0, 1),
(3, 2, 1, '2025-10-16', '2025-11-16', 1, 1),

(4, 3, 1, '2025-09-10', '2025-10-10', 1, 1),

(5, 1, 3, '2025-09-20', '2025-10-20', 0, 0),
(5, 3, 2, '2025-10-05', '2025-11-05', 1, 1),

(6, 4, 1, '2025-10-01', '2025-10-31', 1, 0),

(7, 5, 1, '2025-10-10', '2025-11-10', 1, 1),
(8, 5, 1, '2025-10-15', '2025-11-15', 1, 0),

(1, 2, 1, '2025-09-01', '2025-09-30', 0, 0),
(1, 2, 2, '2025-10-01', '2025-10-31', 1, 1);
GO

INSERT INTO Donations(FromUserId, ToChannelId, StreamId, Amount, CurrencyCode, DonatedAt, IsAnonymous, Comment)
VALUES
(2, 1, 1,  5.00, 'EUR', '2025-09-01T19:15:00', 0, N'GLHF!'),
(3, 1, 2, 10.00, 'EUR', '2025-09-05T20:10:00', 0, N'Nice headshots'),
(4, 2, 3,  3.50, 'EUR', '2025-09-03T21:30:00', 1, N'❤'),
(5, 3, 5, 12.00, 'EUR', '2025-09-07T19:10:00', 0, N'Great explanation'),
(6, 3, 6,  7.00, 'EUR', '2025-09-15T20:45:00', 0, N'More live coding please'),
(7, 4, 7,  2.00, 'EUR', '2025-09-12T20:05:00', 1, N'Anonymous support'),
(8, 6, 9,  4.00, 'EUR', '2025-09-20T21:15:00', 0, N'Retro hype'),
(1, 5, 8, 15.00, 'EUR', '2025-11-27T18:30:00', 0, N'Esports best show'),
(NULL,5, 8,  1.00, 'EUR', '2025-11-27T18:45:00', 1, N'Anonymous cheer'),
(3, 8,10,  6.00, 'EUR', '2025-09-25T20:10:00', 0, N'Love indie games'),
(2, 2, 4,  2.50, 'EUR', '2025-09-10T21:15:00', 0, N'Beautiful piano'),
(5, 1, 2,  9.99, 'EUR', '2025-09-05T21:50:00', 0, N'Huge clutch!'),
(4, 7, 8,  3.00, 'EUR', '2025-09-18T08:45:00', 1, N'Coffee for the streamer'),
(6, 1, 1,  1.50, 'EUR', '2025-09-01T19:45:00', 0, N'First donation'),
(NULL,4, NULL, 2.00, 'EUR', '2025-09-30T19:00:00', 1, N'Supporting the community');
GO