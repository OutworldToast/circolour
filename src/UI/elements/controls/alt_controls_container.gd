extends VBoxContainer
class_name AltControlsContainer

@export var label_text: String = "To Example"

@onready var main_controls: ControlsContainer = $MainControlsContainer
@onready var alt_controls: ControlsContainer = $AltControlsContainer

func _ready() -> void:
    main_controls.label_text = label_text
    alt_controls.label_text = label_text


func _on_alt_button_toggled(toggled_on: bool) -> void:
    if toggled_on:
        main_controls.hide()
        alt_controls.show()
    else:
        main_controls.show()
        alt_controls.hide()