local enet = require "enet"
local BlobWriter = require "libs.BlobWriter"
local BlobReader = require "libs.BlobReader"
require "net.disconnect_reason"

Server = {}

function Server:new(port)
    o = {}
    setmetatable(o, self)
    self.__index = self
    self.port = port or 4201
    return o
end

function Server:bind()
    self.host = enet.host_create("*" .. ":" .. self.port)
end

function Server:update(timeout)
    return self.host:service(timeout or 0)
end

function Server:sendMessage(peer, data)
    peer:send(BlobWriter():write(data):tostring())
end

function Server:readMessage(data)
    data = BlobReader(data):read()
    return data
end

function Server:state(peer)
    return peer:state()
end

function Server:disconnect(peer, reason)
    if type(reason) ~= "table" or reason.value == nil then
        print("Bad argument #1 to Connection:disconnect: DisconnectReason expected, got " .. type(data) .. "!\n")
        return
    end
    self.host:flush()
    peer:disconnect(reason.value)
    self.host:flush()
end

function Server:flush()
    self.host:flush()
end

