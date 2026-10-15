-- name: VVVVVV 64
-- description: VVVVVV 64 Romhack port.
-- incompatible: romhack
require "data/scrolltex"
require "data/text"
require "data/tweaks"
require "src/init"
gServerSettings.stayInLevelAfterStar = STAR_LEAVE_LEVEL
gServerSettings.bubbleDeath = false
gBehaviorValues.ShowStarMilestones = false
gLevelValues.exitCastleLevel = LEVEL_CASTLE_GROUNDS
gLevelValues.exitCastleArea = 1
gLevelValues.exitCastleWarpNode = 10
gServerSettings.playerInteractions = PLAYER_INTERACTIONS_NONE
