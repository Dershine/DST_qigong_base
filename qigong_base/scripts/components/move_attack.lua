-- 初始化组件
local MoveAttack = Class(function(self, inst)
    self.inst = inst
    self.step = 0
    self.maxstep = 11
    self.levelupattack = 15
    self.oldposition = {
        x = 0,
        y = 0
    }
    self.sumstep = 0
    self.sumattack = 0
    self.leveluppercent = 0.01
    self.leveluping = false
end, nil, {})

--获取当前是否处于进阶状态
-- function MoveAttack:IsLevelUp()
--     return self.leveluping
-- end

-- 获取当前人物走a次数
function MoveAttack:GetStep()
    return self.step
end

-- 获取当前人物上一次位置
function MoveAttack:GetOldPosition()
    return self.oldposition
end

-- 增加走A次数
function MoveAttack:IncrStep(count)
    if self.step >= (self.maxstep - 1) and not self.leveluping then
        -- self.sumstep = self.sumstep + count
        self.sumstep = self.sumstep + 1
    end
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
    print(self.leveluppercent)
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