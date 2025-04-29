extends Area2D
class_name Line

signal finished_movement

@onready var sprite_material: ShaderMaterial = $Polygon2D.material

var current_color: Color:
    set(value):
        current_color = value
        sprite_material.set_shader_parameter("color", value)

func move(goal_position: Vector2, delay: float = 1.0) -> void:

    var tween: Tween = create_tween()

    tween.tween_property(self, "position", goal_position, delay
        ).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

    tween.finished.connect(finished_movement.emit)
    