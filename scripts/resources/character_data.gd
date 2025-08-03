class_name CharacterData extends Resource

## The name of the character
@export var name: String

## Must be very short and lightweight, preferrably a WAV
## or a Randomiser containing WAVs
@export var sound: AudioStream

## The closer to 0, the more monotone their sound will sound
@export var pitch_variety: float = 1.0
