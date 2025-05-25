extends VBoxContainer
class_name PauseMenu

signal resume_pressed
signal restart_pressed
signal return_pressed


func _on_return_button_pressed() -> void:
	return_pressed.emit()

func _on_restart_button_pressed() -> void:
	restart_pressed.emit()

func _on_resume_button_pressed() -> void:
	resume_pressed.emit()
    

