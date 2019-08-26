--[[ Lua code. See documentation: https://api.tabletopsimulator.com/ --]]

--[[ The onLoad event is called after the game save finishes loading. --]]
gameDeck = {}
dealerQuarter = {}
resetQuarter = {}
clearQuarter = {}

function dealCards()
    --deck_guid = '4dd013'
    --local deck = getObjectFromGUID(deck_guid)
    gameDeck.takeObject({index = 0, position = {-8,1.3,0}, rotation = {180,0,0}})
    gameDeck.dealToAll(1)
end

function spawnDeck()
    local deckHolder = {}
    deckHolder.type = 'DeckCustom'
    deckHolder.position = {0,1,0}
    deckHolder.rotation = {0,180,180}
    dealdeck = spawnObject(deckHolder)
    customDeck = {}
    customDeck.width = 8
    customDeck.height = 7
    customDeck.face = 'https://raw.githubusercontent.com/SciKarate/loveletter/master/testdeck5.png'
    customDeck.back = 'http://i.imgur.com/QFhp7nF.jpg'
    customDeck.unique_back = false
    customDeck.number = 16
    dealdeck.setCustomObject(customDeck)
    dealdeck.shuffle()
    return dealdeck
end

function clearHands()
    --[[playerList = Player.getPlayers()
    i = 1
    for _, playerReference in ipairs(playerList) do
        x = playerReference.getHandObjects(i)
        for a,b in ipairs(x) do
          print(a)
          print(b)
        end
        print('end')
        i = i + 1
    end--]]
    if (gameDeck != nil) then gameDeck.destruct() end
    gameDeck = spawnDeck()
end

function clearScriptables()
    if (gameDeck != nil) then gameDeck.destruct() end
    if (dealerQuarter != nil) then dealerQuarter.destruct() end
    if (resetQuarter != nil) then resetQuarter.destruct() end
    if (clearQuarter != nil) then clearQuarter.destruct() end
end

function spawnDealer()
    local obj = {}
    obj.type = 'Quarter'
    obj.position = {0, -10, 10}
    obj.rotation = {0, -90, 0}
    deal_token = spawnObject(obj)
    deal_token.use_gravity = false
    deal_token.interactable = false
    local button = {}
    button.click_function = 'dealCards'
    button.label = 'DEAL'
    button.function_owner = Global
    button.position = {6, 12, 0}
    button.rotation = {0, -90, 0}
    button.width = 1000
    button.height = 500
    button.font_size = 250

    deal_token.createButton(button)
    return deal_token
end

function spawnReset()
    local obj = {}
    obj.type = 'Quarter'
    obj.position = {0, -10.5, 11}
    obj.rotation = {0, -90, 0}
    deal_token = spawnObject(obj)
    deal_token.use_gravity = false
    deal_token.interactable = false
    local button = {}
    button.click_function = 'clearHands'
    button.label = 'RESET'
    button.function_owner = Global
    button.position = {7, 12.5, -4}
    button.rotation = {0, -90, 0}
    button.width = 1000
    button.height = 500
    button.font_size = 250

    deal_token.createButton(button)
    return deal_token
end

function spawnClear()
    local obj = {}
    obj.type = 'Quarter'
    obj.position = {0, -11, 11}
    obj.rotation = {0, -90, 0}
    deal_token = spawnObject(obj)
    deal_token.use_gravity = false
    deal_token.interactable = false
    local button = {}
    button.click_function = 'clearScriptables'
    button.label = 'CLEAR'
    button.function_owner = Global
    button.position = {7, 13, 4}
    button.rotation = {0, -90, 0}
    button.width = 1000
    button.height = 500
    button.font_size = 250

    deal_token.createButton(button)
    return deal_token
end

function onLoad()
    gameDeck = spawnDeck()
    dealerQuarter = spawnDealer()
    resetQuarter = spawnReset()
    clearQuarter = spawnClear()
    print('loaded!')
end

--[[ The onUpdate event is called once per frame. --]]
function onUpdate()
    --[[ print('onUpdate loop!') --]]
end
--[[ Deal Cards. --]]
--front http://i.imgur.com/tysJ4C9.jpg
--back http://i.imgur.com/QFhp7nF.jpg
