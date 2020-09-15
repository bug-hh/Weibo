-- 创建微博数据表
CREATE TABLE IF NOT EXISTS "T_Status" (
    "statusId"    INTEGER NOT NULL,
    "status"    TEXT,
    "userId"    INTEGER,
    "createTime"    TEXT DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY("statusId")
);

CREATE TABLE IF NOT EXISTS "T_Mentioned" (
    "statusId"    INTEGER NOT NULL,
    "status"    TEXT,
    "userId"    INTEGER,
    "createTime"    TEXT DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY("statusId")
);

CREATE TABLE IF NOT EXISTS "T_Comment" (
    "statusId"    INTEGER NOT NULL,
    "status"    TEXT,
    "userId"    INTEGER,
    "createTime"    TEXT DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY("statusId")
);

CREATE TABLE IF NOT EXISTS "T_Upvote" (
    "statusId"    INTEGER NOT NULL,
    "status"    TEXT,
    "userId"    INTEGER,
    "createTime"    TEXT DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY("statusId")
);




