extends Camera2D
class_name Camera

# camera shake taken from: https://www.youtube.com/watch?v=LGt-jjVf-ZU

@export var random_strength: float = 20.0
@export var shake_fade: float = 5.0

var rng = RandomNumberGenerator.new()

var shake_strength: float = 0.0


func shake() -> void:
    shake_strength = random_strength

func random_offset() -> Vector2:
    return Vector2(
        rng.randf_range(-shake_strength, shake_strength),
        rng.randf_range(-shake_strength, shake_strength)
    )

func _process(delta: float) -> void:

    if shake_strength > 0:
        shake_strength = lerpf(shake_strength, 0, shake_fade * delta)

        offset = random_offset()