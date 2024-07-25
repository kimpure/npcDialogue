local Dialogue = require("src/init")

local task = require("@lune/task")

local sunwoo = Dialogue.talker('sunwoo')
local box = Dialogue.talker"box_3948"
local newDialogue =  Dialogue.new(sunwoo)

newDialogue
    :say('hello world')
    :expect(function(self)
        self
            :changedTalker(box)
            :say("oh , hi")
    end)
    :expect(function(self)
        self
            :changedTalker(box)
            :say("oh , hi")
    end)
    :waitForAnswer()
    :say('hello world2')
    :expect(function(self)
        self
            :changedTalker(box)
            :say("yeaaa")
    end)
    :expect(function(self)
        self
            :changedTalker(box)
            :say("whaaaaaaaat?")
    end)
    :waitForAnswer()
    :say("제발 돼줘")

task.wait(1)
newDialogue:answer(sunwoo.expectations[1])
task.wait(1)
newDialogue:answer(sunwoo.expectations[1])
