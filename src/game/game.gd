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
@onready var line: Line = $Line
@onready var viewport_size: Vector2 = get_viewport().get_visible_rect().size

func _ready() -> void:
    player.colors = colors
    line.current_color = colors[1]

    line.finished_movement.connect(_on_line_finished_movement)
    line.move(Vector2(viewport_size.x, line.position.y))

func _on_line_finished_movement() -> void:
    line.current_color = colors.pick_random()
    print("Key to press: %s" % OS.get_keycode_string(player.keys[colors.find(line.current_color)]))


    var target_x: float
    if line.position.x < 10:
        target_x = viewport_size.x
    elif line.position.x > viewport_size.x - 10:
        target_x = 0

    line.move(Vector2(target_x, line.position.y), 1.5)