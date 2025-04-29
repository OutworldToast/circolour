extends Node2D
class_name Game

@export var colors: Array[Color] = [
    Color(1, 0, 0),
    Color(0, 1, 0),
    Color(0, 0, 1),
    Color(1, 1, 0),
    Color(1, 0, 1),
    Color(0, 1, 1),
    Color(1, 0.7, 0),
    Color(0.7, 1, 0),
    Color(0, 0.5, 1),
]

@onready var player: Player = $Player


func _ready() -> void:
    player.colors = colors
