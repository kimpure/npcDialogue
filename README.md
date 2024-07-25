# npcDialogue

npc다일로그



(Dialogue)
```lua
local Dialogue = require("path")
local newTalker = Dialogue.talker("talkerName")
local newDialogue = Dialogue.new(newTalker)
```

(say)
```lua
newDialogue
    :say('message')
```
파라미터로 들어온 메시지를 talker 가 이야기합니다.

(action)
```lua
newDialogue
    :action(function(self)
        self   
            :say("message")
    end)
```
파라미터로 들어온 함수를 실행합니다.

(await)
```lua
newDialogue
    :await(1)
```
파라미터로 들어온 초 만큼 동작을 잠시 정지합니다.

(changedTalker)
```lua
newDialogue
    :changedTalker(talker)
```
self 의 talker 을 파라미터로 들어온 토커로 바꿉니다.

(expect , answer , waitForAnswer)

```lua
newDialogue
    :expect(function(self)
        self   
            :say("message")
    end)
    :waitForAnswer()
    :say("hello")

task.wait(1)
newDialogue:answer(newTalker.expectations[1])
```
expect: answer 로 선택할수있는 선택지를 추가합니다.
waitForAnswer: answer 돼기까지 기다립니다.
answer: 선택한 expect 를 실행합니다.

(예제)
```lua
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
            :say("oh , hello")
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
```

