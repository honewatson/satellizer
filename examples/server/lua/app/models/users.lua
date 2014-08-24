-- @author Hone Watson
-- @email comments@hone.be
-- @copyright  Copyright (c) 2013 Hone Watson
-- @license    http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)

local MySql = require 'db.mysql'
local SqlOrm = require 'gin.db.sql.orm'

-- define
return SqlOrm.define_model(MySql, 'users')