local lapis = require("lapis")
local app = lapis.Application()
local config = require("app.config")
local models = require('app.models.models')
local handlers = require('app.handlers')
local json_params = require("lapis.application").json_params
local model_injector = require("app.lib.request").model_injector

app:post("/auth/signup", model_injector(json_params(handlers.auth_user), models.Users))
app:post("/auth/login", model_injector(json_params(handlers.auth_login), models.Users))
app:put("/api/me", model_injector(json_params(handlers.api_me), models.Users))

return app