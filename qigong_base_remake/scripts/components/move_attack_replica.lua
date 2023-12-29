
MAXSTEP = 11
LEVELUPATTACK = 15

local MoveAttack = Class(function(self, inst)
    self.inst = inst
    self._step = net_float(inst.GUID, "step")
    self._sumstep = net_float(inst.GUID, "sumstep")
    self._sumattack = net_float(inst.GUID, "sumattack")
    self._leveluppercent = net_float(inst.GUID, "leveluppercent")
    self._leveluping = net_bool(inst.GUID, "leveluping")
    self._oldposition = {
        x = 0,
        y = 0
    }
end)

function MoveAttack:SetStep(data)
    if self.inst.components.move_attack then
        -- 更新网络变量，仅在主机执行
        data = data or 0
        self._step:set(data)
        print("step:"..data)
    end
end

function MoveAttack:GetStep()
    if self.inst.components.move_attack ~= nil then
        -- 在主机直接读取component的值
        return self.inst.components.move_attack.step
    else
        -- 在客机读取网络变量的值
        return self._step:value()
    end
end

function MoveAttack:SetSumStep(data)
    if self.inst.components.move_attack then
        -- 更新网络变量，仅在主机执行
        data = data or 0
        self._sumstep:set(data)
        print("sumstep:"..data)
    end
end

function MoveAttack:GetSumStep()
    if self.inst.components.move_attack ~= nil then
        -- 在主机直接读取component的值
        return self.inst.components.move_attack.sumstep
    else
        -- 在客机读取网络变量的值
        return self._sumstep:value()
    end
end

function MoveAttack:SetSumAttack(data)
    if self.inst.components.move_attack then
        -- 更新网络变量，仅在主机执行
        data = data or 0
        self._sumattack:set(data)
        print("sumattack"..data)
    end
end

function MoveAttack:GetSumAttack()
    if self.inst.components.move_attack ~= nil then
        -- 在主机直接读取component的值
        return self.inst.components.move_attack.sumattack
    else
        -- 在客机读取网络变量的值
        return self._sumattack:value()
    end
end

function MoveAttack:SetLevelUpPercent(data)
    if self.inst.components.move_attack then
        -- 更新网络变量，仅在主机执行
        data = data or 0
        self._leveluppercent:set(data)
        print("percent:"..data)
    end
end

function MoveAttack:GetLevelUpPercent()
    if self.inst.components.move_attack ~= nil then
        -- 在主机直接读取component的值
        return self.inst.components.move_attack.leveluppercent
    else
        -- 在客机读取网络变量的值
        return self._leveluppercent:value()
    end
end

function MoveAttack:SetLevelUping(data)
    if self.inst.components.move_attack then
        -- 更新网络变量，仅在主机执行
        data = data or true
        self._leveluping:set(data)
        print("leveluping:"data)
    end
end

function MoveAttack:GetLevelUping()
    if self.inst.components.move_attack ~= nil then
        -- 在主机直接读取component的值
        return self.inst.components.move_attack.leveluping
    else
        -- 在客机读取网络变量的值
        return self._leveluping:value()
    end
end

function MoveAttack:SetOldPosition(data)
    if self.inst.components.move_attack then
        -- 更新网络变量，仅在主机执行
        data = data or 0
        self._oldposition:set(data)
        print("oldposition:"data)
    end
end

function MoveAttack:GetOldPosition()
    if self.inst.components.move_attack ~= nil then
        -- 在主机直接读取component的值
        return self.inst.components.move_attack.oldposition
    else
        -- 在客机读取网络变量的值
        return self._oldposition:value()
    end
end

return MoveAttack