Име: Даниел Георгиев
Факултетен номер: 2301321063
Проект: Twitch Streaming Platform

1. Описание на проекта
Проектът представлява опростена симулация на Twitch-подобна стрийминг платформа, която позволява: 
  излъчване на видео съдържание в реално време (streams)
  управление на канали и потребители
  абонаменти и дарения
  чат и интеракции между зрители и стриймъри
Проектът включва:
  концептуален и логически модел
  релационна база данни в Microsoft SQL Server
  процедури, функции и тригери
  Data Warehouse модел
  BI визуализации

2. Функционален обхват
Проектът поддържа основните възможности на една модерна стрийминг система:
- Потребители и роли
  Регистрация, вход, профил
  Роли: Guest, Viewer, Streamer, Moderator, Administrator
  Ограничения според бизнес правилата (напр. само регистрирани пишат в чат)
- Стриймове и канали
  Създаване на канал
  Стартиране и приключване на стрийм
  Архивиране като VOD
  Категории и игри
- Чат
  Изпращане на съобщения
  Модериране (изтриване, блокиране)
- Абонаменти и дарения
  Три нива на абонамент (Tier 1–3)
  Автоматично изтичане след 30 дни
  Дарения (вкл. анонимни)
  Проследяване на приходи по стрийм или канал

3. Технологии, използвани в проекта
Диаграми - draw.io
База данни - Microsoft SQL Server
BI отчети - Microsoft Power BI

5. Моделиране на данните
  1. Концептуален модел (Chen)
    Съдържа ключови обекти:
      User
      Channel
      Stream
      Category
      Donation
      Subscription
      ChatMessage
  2. Логически модел (Crow’s Foot)
    Таблици в модела:
      Users
      Channels
      Streams
      Subscriptions
      Donations
      ChatMessages
      Categories
    Връзка много-към-много (User ↔ Channel чрез Subscriptions)

6. Релационна база данни (SQL Server)
  1. Инициализация
    Файл: Initialization_TwitchDB.sql
    Създава всички таблици и въвежда примерни данни.
  2. Stored Procedures
    Файл: Stored_Procedures_TwitchDB.sql
    управление на абонамент
    добавяне на дарение
    регистриране на стрийм
  3. Functions
    Файл: Functions_TwitchDB.sql
    изчисляване на общи дарения
    изчисляване на активни абонаменти
  4. Triggers
    Файл: Triggers_TwitchDB.sql
    предотвратяване на стартирането на втори активен стрийм за същия канал

7. Data Warehouse модел
  Файл: UML_Data_Warehouse_Model_Twitch.pdf
  Факт таблици:
    Fact_Stream_Viewing
    Fact_Subscription
    Fact_Donation
  Измерения:
    Dim_User
    Dim_Channel
    Dim_Stream
    Dim_Category
    Dim_Subscription_Tier
    Dim_Donation_Method
    Dim_Date
  Моделът е в звездовидна схема

8. Power BI визуализации
  Файл: PowerBi_Diagrams.png
  Създадени са 3 визуализации:
  Total Donations by Name
  Active Subscriptions by Name
  Max Viewers by Stream


























































