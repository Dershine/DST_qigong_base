MAXSTEP = 11
LEVELUPATTACK = 15

local function on_step(self, step)
    -- 主机对step赋值时，同时调用replica的赋值函数
    self.inst.replica.move_attack:SetStep(step)
end

local function on_sumstep(self, sumstep)
    -- 主机对sumstep赋值时，同时调用replica的赋值函数
    self.inst.replica.move_attack:SetSumStep(sumstep)
end

local function on_sumattack(self, sumattack)
    -- 主机对sumattack赋值时，同时调用replica的赋值函数
    self.inst.replica.move_attack:SetSumAttack(sumattack)
end

local function on_leveluppercent(self, leveluppercent)
    -- 主机对leveluppercent赋值时，同时调用replica的赋值函数
    self.inst.replica.move_attack:SetLevelUpPercent(leveluppercent)
end

local function on_leveluping(self, leveluping)
    -- 主机对leveluping赋值时，同时调用replica的赋值函数
    self.inst.replica.move_attack:SetLevelUping(leveluping)
end

-- local function on_oldposition(self, data)
--     -- 主机对oldposition赋值时，同时调用replica的赋值函数
--     self.inst.replica.move_attack:SetOldPosition(data)
-- end

-- 初始化组件
local MoveAttack = Class(function(self, inst)
    self.inst = inst
    self.step = 0
    self.sumstep = 0
    self.sumattack = 0
    self.leveluppercent = 0.01
    self.leveluping = false
    self.oldposition = {
        x = 0,
        y = 0
    }
end, nil, 
{
    step = on_step,
    sumstep = on_sumstep,
    sumattack = on_sumattack,
    leveluppercent = on_leveluppercent,
    leveluping = on_leveluping
    -- oldposition = on_oldposition,
})

-- 获取当前人物走a次数
function MoveAttack:GetStep()
    return self.step
end

-- 获取总的走A次数
function MoveAttack:GetSumStep()
    return self.sumstep
end

-- 获取总的攻击次数
function MoveAttack:GetSumAttack()
    return self.sumattack
end

-- 获取进阶偏转概率
function MoveAttack:GetLevelUpPercent()
    return self.leveluppercent
end

-- 获取之前的位置
function MoveAttack:GetOldPosition()
    return self.oldposition
end

-- 设置当前人物走a次数
function MoveAttack:SetStep(data)
    self.step = data
    return
end

-- 设置总的走A次数
function MoveAttack:SetSumStep(data)
    self.sumstep = data
    return
end

-- 设置总的攻击次数
function MoveAttack:SetSumAttack(data)
    self.sumattack = data
    return
end

-- 设置进阶偏转概率
function MoveAttack:SetLevelUpPercent(data)
    self.leveluppercent = data
    return
end

-- 设置之前的位置
function MoveAttack:SetOldPosition(data)
    self.oldposition = data
    return
end

-------------------------------旧代码-----------------------------------

-- 增加走A次数
function MoveAttack:IncrStep(count)
    if self.step >= (self.maxstep - 1) and not self.leveluping then
        -- self.sumstep = self.sumstep + count
        self.sumstep = self.sumstep + 1
    end
    print("步数:"..(self.step + 1), "达标步数:"..self.sumstep, "总攻击数:"..self.sumattack)
    if self.step >= self.maxstep then
        return
    end
    self.step = self.step + count
end

--增加攻击总次数
function MoveAttack:IncrSumAttack(count)
    if self.sumattack >= (self.levelupattack + 1) then
        return
    end
    -- self.sumattack = self.sumattack + count
    self.sumattack = self.sumattack + 1
end

--计算进阶率
function MoveAttack:CulStepAttackPercent()
    self.leveluppercent = self.sumstep / self.levelupattack
    -- print(self.leveluppercent)
end

-- 重置走A次数
function MoveAttack:ResetStep()
    self.step = 0
end

-- 重置攻击总次数和走A总步数
function MoveAttack:ResetSumAttack()
    self.sumattack = 0
    self.sumstep = 0
end

-- 保存游戏时将走A次数保存下来
function MoveAttack:OnSaveStep()
    -- print("当前走A次数：")
    -- print(self.step)
    return {
        step = self.step,
        maxstep = self.maxstep,
        sumstep = self.sumstep,
        sumattack = self.sumattack,
    }
end

-- 保存游戏时将人物当前位置保存下来
function MoveAttack:OnSavePosition()
    return {
        x = self.oldposition.x,
        y = self.oldposition.y,
    }
end

-- 加载游戏时将走A次数加载进来
function MoveAttack:OnLoadStep(data)
    if data.step then
        self.step = data.step
    end
    if data.maxstep then
        self.maxstep = data.maxstep
    end
    if data.sumstep then
        self.sumstep = data.sumstep
    end
    if data.sumattack then
        self.sumattack = data.sumattack
    end
end

-- 加载游戏时将人物位置加载进来
function MoveAttack:OnLoadPosition(data)
    if data.x then
        self.oldposition.x = data.x
    end
    if data.y then
        self.oldposition.y = data.y
    end
end

return MoveAttack