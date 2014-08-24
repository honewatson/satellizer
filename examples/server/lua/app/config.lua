-- @author Hone Watson
-- @email comments@hone.be
-- @copyright  Copyright (c) 2013 Hone Watson
-- @license    http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)

local config = require("lapis.config")

config({ "development", "production" }, {
    session_name = "satellizer",
    secret = "this is my secret string 123456",
    token_time = (3600 * 24 * 7)
})

return config