-- @author Hone Watson
-- @email comments@hone.be
-- @copyright  Copyright (c) 2013 Hone Watson
-- @license    http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)

local colon_reg = ":[a-zA-Z0-9_]+"

local Query = {}

Query.__index = Query

function Query.new(options)
    options.instance = "Query"
    setmetatable(options, Query)
    return options
end

function Query:sql(sql, params)
    local params_match = string.gmatch(sql, self.reg)
    local final_sql = sql
    for param in params_match do
        final_sql = string.gsub(final_sql, param, self.quote(params[string.gsub(param, ":", "")]))
    end
    return final_sql
end

local cmysql_escape = function()
    local ffi = require("ffi")
    ffi.cdef[[
        unsigned long	mysql_escape_string(char *to,const char *from, unsigned long from_length);
  ]]
    local clib = pcall( function() ffi.load( "/usr/lib/x86_64-linux-gnu/libmysqlclient.so.18", true ) end )

    local mysql_escape =
    function( orig )
        if not orig then return nil end
        if tonumber(orig) ~= nil then
            return orig
        end;
        local strsz = string.len(orig) * 2 + 1 + 1
        local cdata = ffi.new( "char[" .. strsz .. "]", {})
        local ret = ffi.C.mysql_escape_string(cdata, orig, string.len(orig) )
        return '"' .. ffi.string( cdata, ret ) .. '"'
    end
    return mysql_escape
end

local QueryFactory = {}

function QueryFactory.new(reg)
    local options = {}
    if reg == nil then
        reg = colon_reg
    end
    options.reg = reg
    if ngx then
        options.quote = ngx.quote_sql_str
    else
        options.quote = cmysql_escape()
    end
    return Query.new(options)
end

--q = QueryFactory.new()
--local l = q:sql("SELECT * FROM dogs WHERE breed = :breed LIMIT :limit", {limit="10", breed='"poodle"'})
--print(l)
return QueryFactory