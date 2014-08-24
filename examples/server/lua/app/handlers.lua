-- @author Hone Watson
-- @email comments@hone.be
-- @copyright  Copyright (c) 2013 Hone Watson
-- @license    http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)

local md5 = require 'md5'
local config = require("lapis.config").get()

local jwt = require('app.lib.jwt').new({secret = config.secret, token_time = (3600 * 24 * 7)})

local get_token_from_request = function(request)
    local message = "Invalid token in request headers Authorization"
    local auth = request.req.headers.authorization
    if not auth then
        return nil, message
    end
    local token
    local i = 1
    for value in string.gmatch(auth, "%S+") do
        if i == 2 then
            token = value
            break
        end
        i = i + 1
    end
    if token then
        local decoded, err = jwt:validate(token)
        return decoded, err
    else
        return nil, message
    end

end

local auth_user = function(self, Users)
    local user
    user = Users.find_by({ email = self.json.email })
    if not user then
        user = Users.find_by({ displayName = self.json.displayName })
    end
    if not user then
        self.json.password = md5.sumhexa(self.json.password)
        user = Users.create(self.json)
    end
    return { json = { status = 200, id = user.id } }
end

local auth_login = function(self, Users)
    local user
    user = Users.find_by({ email = self.json.email })
    if not user or user.password ~= md5.sumhexa(self.json.password) then
        return { json = { message = "Wrong email or password " .. self.json.email}, status = 401 }
    end
    local token = jwt:create(user)

    return { json = {token = token} }
end

local api_me = function(self, Users)

    local decoded, err = get_token_from_request(self)

    if err then
        return { json = { message = err }, status = 401 }
    end

    local user = {}

    user.displayName = self.json.displayName

    user.email = self.json.email

    user.id = decoded.user.id

    update = Users.new(user)

    update:save()

    local token = jwt:create(user)

    return { json = {token = token} }
end

return {
    auth_user = auth_user,
    auth_login = auth_login,
    api_me = api_me
}