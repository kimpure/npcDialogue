--!strict
local task = require("@lune/task")

type Talker = {
    name: string;
    expectations: {[number]: expectations};
    waiting: {
        waited: boolean;
        fns: {[number]: {() -> ()}};
    };
}

type expectations = {index: number , fn: (self: Dialogue) -> ()};

type Answer = {
    expectations: {[number]: expectations};
    waiting: {
        waited: boolean;
        fns: {[number]: {() -> ()}};
    };
}

type DialogueImpl = {
	__index: DialogueImpl;
    talker: (name: string) -> (Talker);
    new: (Talker) -> (Dialogue);
    say: (self: Dialogue , message: string) -> (Dialogue);
    action: (self: Dialogue , fn: (self: Dialogue) -> ()) -> (Dialogue);
    expect: (self: Dialogue , fn: (self: Dialogue) -> ()) -> (Dialogue);
    answer: (self: Dialogue , expect: expectations) -> (Dialogue);
    waitForAnswer: (self: Dialogue) -> (Dialogue);
    await: (self: Dialogue , time: number) -> (Dialogue);
    changedTalker: (self: Dialogue , talker:Talker) -> (Dialogue);
}

export type Dialogue = typeof(setmetatable({} :: {
    _talker: Talker;
}, {} :: DialogueImpl));

local Dialogue = {} :: DialogueImpl
Dialogue.__index = Dialogue

function Dialogue.talker(name)
    return {
        name=name;
        expectations={};
        waiting={
            waited = false;
            fns={};
        };
    }
end

function Dialogue.new(talker)
    return setmetatable({
        _talker=talker;
    } , Dialogue)
end

function Dialogue.say(self , message)
    if self._talker.waiting.waited then
        self._talker.waiting.fns[#self._talker.waiting.fns][#self._talker.waiting.fns[#self._talker.waiting.fns]+1] = function()
            print(`{self._talker.name} : {message}`);    
        end
    else
        print(`{self._talker.name} : {message}`);
    end
    return self
end

function Dialogue.action(self , fn)
    if self._talker.waiting.waited then
        self._talker.waiting.fns[#self._talker.waiting.fns][#self._talker.waiting.fns[#self._talker.waiting.fns]+1] = function()
            self._talker.waiting.waited=false;
            fn(self);
            self._talker.waiting.waited=true;
        end
    else
        fn(self);
    end
    return self
end

function Dialogue.expect(self , fn)
    if self._talker.waiting.waited then
        self._talker.waiting.fns[#self._talker.waiting.fns][#self._talker.waiting.fns[#self._talker.waiting.fns]+1] = function()
            local index = #self._talker.expectations+1;
            self._talker.expectations[index]={index=index , fn=fn};
        end
    else
        local index = #self._talker.expectations+1;
        self._talker.expectations[index]={index=index , fn=fn};
    end
    return self
end

function Dialogue.answer(self , expect)
    self._talker.waiting.waited=false;
    local t = self._talker
    self._talker.expectations[expect.index].fn(self);
    self._talker=t
    self._talker.waiting.waited=true;
    self._talker.expectations={};
    for i=1 , #self._talker.waiting.fns[1] do
        self._talker.waiting.fns[1][i]();
    end
    table.remove(self._talker.waiting.fns , 1);
    return self
end

function Dialogue.waitForAnswer(self)
    self._talker.waiting.waited=true;
    self._talker.waiting.fns[#self._talker.waiting.fns+1] = {};
    return self
end

function Dialogue.await(self , time)
    if self._talker.waiting.waited then
        self._talker.waiting.fns[#self._talker.waiting.fns][#self._talker.waiting.fns[#self._talker.waiting.fns]+1] = function()
            task.wait(time);
        end
    else
        task.wait(time);
    end
    return self
end

function Dialogue.changedTalker(self , talker)
    self._talker=talker;
    return self
end

return Dialogue
