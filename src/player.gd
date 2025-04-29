extends Area2D
class_name Player

signal score_earned()
signal game_over()

@export var SPEED: float = 300.0

@onready var sprite_material: ShaderMaterial = $Sprite2D.material

var colors: Array[Color]:
	set(value):
		colors = value

		if colors.size() > 0:
			current_color = colors[0]

var keys: Array[Key] = [
	KEY_KP_7,
	KEY_KP_8,
	KEY_KP_9,
	KEY_KP_4,
	KEY_KP_5,
	KEY_KP_6,
	KEY_KP_1,
	KEY_KP_2,
	KEY_KP_3,
]

var current_color: Color:
	set(value):
		current_color = value
		sprite_material.set_shader_parameter("color", value)

func _input(event: InputEvent) -> void:

	# check if the event is a key press
	if event is InputEventKey and event.is_pressed():

		# get the index of the key pressed
		var index: int = keys.find(event.keycode)

		# if there is an index and it is within the bounds of the colors array
		if not index == -1 and index < colors.size():

			# set the current color to the color at that index
			# the setter for current color will change the color in the shader
			current_color = colors[index]

func _process(delta: float) -> void:

	var velocity: Vector2 = Vector2.ZERO

	var vertical_direction: float = Input.get_axis("move_up", "move_down")
	if vertical_direction:
		velocity.y = vertical_direction

	var horizontal_direction: float = Input.get_axis("move_left", "move_right")
	if horizontal_direction:
		velocity.x = horizontal_direction

	velocity = velocity.normalized() * SPEED * delta
	position += velocity


func _on_area_entered(area: Area2D) -> void:

	if area is Line:
		var line = area as Line

		if line.current_color == current_color:
			score_earned.emit()
		else:
			game_over.emit()
