-- @author Hone Watson
-- @email comments@hone.be
-- @copyright  Copyright (c) 2013 Hone Watson
-- @license    http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)



--results = adapter.execute(options, "SELECT * FROM users;")

local Client = {}

Client.__index = Client

function Client.new(options)
    options.instance = "Client"
    setmetatable(options, Client)
    return options
end

function Client:query(sql, params)
    sql = self._query:sql(sql, params)
    return self.adapter.execute(self.options, sql)
end

function Client:insert(sql, params)
    sql = self._query:sql(sql, params)
--    .execute_and_return_last_id
    return self.adapter.execute_and_return_last_id(self.options, sql)
end

local ClientFactory = {}

function ClientFactory.new(options, adapter, query)
    local _options = {}
    local db = require 'db.db'
    if not options then
        options = db.options
    end
    if not adapter then
        adapter = db.adapter
    end
    if not query then
        query = require('db.query').new()
    end
    _options.options = options
    _options.adapter = adapter
    _options._query = query
    return Client.new(_options)
end

--q = ClientFactory.new()
--local l = q:sql("SELECT * FROM dogs WHERE breed = :breed LIMIT :limit", {limit="10", breed='"poodle"'})
--print(l)
return ClientFactory