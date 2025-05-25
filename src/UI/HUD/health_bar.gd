extends HBoxContainer
class_name HealthBar

@export var player: Player:
	set(value):
		if player:
			player.hit.disconnect(_on_player_hit)

		player = value

		if player:
			player.hit.connect(_on_player_hit)

@onready var health_icons: Array[Node]

func _ready() -> void:
	fill_icons()
	reset()

func fill_icons() -> void:

	for child in get_children():
		if child is TextureRect:
			health_icons.append(child)

func reset() -> void:

	for icon in health_icons:
		icon.visible = true


func _on_player_hit() -> void:
	health_icons[player.health].visible = false
