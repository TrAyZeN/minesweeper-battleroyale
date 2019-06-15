require "net.server"

function love.load()
    server = Server:new()
    server:bind()
    print("Server started")
end

function love.update(dt)
    local event = server:update()
    if event ~= nil and event.type == "connect" then
        print("New connection from peer number " .. event.peer:index())
        return
    elseif event ~= nil and event.type == "disconnect" then
        print("Peer number " .. event.peer:index() .. " disconnected with reason " .. DisconnectReason[event.data].name)
        return
    elseif event == nil or not (event.type == "receive") then
        return
    end
    local data = server:readMessage(event.data)
    if type(data) == "table" then
        print(type(data) .. " | " .. dumpTable(data))
    elseif type(data) == "boolean" then
        print(type(data) .. " | " .. (data and "true" or "false"))
    else
        print(type(data) .. " | " .. data)
    end
end

function dumpTable(table)
    str = ""
    for x = 1, #table do
        str = str .. table[x] .. " / "
    end
    return str:sub(1, -4)
end
