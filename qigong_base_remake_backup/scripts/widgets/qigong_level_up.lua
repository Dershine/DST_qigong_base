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

local qigong_level_up = Class(Widget, function(self, inst)
    
    self.inst = inst
    self.tasks = {}
    self.visiable = false
  
    Widget._ctor(self, "qigong_level_up")

    self.root = self:AddChild(Widget("root"))

    self.root:SetVAnchor(ANCHOR_MIDDLE)
    self.root:SetHAnchor(ANCHOR_MIDDLE)
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

    local COLOR = UICOLOURS.BLACK
    if self.fromfrontend then
      COLOR = UICOLOURS.GOLD
    end

    --眼睛
    self.root.tree = self.root:AddChild(Image("images/skilltree.xml", "skill_icon_textbox.tex"))
    self.root.tree:SetPosition(3,160)
    self.root.tree:ScaleToSize(55,55)
    self.root.tree:SetTint(COLOR[1],COLOR[2],COLOR[3],1)

    --眼睛里的数字
    self.root.tree =self.root:AddChild(Text(HEADERFONT, 20, 0, COLOR)) 
    self.root.tree:SetPosition(3,155)

    --提示文字
    self.root.tree = self.root:AddChild(Text(HEADERFONT,20, 0, COLOR))
    self.root.tree:SetPosition(65,160)  
    self.root.tree:SetString("锋芒觉意")
end)

return qigong_level_up