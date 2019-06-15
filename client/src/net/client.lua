local enet = require "enet"
local BlobWriter = require "libs.BlobWriter"
local BlobReader = require "libs.BlobReader"
require "net.disconnect_reason"

Client = {}

function Client:new(hostname, port)
    o = {}
    setmetatable(o, self)
    self.__index = self
    self.hostname = hostname or "localhost"
    self.port = port or 4201
    return o
end

function Client:connect(timeout)
    self.host = enet.host_create()
    self.server = self.host:connect(self.hostname .. ":" .. self.port)
    local event = self.host:service(timeout or 100)
    if event then
        if event.type == "connect" then
            return true
        end
    end
    return false
end

function Client:update(timeout)
    return self.host:service(timeout or 0)
end

function Client:sendMessage(data)
    data = BlobWriter():write(data):tostring()
    self.server:send(data)
end

function Client:readMessage(data)
    return BlobReader(data):read()
end

function Client:state()
    return self.server:state()
end

function Client:disconnect(reason)
    if type(reason) ~= "table" or reason.value == nil then
        print("Bad argument #1 to Connection:disconnect: DisconnectReason expected, got " .. type(data) .. "!\n")
        return
    end
    self.host:flush()
    self.server:disconnect(reason.value)
    self.host:flush()
end

function Client:flush()
    self.host:flush()
end