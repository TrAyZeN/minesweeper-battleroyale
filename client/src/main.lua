require "net.client"

function love.load()
    client = Client()
    client:connect()
    print("Client started")
    client:sendMessage({ "This is a table", "with 2 elements" })
    client:sendMessage(42)
    client:sendMessage("This is a string")
    client:sendMessage(false)
    client:disconnect(DisconnectReason.CONNECTION_TERMINATED)
end

function love.update(dt)
    local event = client:update()
    if event == nil or not (event.type == "receive") then
        return
    end
end
