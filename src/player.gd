extends Area2D
class_name Player

@export var SPEED: float = 200.0
@export var colours: Array[Color]

@onready var sprite_material: ShaderMaterial = $Sprite2D.material as ShaderMaterial

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

func _ready() -> void:
	if colours:
		current_color = colours[0]
	else:
		print("No colours provided, using default color.")

func _input(event: InputEvent) -> void:

	if event is InputEventKey and event.is_pressed():

		var index: int = keys.find(event.keycode)

		if not index == -1 and index < colours.size():
			current_color = colours[index]

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
