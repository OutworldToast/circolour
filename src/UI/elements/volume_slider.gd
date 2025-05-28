extends VBoxContainer
class_name VolumeSlider

signal volume_changed(value: float)

## created following this tutorial https://www.youtube.com/watch?v=aFkRmtGiZCw

@export var bus_name: String = "Master"

@export var on_icon: Texture2D
@export var off_icon: Texture2D


@export var hidden_alpha: float = 0.3
@export var visible_alpha: float = 1.0


@onready var slider: VSlider = $VSlider
@onready var icon: TextureRect = $TextureRect

var bus_index: int

# stores the value before muting
var previous_value: float = 50.0

var visibility_tween: Tween

func _ready() -> void:

	$Label.text = str(int(slider.value))
	bus_index = AudioServer.get_bus_index(bus_name)

	modulate.a = 0.5

func _on_slider_value_changed(value: float) -> void:

	if bus_index == -1:
		printerr("Bus not found: %s" % bus_name)
		return

	var linear_value: float = value / 100.0

	AudioServer.set_bus_volume_linear(bus_index, linear_value)
	$Label.text = str(int(value))


	if value == 0.0:
		icon.texture = off_icon
	else:
		icon.texture = on_icon


func _on_slider_drag_ended(value_changed:bool) -> void:
	if value_changed:
		volume_changed.emit(slider.value)

func _on_texture_rect_gui_input(event:InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if slider.value == 0.0:
			# restore previous value if muted
			slider.value = previous_value
		else:
			# store current value before muting
			previous_value = slider.value
			slider.value = 0.0

		volume_changed.emit(slider.value)

func tween_visibility(visible_: bool) -> void:
	
	if visibility_tween:
		visibility_tween.kill()

	visibility_tween = create_tween()

	var goal_value: float = 0.0

	if visible_:
		goal_value = visible_alpha
	else:
		goal_value = hidden_alpha
		
	visibility_tween.tween_property(
		self, "modulate:a", goal_value, 0.2
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	


func _on_mouse_entered() -> void:
	tween_visibility(true)

func _on_mouse_exited() -> void:
	tween_visibility(false)