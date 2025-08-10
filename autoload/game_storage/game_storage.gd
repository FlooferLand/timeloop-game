## This script contains things stored globally, usually to be passed between elvels
## DO NOT store references to nodes here and all
## Will be reset when the game resets
extends Node

## Set by the elevator doors script; If the player has a bunny item when entering the elevator
var will_have_bnnuy_in_elevator := false

func reset() -> void:
	will_have_bnnuy_in_elevator = false
