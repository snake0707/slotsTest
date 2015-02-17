--
-- Created by IntelliJ IDEA.
-- User: mingzhen.pi
-- Date: 13-7-17
-- Time: PM3:47
-- To change this template use File | Settings | File Templates.
--
Slot = Slot or {}
Slot.com = Slot.com or {}
Slot.com.MoveDialog = Slot.ui.Dialog:extend({

    __className = 'Slot.com.MoveDialog',

    initWithCode = function(self, options)
        self:_super(options)
    end,

    moveToUp = function(self)
        local topPositon = cc.p(self._winsize.width / 2, self._winsize.height - self.rootNode:getContentSize().height / 2 - 5)

        -- 220 代表键盘的高度 估计值 50代表对话框按钮的上边缘距离对话框的下边缘的该度
        local relatedMoveHeight = 220 - (self._winsize.height / 2 - self.rootNode:getContentSize().height / 2 + 50)
        -- -5使对话框不要距离屏幕上边缘太近
        local canMoveHeight = self._winsize.height / 2 - self.rootNode:getContentSize().height / 2 - 5
        if relatedMoveHeight > 0 then
            if relatedMoveHeight > canMoveHeight then
                self.moveToTopAction = CCMoveTo:create(0.2, topPositon)
                self.rootNode:runAction(self.moveToTopAction)
            else
                self.moveToTopAction = CCMoveBy:create(0.2, cc.p(0, relatedMoveHeight))
                self.rootNode:runAction(self.moveToTopAction)
            end
        end
    end,

    moveToCenter = function(self)
        local centerPosition = cc.p(self._winsize.width / 2, self._winsize.height / 2)
        self.moveToCenterAction = CCMoveTo:create(0.2, centerPosition)
        self.rootNode:runAction(self.moveToCenterAction)
    end,

    moveToPosition = function(self, position)
        self.moveToCenterAction = CCMoveTo:create(0.2, position)
        self.rootNode:runAction(self.moveToCenterAction)
    end,

    getDefaultOptions = function(self)
        return U:extend(true, self:_super(), {
        })
    end

})
