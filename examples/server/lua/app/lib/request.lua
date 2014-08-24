-- @author Hone Watson
-- @email comments@hone.be
-- @copyright  Copyright (c) 2013 Hone Watson
-- @license    http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)
 
local model_injector = function(fn, model)
    return function(self, ...)
        return fn(self, model, ...)
    end
end

return {
    model_injector = model_injector
}