extends Node2D
class_name MiniGame

@export var colors: Array[Color] = [
	Color(1, 0, 0),
	Color(0, 1, 0),
	Color(0, 0, 1),
	Color(1, 1, 0),
	Color(1, 0, 1),
	Color(0, 1, 1),
	Color(1, 0.7, 0),
	Color(0.7, 1, 0.7),
	Color(1, 0.8, 0.8),
]

@onready var player: Player = $Player
@onready var player_start_position: Vector2 = player.position

## it might be better for the trail to be a child of the player?
## the position gets weird if so
@onready var current_trail: Trail = $Trail

const TRAIL_SCENE: PackedScene = preload("uid://dyerbmhiyfilw")


func _ready() -> void:

	player.colors = colors
	current_trail.default_color = colors[0] if colors else Color(1, 1, 1)

func update_trail() -> void:
	var previous_trail: Trail = current_trail

	current_trail = TRAIL_SCENE.instantiate()
	current_trail.player = player

	add_child(current_trail)

	var tween = create_tween()
	tween.tween_property(previous_trail, "modulate:a", 0.0, previous_trail.trail_duration)
	await tween.finished

	previous_trail.queue_free()

func _on_player_colour_changed() -> void:
	# play some audio?
	update_trail()