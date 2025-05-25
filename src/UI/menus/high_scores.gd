extends VBoxContainer
class_name HighScores

signal try_again_pressed()

@export var score_appear_delay: float = 0.5


@onready var labels: Array[RichTextLabel] = get_labels()
@onready var try_again_button: Button = $TryAgainButton

func _ready() -> void:
	disappear()

func get_labels() -> Array[RichTextLabel]:
	var result: Array[RichTextLabel] = []

	for child in $VBoxContainer.get_children():
		if child is RichTextLabel:
			result.append(child)

	if not result:
		push_error("no labels found")

	return result

func set_labels(scores: Array[int], colours: Array[Color] = []) -> void:

	# sort the array
	var sorted_scores: Array[int] = scores.duplicate()
	sorted_scores.sort()

	# set the labels in reverse order
	for i in range(labels.size()):
		if i < sorted_scores.size():

			var colour: Color

			if colours:
				colour = colours.pick_random()
				colours.erase(colour)
			else:
				colour = Color(1, 1, 1)

			set_label(i, sorted_scores[sorted_scores.size() - 1 - i], colour)

		else:
			set_label(i, 0, Color(0.5, 0.5, 0.5))  # Set to grey if no score available


func set_label(index: int, value: int, colour: Color) -> void:

	if index < 0 or index >= labels.size():
		return

	var label: RichTextLabel = labels[index]
	label.text = "[wave][center]%s[/center][/wave]" % str(value)
	label.add_theme_color_override("default_color", colour)


func appear() -> void:
	show()


	var current_delay: float = score_appear_delay

	for label in labels:
		# Wait for the delay before showing the next label
		await get_tree().create_timer(current_delay).timeout
		label.show()

		current_delay *= 0.65

	await get_tree().create_timer(score_appear_delay).timeout

	try_again_button.show()

func disappear() -> void:
	hide()

	for label in labels:
		label.hide()

	try_again_button.hide()


func _on_try_again_button_pressed() -> void:
	# relay the signal
	try_again_pressed.emit()
