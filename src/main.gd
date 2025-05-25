extends Node2D
class_name Main

@onready var high_scores: HighScores = $CanvasLayer/UI/HighScores

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("pause") and not high_scores.visible:
        get_tree().paused = not get_tree().paused
    else:
        pass