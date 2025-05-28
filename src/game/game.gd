extends MiniGame
class_name Game

signal score_earned

@export var high_scores: HighScores:
	set(value):

		if high_scores:
			high_scores.try_again_pressed.disconnect(_on_try_again_button_pressed)

		high_scores = value

		if high_scores:
			high_scores.try_again_pressed.connect(_on_try_again_button_pressed)

@export var BASE_LINE_DELAY: float = 1.8
@export var MIN_LINE_DELAY: float = 1.0


@onready var line: Line = $Line
@onready var grid_container: GridContainer = $CanvasLayer/HUD/PanelContainer/GridContainer

@onready var camera: Camera = $Camera2D

@onready var viewport_size: Vector2 = get_viewport().get_visible_rect().size

@onready var multiplier_label: Label = $MultiplierLabel
@onready var score_label: Label = $ScoreLabel
@onready var start_label: Label = $CanvasLayer/HUD/StartLabel

@onready var health_bar: HealthBar = $HealthBar

@onready var line_start_position: Vector2 = line.position
@onready var particle_position: Vector2 = $ParticlePositionMarker.position

const HUD_COLOUR_SCENE: PackedScene = preload("uid://dw1delj4qvwby")
const PARTICLE_SCENE: PackedScene = preload("uid://tms5sv0qyi4t")

var current_score: float = 0:
	set(value):
		current_score = value
		score_label.text = str(int(current_score))

		if current_score:
			# create a particle effect at the score label position
			var particles: CPUParticles2D = PARTICLE_SCENE.instantiate()

			add_child(particles)

			var pos: Vector2 = particle_position
			var x_offset: float = 15

			# keep it aligned if the score gets bigger
			if current_score > 10:
				pos.x -= x_offset

			if current_score > 100:
				pos.x -= x_offset

			if current_score > 1000:
				pos.x -= x_offset


			particles.position = pos
			particles.emitting = true

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
		else:
			update_round_score()

		current_streak = value
		update_multiplier()

var ongoing: bool = false:
	set(value):
		ongoing = value
		line.toggle_pause(not value)
		player.dead = not value

var scores: Array[int] = []

var round_start_score: int = 0
var best_round_score: int = 0

func start() -> void:

	player.health = 3
	health_bar.reset()

	current_score = 0
	current_streak = 0

	multiplier_label.show()
	score_label.show()

	player.position = player_start_position
	line.position = line_start_position

	current_trail.clear()
	current_trail.drawing = true

	await start_signal()

	ongoing = true

	line.move(Vector2(viewport_size.x, line.position.y), calculate_line_delay())

func start_signal() -> void:

	if not $Music.playing:
		$Music.play()

	start_label.show()

	for i in range(3, -1, -1):
		start_label.text = str(i) if i > 0 else "GO!"

		if get_tree():
			await get_tree().create_timer(0.4).timeout

	start_label.hide()

func create_hud_color(colour: Color, key_string: String = "") -> void:

	var hud_colour: HudColour = HUD_COLOUR_SCENE.instantiate()
	grid_container.add_child(hud_colour)

	hud_colour.current_color = colour
	hud_colour.key_string = key_string

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

func update_round_score() -> void:

	var current_round_score: int = int(current_score - round_start_score)
	
	if current_round_score > best_round_score:
		best_round_score = current_round_score

	round_start_score = int(current_score)

	print("Scored %d points this round!" % current_round_score)

func _ready() -> void:

	super()

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


func _on_line_finished_movement() -> void:

	line.current_color = colors.pick_random()

	var target_x: float
	if line.position.x < 10:
		target_x = viewport_size.x
	elif line.position.x > viewport_size.x - 10:
		target_x = 0

	line.move(Vector2(target_x, line.position.y), calculate_line_delay())

func _on_player_score_earned() -> void:
	# updating the streak also updates the score and multiplier in the setter
	current_streak += 1
	camera.shake(current_streak)
	$PointEarnedAudio.play()


func _on_player_hit() -> void:

	# also updates multiplier in the setter
	current_streak = 0
	$HitAudio.play()

func _on_player_game_over() -> void:

	ongoing = false

	$GameOverAudio.play()
	$Music.stop()

	scores.append(int(current_score))

	score_earned.emit()

	high_scores.set_labels(scores, colors)
	high_scores.appear()

	score_label.hide()
	multiplier_label.hide()


func _on_try_again_button_pressed() -> void:
	high_scores.disappear()
	start()
