Class = require "libs.hump.class"
local enet = require "enet"
local BlobWriter = require "libs.BlobWriter"
local BlobReader = require "libs.BlobReader"
require "net.disconnect_reason"

Server = Class {
    init = function(self, port)
        self.port = port or 4201
    end
}

function Server:bind()
    self.host = enet.host_create("*" .. ":" .. self.port)
end

function Server:update(timeout)
    return self.host:service(timeout or 0)
end

function Server:sendMessage(peerIndex, data)
    self.host:get_peer(peerIndex):send(BlobWriter():write(data):tostring())
end

function Server:broadcast(data)
    self.host:broadcast(BlobWriter():write(data):tostring())
end

function Server:readMessage(data)
    data = BlobReader(data):read()
    return data
end

function Server:state(peerIndex)
    return self.host:get_peer(peerIndex):state()
end

function Server:disconnect(peerIndex, reason)
    if type(reason) ~= "table" or reason.value == nil then
        print("Bad argument #1 to Connection:disconnect: DisconnectReason expected, got " .. type(data) .. "!\n")
        return
    end
    self.host:flush()
    self.host:get_peer(peerIndex):disconnect(reason.value)
    self.host:flush()
end

function Server:flush()
    self.host:flush()
end
