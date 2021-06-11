--[[
  Copyright 2021 Manticore Games, Inc.
  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
  documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
  persons to whom the Software is furnished to do so, subject to the following conditions:
  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
  Software.
  
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
  WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
  OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

local Deque = {}
Deque.__index = Deque

function Deque.New()
    local deque = {}
    setmetatable(deque, Deque)
    deque:Clear()
    return deque
end

function Deque:Clear()
    self.front = 0
    self.back = -1
end

function Deque:Empty()
    return self.front > self.back
end

function Deque:Count()
    if not self:Empty() then return self.back - self.front + 1 else return 0 end
end

function Deque:PushBack(value)
    self.back = self.back + 1
    self[self.back] = value
end

function Deque:PushFront(value)
    self.front = self.front - 1
    self[self.front] = value
end

function Deque:Front()
    if not self:Empty() then return self[self.front] end
end

function Deque:Back()
    if not self:Empty() then return self[self.back] end
end

function Deque:PopBack()
    if not self:Empty() then
        local val = self[self.back]
        self.back = self.back - 1
        return val
    end
end

function Deque:PopFront()
    if not self:Empty() then
        local val = self[self.front]
        self.front = self.front + 1
        return val
    end
end

local txQueue = Deque.New()

function Retry()
    while not txQueue:Empty() do
        local method = txQueue:Front().method
        local broadcast = Events[method]
        local result = broadcast(table.unpack(txQueue:Front()))
        if result ~= BroadcastEventResultCode.EXCEEDED_RATE_LIMIT then
            txQueue:PopFront()
        else
          Task.Spawn(function() Task.Wait(1) Retry() end)
          return
        end
    end
end

local ReliableEvents = {}

function ReliableEvents.BroadcastToServer(...)
    txQueue:PushBack({ method = "BroadcastToServer", ... })
    Retry()
end

function ReliableEvents.BroadcastToPlayer(...)
    txQueue:PushBack({ method = "BroadcastToPlayer", ... })
    Retry()
end

function ReliableEvents.BroadcastToAllPlayers(...)
    txQueue:PushBack({ method = "BroadcastToAllPlayers", ... })
    Retry()  
end

local txTask = Task.Spawn(function() Retry() end)

return ReliableEvents