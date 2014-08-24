local lapis = require("lapis")
local app = lapis.Application()
local config = require("lapis.config")
local models = require('app.models.models')
local handlers = require('app.handlers')
local json_params = require("lapis.application").json_params
local post_wrapper = require("app.lib.request").post_wrapper


config({ "development", "production" }, {
    session_name = "satellizer",
    secret = "this is my secret string 123456",
    token_time = (3600 * 24 * 7)
})


app:get("/", function()
    return "Welcome to Lapis " .. require("lapis.version")
end)

app:post("/auth/signup", post_wrapper(json_params(handlers.auth_user), models.Users))

return app