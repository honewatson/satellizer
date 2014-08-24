-- @author Hone Watson
-- @email comments@hone.be
-- @copyright  Copyright (c) 2013 Hone Watson
-- @license    http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)

local auth_user = function(self, Users)
    local user
    user = Users.find_by({ email = self.json.email })
    if not user then
        user = Users.find_by({ displayName = self.json.displayName })
    end
    if not user then
        user = Users.create(self.json)
    end
    return { json = { status = 200, id = user.id } }
end

return {
    auth_user = auth_user
}