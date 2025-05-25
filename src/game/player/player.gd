extends Area2D
class_name Player

signal score_earned()
signal hit()
signal game_over()

signal colour_changed()

@export var SPEED: float = 300.0

@onready var sprite_material: ShaderMaterial = $Sprite2D.material

var colors: Array[Color]:
	set(value):
		colors = value

		if colors.size() > 0:
			current_color = colors[0]

var keys: Array[StringName] = [
	"top_left",
	"top",
	"top_right",
	"left",
	"middle",
	"right",
	"bottom_left",
	"bottom",
	"bottom_right",
]

var current_color: Color:
	set(value):
		current_color = value
		sprite_material.set_shader_parameter("color", value)

var health: int = 3:
	set(value):
		health = clamp(value, 0, 3)

		if health <= 0:
			game_over.emit()

var dead: bool = false

func _input(event: InputEvent) -> void:

	# check if the event is a key press
	if event is InputEventKey and event.is_pressed():

		var index: int = -1

		# check if the key is in the keys array
		for i in range(keys.size()):
			if event.is_action_pressed(keys[i]):
				index = i
				break

		# if there is an index and it is within the bounds of the colors array
		if not index == -1 and index < colors.size():

			# set the current color to the color at that index
			# the setter for current color will change the color in the shader
			current_color = colors[index]

			## could also be done in the setter
			colour_changed.emit()

func _process(delta: float) -> void:

	if dead:
		return

	var velocity: Vector2 = Vector2.ZERO

	var vertical_direction: float = Input.get_axis("move_up", "move_down")
	if vertical_direction:
		velocity.y = vertical_direction

	var horizontal_direction: float = Input.get_axis("move_left", "move_right")
	if horizontal_direction:
		velocity.x = horizontal_direction

	velocity = velocity.normalized() * SPEED * delta
	position += velocity

	# clamp to visible screen area, with margin for size
	var screen_size = get_viewport_rect().size

	# the characters is 40x40
	position.x = clamp(position.x, 20, screen_size.x - 20)
	position.y = clamp(position.y, 20, screen_size.y - 20)


func _on_area_entered(area: Area2D) -> void:

	if area is Line:
		var line = area as Line

		if line.current_color == current_color:
			score_earned.emit()
		else:
			health -= 1
			hit.emit()
