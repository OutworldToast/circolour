extends Area2D
class_name Line

signal finished_movement

@onready var sprite_material: ShaderMaterial = $Polygon2D.material

var current_color: Color:
    set(value):
        current_color = value
        sprite_material.set_shader_parameter("color", value)

var move_tween: Tween

func move(goal_position: Vector2, delay: float = 1.0) -> void:

    if move_tween:
        move_tween.kill()
    
    move_tween = create_tween()

    move_tween.tween_property(self, "position", goal_position, delay
        ).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

    move_tween.finished.connect(finished_movement.emit)

func toggle_pause(new_value: bool) -> void:
    if move_tween:
        if new_value:
            move_tween.pause()
        else:
            move_tween.play()