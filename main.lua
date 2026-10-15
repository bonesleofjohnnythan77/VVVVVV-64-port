-- name: VVVVVV 64
-- description: A port of VVVVVV 64 by QJRocks, this hack has 3 levels with mechanics based on the original VVVVVV game, and it won the 6th place on the Simpleflips' Linear Hack Competition.\n\nCredits:\nB. Bones Johnson - Porter\npipocalio - Porter\nQJRocks - OG Hack Author\n
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
