CREATE TABLE "dbo"."user" (
    id NVARCHAR (33) NOT NULL,
    name NVARCHAR (50) NOT NULL,
    deleted_at DATETIMEOFFSET (5),
    PRIMARY KEY (id)
);
