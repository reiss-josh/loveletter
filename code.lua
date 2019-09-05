--[[ Lua code. See documentation: https://api.tabletopsimulator.com/ --]]

--[[ The onLoad event is called after the game save finishes loading. --]]
gameDeck = {}
dealerQuarter = {}
resetQuarter = {}
clearQuarter = {}
globalCard = nil
hasDealt = false

--fills global containers for scripted objects
function onLoad()
    gameDeck = spawnDeck()
    dealerQuarter = buttonSpawner(-10, 10, 'dealCards', 'DEAL', 14, 12, 4)
    resetQuarter = buttonSpawner(-10.5, 11, 'clearHands', 'RESET', 7, 12.5, -4)
    clearQuarter = buttonSpawner(-11, 11, 'clearScriptables', 'CLEAR', 7, 13, 4)
    drawQuarter = buttonSpawner(-11.5, 11, 'dealCardToPlayer', 'DRAW', 15, 13.5, -4)
    hasDealt = false
    print('loaded!')
end

--helper function for 'DEAL' button
function dealCardToPlayer(obj, color)
    gameDeck.dealToColor(1, color)
end

--helper function for card removal timer
function destroyThing()
    globalCard.destruct()
end

--deals 1 card to all players and removes a card from the deck (after waiting 60 frames)
function dealCards()
    globalCard = gameDeck.takeObject({index = 0, position = {-8,1.3,0}, rotation = {180,0,0}})
    gameDeck.dealToAll(1)
    Wait.frames(destroyThing, 60)
    hasDealt = true
end

--spawns the deck object and returns it
function spawnDeck()
    local deckHolder = {}
    deckHolder.type = 'DeckCustom'
    deckHolder.position = {0,1,0}
    deckHolder.rotation = {0,180,180}
    dealdeck = spawnObject(deckHolder)
    customDeck = {}
    customDeck.width = 8
    customDeck.height = 7
    customDeck.face = 'https://raw.githubusercontent.com/reiss-josh/loveletter/master/testdeck5.png'
    customDeck.back = 'http://i.imgur.com/QFhp7nF.jpg'
    customDeck.unique_back = false
    customDeck.number = 16
    dealdeck.setCustomObject(customDeck)
    dealdeck.shuffle()
    return dealdeck
end

--empties the hands of all seated players
function clearHands()
    player_colors = getSeatedPlayers()

    for _, color in ipairs(player_colors) do
        handTable = Player[color].getHandObjects()
        for _, card in ipairs(handTable) do
          card.destruct()
        end
    end
    if (gameDeck != nil) then gameDeck.destruct() end
    gameDeck = spawnDeck()
    hasDealt = false
end

--destroys all scriptable objects (useful for my uploading / removing buttons)
function clearScriptables()
    if (gameDeck != nil) then gameDeck.destruct() end
    if (dealerQuarter != nil) then dealerQuarter.destruct() end
    if (resetQuarter != nil) then resetQuarter.destruct() end
    if (clearQuarter != nil) then clearQuarter.destruct() end
    if (drawQuarter != nil) then drawQuarter.destruct() end
end

--spawns a quarter and attaches a button to it
--quarter spawns at {0,y,z}
--button spawns at {xb, yb, zb} with label 'label' and calls function 'func'
function buttonSpawner(y, z, func, label, xb, yb, zb)
    local obj = {}
    obj.type = 'Quarter'
    obj.position = {0, y, z}
    obj.rotation = {0, -90, 0}
    deal_token = spawnObject(obj)
    deal_token.use_gravity = false
    deal_token.interactable = false
    local button = {}
    button.click_function = func
    button.label = label
    button.function_owner = Global
    button.position = {xb, yb, zb}
    button.rotation = {0, -90, 0}
    button.width = 1000
    button.height = 500
    button.font_size = 250

    deal_token.createButton(button)
    return deal_token
end

--updates button visibility (hides 'DEAL' mid-game and hides 'DRAW' before setup)
function onUpdate()
    if hasDealt == true then
      dealerQuarter.setInvisibleTo(Player.getColors())
      drawQuarter.setInvisibleTo(nil)
    else
      dealerQuarter.setInvisibleTo(nil)
      drawQuarter.setInvisibleTo(Player.getColors())
    end
end
--[[ Deal Cards. --]]
--front http://i.imgur.com/tysJ4C9.jpg
--back http://i.imgur.com/QFhp7nF.jpg
