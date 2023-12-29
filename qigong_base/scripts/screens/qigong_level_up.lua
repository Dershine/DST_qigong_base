local Screen = require "widgets/screen"
local Widget = require "widgets/widget"
local Templates = require "widgets/templates"
local Text = require "widgets/text"
local ImageButton = require "widgets/imagebutton"
local Image = require "widgets/image"
local SkillTreeWidget = require "widgets/redux/skilltreewidget"
local TEMPLATES = require "widgets/redux/templates"
local skilltreedefs = require "prefabs/skilltree_defs"
local skilltreebuilder = require "widgets/redux/skilltreebuilder"
local UIAnim = require "widgets/uianim"

local qigong_level_up = Class(Screen, function(self, inst)
    -- Player instance
    self.inst = inst
     -- Any 'DoTaskInTime's or 'DoPeriodicTask's should be assigned in here
     -- These are cancelled upon close to prevent stale components
    self.tasks = {}
  
    -- If you want to maintain state look into GetModConfigData, Replicas, or TheSim:SetPersistentString
  
    -- Register screen name
    Screen._ctor(self, "qigong_level_up")
      
    -- Darken the game
    -- We're using the DST global assets
    -- self.black = self:AddChild(Image("images/global.xml", "square.tex"))
    -- self.black:SetVRegPoint(ANCHOR_MIDDLE)
    -- self.black:SetHRegPoint(ANCHOR_MIDDLE)
    -- self.black:SetVAnchor(ANCHOR_MIDDLE)
    -- self.black:SetHAnchor(ANCHOR_MIDDLE)
    -- self.black:SetScaleMode(SCALEMODE_FILLSCREEN)
    -- self.black:SetTint(0, 0, 0, .5)

      -- Set the inital position for all our future elements
    self.root = self:AddChild(Widget("root"))

    self.midlay = self.root:AddChild(Widget())

    self.root:SetVAnchor(ANCHOR_MIDDLE)
    self.root:SetHAnchor(ANCHOR_MIDDLE)
    -- 20 'pixels' to the right - This scales with the window size
    self.root:SetPosition(20, 0, 0)
    self.root:SetScaleMode(SCALEMODE_PROPORTIONAL)

    self.root.playerbg = self.root:AddChild(Image("images/skilltree2.xml", "background.tex"))
    self.root.playerbg:SetPosition(0,-20)
    self.root.playerbg:ScaleToSize(600, 460)

    self.bg_scratches = self.root:AddChild(Image("images/skilltree.xml", "background_scratches.tex"))
    self.bg_scratches:SetPosition(0,-20)
    self.bg_scratches:ScaleToSize(580, 460)

    self.bg_tree = self.root:AddChild(Image("images/hud/qigong_skill_bg.xml", "qigong_skill_bg.tex"))
    self.bg_tree:SetPosition(8,40)
    self.bg_tree:SetScale(0.65)

    self.root.infopanel = self.root:AddChild(Widget("infopanel"))
    self.root.infopanel:SetPosition(0,-148)

    self.root.infopanel.bg = self.root.infopanel:AddChild(Image("images/skilltree.xml", "wilson_background_text.tex"))
    self.root.infopanel.bg:ScaleToSize(470, 130)
    self.root.infopanel.bg:SetPosition(0, -10)

    -- self.root.infopanel.activatedbg = self.root.infopanel:AddChild(Image("images/skilltree.xml", "skilltree_backgroundart.tex"))
    -- self.root.infopanel.activatedbg:ScaleToSize(470/2.4, 156/3)  -- 196 , 52
    -- self.root.infopanel.activatedbg:SetPosition(0, -58)

    self.root.infopanel.activatedtext = self.root.infopanel:AddChild(Text(HEADERFONT, 18, STRINGS.SKILLTREE.ACTIVATED, UICOLOURS.BLACK))
    self.root.infopanel.activatedtext:SetPosition(0,-62)
    self.root.infopanel.activatedtext:SetSize(20)

    self.root.infopanel.activatebutton = self.root.infopanel:AddChild(ImageButton("images/global_redux.xml", "button_carny_long_normal.tex", "button_carny_long_hover.tex", "button_carny_long_disabled.tex", "button_carny_long_down.tex"))
    self.root.infopanel.activatebutton.image:SetScale(1)
    self.root.infopanel.activatebutton:SetFont(CHATFONT)
    self.root.infopanel.activatebutton:SetPosition(0,-61)
    self.root.infopanel.activatebutton.text:SetColour(0,0,0,1)
    self.root.infopanel.activatebutton:SetScale(0.5)
    self.root.infopanel.activatebutton:SetText("修炼")

    self.root.infopanel.title = self.root.infopanel:AddChild(Text(HEADERFONT, 18, "title", UICOLOURS.BROWN_DARK))
    self.root.infopanel.title:SetPosition(0,28)
    self.root.infopanel.title:SetVAlign(ANCHOR_TOP)

    self.root.infopanel.desc = self.root.infopanel:AddChild(Text(CHATFONT, 16, "desc", UICOLOURS.BROWN_DARK))
    self.root.infopanel.desc:SetPosition(0,-8)
    self.root.infopanel.desc:SetHAlign(ANCHOR_LEFT)
    self.root.infopanel.desc:SetVAlign(ANCHOR_TOP)
    self.root.infopanel.desc:SetMultilineTruncatedString(STRINGS.SKILLTREE.INFOPANEL_DESC, 3, 400, nil,nil,true,6)
    self.root.infopanel.desc:Hide()

    self.root.infopanel.intro = self.root.infopanel:AddChild(Text(CHATFONT, 18, "desc", UICOLOURS.BROWN_DARK))
    self.root.infopanel.intro:SetPosition(0,-10)
    self.root.infopanel.intro:SetHAlign(ANCHOR_LEFT)
    self.root.infopanel.intro:SetString(STRINGS.SKILLTREE.INFOPANEL_DESC)

    --重置洞察
    -- self.root.infopanel.respec_button = self.root.infopanel:AddChild(TEMPLATES.StandardButton(
    --     function()
    --         -- self:RespecSkills()
    --     end, STRINGS.SKILLTREE.RESPEC, {200, 50}))
    -- if TheInput:ControllerAttached() then
    --     self.root.infopanel.respec_button:SetText(TheInput:GetLocalizedControl(TheInput:GetControllerID(),  CONTROL_MENU_MISC_1).." "..STRINGS.SKILLTREE.RESPEC)
    -- end

    -- self.root.infopanel.respec_button:SetPosition(0,-120)

    self.root.tree = self.root:AddChild(skilltreebuilder(self.root.infopanel, self.fromfrontend, self))
    self.root.tree:SetPosition(0,-50)

    --背景的两个卷边，意义不明
    -- self.root.scroll_left  = self.root:AddChild(Image("images/skilltree2.xml", "overlay_left.tex"))
    -- self.root.scroll_left:ScaleToSize(44, 460)
    -- self.root.scroll_left:SetPosition(-278,-200)
    -- self.root.scroll_right = self.root:AddChild(Image("images/skilltree2.xml", "overlay_right.tex"))
    -- self.root.scroll_right:ScaleToSize(44, 460)
    -- self.root.scroll_right:SetPosition(278,-200)



    -- self.title = self.proot:AddChild(Text(NEWFONT_OUTLINE, 40, "Spawn Disaster", {unpack(GOLD)}))
    -- self.title:SetPosition(0, 250)

    -- self.animationUp = self.proot:AddChild(Text(NEWFONT_OUTLINE, 30, "Y: ", {unpack(RED)}))
    -- self.animationUp:SetPosition(-520, -350)
    -- -- Assign the task to the client
    -- self.tasks[#self.tasks + 1] = self.inst:DoPeriodicTask(.1, function()
    --   local pos = self.animationUp:GetPosition()
    --   self.animationUp:SetPosition(pos.x, pos.y > 350 and -350 or pos.y + 5)
    --   self.animationUp:SetString("Y: " .. pos.y)
    -- end)
  
    -- self.animationRight = self.proot:AddChild(Text(NEWFONT_OUTLINE, 30, "X: ", {unpack(RED)}))
    -- self.animationRight:SetPosition(-600, -290)
    -- -- Assign the task to the client
    -- self.tasks[#self.tasks + 1] = self.inst:DoPeriodicTask(.1, function()
    --   local pos = self.animationRight:GetPosition()
    --   self.animationRight:SetPosition(pos.x > 600 and -600 or pos.x + 5, pos.y)
    --   self.animationRight:SetString("X: " .. pos.x)
    -- end)

  --   self.panel = self.proot:AddChild(Tedux_templates.RectangleWindow(400, 500, "Destination", {
  --     {text = "Add", cb = function()end, offset = nil},
  --     {text = "Close", cb = function()end, offset = nil},
  -- }))
end)

function qigong_level_up:OnClose()
-- Cancel any started tasks
-- This prevents stale components
    for k,v in pairs(self.tasks) do
        if v then
            v:Cancel()
        end
    end
local screen = TheFrontEnd:GetActiveScreen()
-- Don't pop the HUD
if screen and screen.name:find("HUD") == nil then
    -- Remove our screen
    TheFrontEnd:PopScreen()
end
TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
end

function qigong_level_up:OnControl(control, down)
    -- Sends clicks to the screen
    if qigong_level_up._base.OnControl(self, control, down) then
      return true
    end
    -- Close UI on ESC
    if down and (control == CONTROL_PAUSE or control == CONTROL_CANCEL) then
      self:OnClose()
      return true
    end
end

return qigong_level_up