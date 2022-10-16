sub init()
     m.optionsList = m.top.findNode("optionsList")
    m.currentOptionsList = m.top.findNode("currentOptionsList")
    m.videoQualityMenu = m.top.findNode("videoQualityMenu")
    m.displayedQuality = m.top.findNode("displayedQuality")
    m.displayedChatOption = m.top.findNode("displayedChatOption")
    
    m.videoQualities = ["1080p60","1080p","720p60","720p","480p","360p","160p"]
    
    initVideoQualityMenu()
    m.videoQualityMenu.checkedItem = m.global.videoQuality
    m.videoQualityMenu.jumpToItem = m.videoQualityMenu.checkedItem
    setDisplayedQuality()
    
    m.currentChatOption = m.global.chatOption
    setDisplayedChatOption()
    
    m.videoQualityMenu.ObserveField("itemSelected","onVideoQualitySelect")
    m.optionsList.ObserveField("itemFocused","onOptionFocusChange")
    m.optionsList.ObserveField("itemSelected","onOptionSelect")
    m.top.ObserveField("visible","onVisibilityChange")
end sub

sub onOptionFocusChange()
     m.currentOptionsList.jumpToItem = m.optionsList.itemFocused
end sub

sub onVisibilityChange()
     focusOptionsList()
end sub

sub onVideoQualitySelect()
     if m.global.videoQuality <> invalid
          m.global.setField("videoQuality", m.videoQualityMenu.checkedItem)
          if m.videoQualityMenu.checkedItem = 0 or m.videoQualityMenu.checkedItem = 2
              m.global.setField("videoFramerate", 60)
          else
              m.global.setField("videoFramerate", 30)
          end if
          saveVideoSettings()
          setDisplayedQuality()
          focusOptionsList()
     end if
end sub

sub onOptionSelect()
     selected = m.optionsList.itemSelected
     if selected = 0
         m.videoQualityMenu.setFocus(true)
         m.currentOptionsList.visible = false
         m.videoQualityMenu.visible = true
    else if selected  = 1
         m.currentChatOption = not m.currentChatOption
         m.global.setField("chatOption", m.currentChatOption)
         setDisplayedChatOption()
         saveVideoSettings()
    end if
end sub

sub focusOptionsList()
     m.optionsList.setFocus(true)
     m.currentOptionsList.visible = true
     m.videoQualityMenu.visible = false
end sub


sub initVideoQualityMenu()
     qualitiesAsContentNodes = []
    for each vq in m.videoQualities
          node = createObject("RoSGNode","ContentNode")
          node.title = vq
          qualitiesAsContentNodes.Push(node)
    end for
    m.videoQualityMenu.content.appendChildren(qualitiesAsContentNodes)
end sub

sub setDisplayedQuality()
     m.displayedQuality.update({"title": m.videoQualities[m.global.videoQuality]})
end sub

sub setDisplayedChatOption()
     displayOption = "Disabled"
    if m.currentChatOption
        displayOption = "Enabled"
   end if
    m.displayedChatOption.update({"title": displayOption})
end sub

'sub onBackPress()
 ''   if m.top.visible = false
        'm.videoQualityDropdown.visible = false
''        m.currentVideoQuality.visible = true
 ''   end if
'end sub

sub saveVideoSettings() as Void
    sec = createObject("roRegistrySection", "VideoSettings")
    sec.Write("VideoQuality", m.global.videoQuality.ToStr())
    sec.Write("VideoFramerate", m.global.videoFramerate.ToStr())
    sec.Write("ChatOption", m.global.chatOption.ToStr())
    sec.Flush()
end sub

sub onKeyEvent(key, press) as Boolean
    handled = false
    if press
        'currently not working'
        if key = "BACK"
          if m.videoQualityMenu.visible
               focusOptionsList()
               handled = true
          end if
        
        end if
    end if
    return handled
end sub