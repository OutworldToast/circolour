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

@export var BASE_LINE_DELAY: float = 1.8
@export var MIN_LINE_DELAY: float = 1.0

@onready var player: Player = $Player
@onready var line: Line = $Line
@onready var grid_container: GridContainer = $CanvasLayer/HUD/PanelContainer/GridContainer

@onready var camera: Camera = $Camera2D

@onready var viewport_size: Vector2 = get_viewport().get_visible_rect().size

@onready var multiplier_label: Label = $CanvasLayer/HUD/MultiplierLabel
@onready var score_label: Label = $CanvasLayer/HUD/ScoreLabel

@onready var health_bar: HealthBar = $CanvasLayer/HUD/HealthBar

## it might be better for the trail to be a child of the player?
## the position gets weird if so
@onready var current_trail: Trail = $Trail

@onready var high_scores: HighScores = $CanvasLayer/HUD/HighScores


@onready var player_start_position: Vector2 = player.position
@onready var line_start_position: Vector2 = line.position


const HUD_COLOUR_SCENE: PackedScene = preload("uid://dw1delj4qvwby")
const TRAIL_SCENE: PackedScene = preload("uid://dyerbmhiyfilw")


var current_score: float = 0:
	set(value):
		current_score = value
		score_label.text = str(int(current_score))

var current_multiplier: float = 1.0:
	set(value):
		current_multiplier = value
		multiplier_label.text = "x" + str(snappedf(current_multiplier, 0.1))
		multiplier_label.shake(current_multiplier)


var current_streak: int = 0:
	set(value):
		# update the score whenever the streak gets higher
		if value > 0:
			current_score += current_multiplier

		current_streak = value
		update_multiplier()

var ongoing: bool = false:
	set(value):
		ongoing = value
		line.toggle_pause(not value)
		player.dead = not value

var scores: Array[int] = []

func start() -> void:

	ongoing = true

	$Music.play()

	player.health = 3
	health_bar.reset()

	current_score = 0
	current_streak = 0

	high_scores.disappear()

	multiplier_label.show()
	score_label.show()

	player.position = player_start_position
	line.position = line_start_position

	line.move(Vector2(viewport_size.x, line.position.y), calculate_line_delay())



func create_hud_color(colour: Color, key_string: String = "") -> void:

	var hud_colour: HudColour = HUD_COLOUR_SCENE.instantiate()
	grid_container.add_child(hud_colour)

	hud_colour.current_color = colour
	hud_colour.key_string = key_string

func update_trail() -> void:
	var previous_trail: Trail = current_trail

	current_trail = TRAIL_SCENE.instantiate()
	current_trail.player = player

	add_child(current_trail)

	var tween = create_tween()
	tween.tween_property(previous_trail, "modulate:a", 0.0, previous_trail.trail_duration)
	await tween.finished

	previous_trail.queue_free()

func calculate_line_delay() -> float:

	var speed_multiplier: float = 0.5

	# calculate the delay based on the current score
	return clamp(BASE_LINE_DELAY / (speed_multiplier * current_multiplier), MIN_LINE_DELAY, BASE_LINE_DELAY)

func update_multiplier() -> void:

	# ramping formula created with use of ai
	# the goal was a multiplier that eases out

	var max_multiplier := 4.0

	# tweak this to control how fast it ramps
	# higher is faster ramping
	var multiplier_scale := 0.08
	current_multiplier = 1.0 + (max_multiplier - 1.0) * (1.0 - exp(-multiplier_scale * current_streak))

func _ready() -> void:

	player.colors = colors
	current_trail.default_color = colors[0] if colors else Color(1, 1, 1)
	line.current_color = colors[1]

	line.finished_movement.connect(_on_line_finished_movement)

	# clean up the grid container used for display in the editor
	for child in grid_container.get_children():
		child.queue_free()

	# remake the grid container with the right colors
	for i in range(colors.size()):
		var colour: Color = colors[i]

		# # the key string is too big to fit in the circle
		# # so this is commented out
		# var input_event: InputEventKey = InputMap.action_get_events(player.keys[i])[0] as InputEventKey
		# var key_string: String = input_event.as_text()

		create_hud_color(colour)

	start()


func _on_line_finished_movement() -> void:

	line.current_color = colors.pick_random()

	var target_x: float
	if line.position.x < 10:
		target_x = viewport_size.x
	elif line.position.x > viewport_size.x - 10:
		target_x = 0

	line.move(Vector2(target_x, line.position.y), calculate_line_delay())

func _on_player_score_earned() -> void:
	camera.shake()

	# updating the streak also updates the score and multiplier in the setter
	current_streak += 1
	$PointEarnedAudio.play()


func _on_player_hit() -> void:

	# also updates multiplier in the setter
	current_streak = 0
	$HitAudio.play()



func _on_player_colour_changed() -> void:
	# play some audio?
	update_trail()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()


func _on_player_game_over() -> void:

	ongoing = false

	$GameOverAudio.play()
	$Music.stop()

	scores.append(int(current_score))

	high_scores.set_labels(scores, colors)
	high_scores.appear()

	score_label.hide()
	multiplier_label.hide()


func _on_try_again_button_pressed() -> void:
	start()
