-- @author Hone Watson
-- @email comments@hone.be
-- @copyright  Copyright (c) 2013 Hone Watson
-- @license    http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)

local jwt = require "luajwt"

local Jwt = {}

Jwt.__index = Jwt

function Jwt.new(config)
    config.instance = "Jwt"
    setmetatable(config, Jwt)
    return config
end

function Jwt:get_alg()
    local alg-- (default)
    if self.token_alg then
        alg = self.token_alg
    else
        alg = "HS256"
    end
    return alg
end

function Jwt:create(user)
    local user = {
        id = user.id,
        displayName = user.displayName,
        email = user.email,
        first_name = user.first_name,
        last_name = user.last_name,
        facebook = user.facebook,
        google = user.google,
        linkedin = user.linkedin,
        twitter = user.twitter
    }
    local payload = {
        user = user,
        nbf = os.time(),
        exp = os.time() + self.token_time,
    }

    local token, err = jwt.encode(payload, self.secret, self:get_alg())

    return token
end
--payload = jwt.decode(token, app.config['TOKEN_SECRET'])
--if datetime.fromtimestamp(payload['exp']) < datetime.now():
--response = jsonify(message='Token has expired')
--response.status_code = 401
--return response
--
--g.user = payload['user']
function Jwt:validate(token)
    local validate = true -- validate signature, exp and nbf (default: true)
    local decoded, err = jwt.decode(token, self.secret, validate)
    return decoded, err
end

return Jwt