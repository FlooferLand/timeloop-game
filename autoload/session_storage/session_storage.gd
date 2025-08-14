## Global storage that never resets; Only resetting once the game is reopened ofc
## DO NOT store references to nodes here
class_name SessionStorageType extends Node

## Incremented every time a new game starts this session
## Used for analytics
var times_played: int = 0
