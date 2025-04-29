extends Control
class_name HudColour

# duplicate the material to avoid modifying the original
@onready var sprite_material: ShaderMaterial = $TextureRect.material.duplicate()

var current_color: Color:
	set(value):
		current_color = value
		sprite_material.set_shader_parameter("color", value)

var key_string: String:
	set(value):
		key_string = value
		$TextureRect/Label.text = value

func _ready() -> void:
	# apply the duplicated material
	$TextureRect.material = sprite_material
