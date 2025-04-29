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
	Color(0.7, 1, 0.7),
	Color(0, 0.5, 1),
]

@onready var player: Player = $Player
@onready var line: Line = $Line
@onready var grid_container: GridContainer = $CanvasLayer/HUD/PanelContainer/GridContainer

@onready var camera: Camera = $Camera2D

@onready var viewport_size: Vector2 = get_viewport().get_visible_rect().size

const HUD_COLOUR_SCENE: PackedScene = preload("uid://dw1delj4qvwby")

var current_score: int = 0:
	set(value):
		current_score = value
		$CanvasLayer/HUD/ScoreLabel.text = str(current_score)


func create_hud_color(colour: Color, key_string: String) -> void:

	var hud_colour: HudColour = HUD_COLOUR_SCENE.instantiate()
	grid_container.add_child(hud_colour)

	hud_colour.current_color = colour
	hud_colour.key_string = key_string


func _ready() -> void:

	player.colors = colors
	line.current_color = colors[1]

	line.finished_movement.connect(_on_line_finished_movement)
	line.move(Vector2(viewport_size.x, line.position.y))

	for child in grid_container.get_children():
		child.queue_free()

	for i in range(colors.size()):
		var colour: Color = colors[i]
		var key_string: String = OS.get_keycode_string(player.keys[i])
		create_hud_color(colour, key_string)

func _on_line_finished_movement() -> void:

	line.current_color = colors.pick_random()

	var target_x: float
	if line.position.x < 10:
		target_x = viewport_size.x
	elif line.position.x > viewport_size.x - 10:
		target_x = 0

	line.move(Vector2(target_x, line.position.y), 1.5)


func _on_player_score_earned() -> void:
	camera.shake()

	current_score += 1
	$PointEarnedAudio.play()

func _on_player_game_over() -> void:
	current_score = 0
	$GameOverAudio.play()
