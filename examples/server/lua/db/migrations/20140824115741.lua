local SqlMigration = {}


SqlMigration.db = require 'db.mysql'

function SqlMigration.up()
    SqlMigration.db:execute([[
        CREATE TABLE users (
            id int NOT NULL AUTO_INCREMENT,
            displayName char(120) NOT NULL,
            email char(120) NOT NULL,
            password char(120),
            first_name char(120),
            last_name char(120),
            facebook char(120),
            google char(120),
            linkedin char(120),
            twitter char(120),
            PRIMARY KEY (id),
            UNIQUE (displayName),
            UNIQUE (email)
        );
    ]])
end

function SqlMigration.down()
    -- Run your rollback
    SqlMigration.db:execute([[
        DROP TABLE users;
    ]])
end

return SqlMigration