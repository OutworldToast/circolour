extends Area2D
class_name Line

@onready var sprite_material: ShaderMaterial = $Polygon2D.material

var current_color: Color:
    set(value):
        current_color = value
        sprite_material.set_shader_parameter("color", value)