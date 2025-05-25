extends Node2D
class_name Main

@onready var high_scores: HighScores = $CanvasLayer/UI/HighScores
@onready var paused_label: Label = $CanvasLayer/UI/PausedLabel

var fullscreen: bool = false

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("pause") and not high_scores.visible:
        get_tree().paused = not get_tree().paused
        paused_label.visible = get_tree().paused
    else:
        pass

    if Input.is_action_just_pressed("fullscreen"):

        fullscreen = not fullscreen

        if fullscreen:
            DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
        else:
            DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
            DisplayServer.window_set_size(Vector2(1280, 720))