extends Control
class_name ShakeLabel

@export var max_shake_strength: float = 5.0

@onready var start_position: Vector2 = position

var rng = RandomNumberGenerator.new()

var shake_strength: float = 0.0


func shake(multiplier: float) -> void:

    if multiplier > 1.0:
        var exponent: float = 2.0

        shake_strength = max_shake_strength * pow(multiplier / 4.0, exponent)
    else:
        shake_strength = 0.0

func random_offset() -> Vector2:
    return Vector2(
        rng.randf_range(-shake_strength, shake_strength),
        rng.randf_range(-shake_strength, shake_strength)
    )

func _process(_delta: float) -> void:

    if shake_strength > 0:
        position = start_position + random_offset()
