extends Line2D
class_name Trail

# could be a node2d as well
# its nice if its player, since we know it has a current color
@export var player: Player

@export var trail_duration: float = 1.5

@onready var curve: Curve2D = Curve2D.new()

const MAX_POINTS: int = 150

var drawing: bool = true

func _ready() -> void:

	if player:
		default_color = player.current_color
		player.game_over.connect(_on_player_game_over)

func clear() -> void:
	curve.clear_points()
	points = []

func _on_player_game_over() -> void:
	drawing = false

func _process(_delta: float) -> void:

	if not player or not drawing:
		return

	curve.add_point(player.global_position)

	if curve.get_baked_points().size() > MAX_POINTS:
		curve.remove_point(0)

	points = curve.get_baked_points()
