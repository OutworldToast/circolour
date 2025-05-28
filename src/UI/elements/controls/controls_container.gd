extends VBoxContainer
class_name ControlsContainer

@export var label_text: String = "To Example"

@onready var top_row: HBoxContainer = $TopRow
@onready var center_row: HBoxContainer = $CenterRow
@onready var bottom_row: HBoxContainer = $BottomRow

@onready var label: Label = $Label

enum Positions {
    TOP_LEFT,
    TOP,
    TOP_RIGHT,
    CENTER_LEFT,
    CENTER,
    CENTER_RIGHT,
    BOTTOM_LEFT,
    BOTTOM,
    BOTTOM_RIGHT
}

@onready var prompts: Array[InputPrompt] = [
    $TopRow/Left,
    $TopRow/Center,
    $TopRow/Right,
    $CenterRow/Left,
    $CenterRow/Center,
    $CenterRow/Right,
    $BottomRow/Left,
    $BottomRow/Center,
    $BottomRow/Right
]

func _ready() -> void:

    set_row_visibility()
    
    label.text = label_text

func set_row_visibility() -> void:

    # make all rows invisible
    top_row.visible = false
    center_row.visible = false
    bottom_row.visible = false

    # check if any prompt has a texture
    # if so, make the corresponding row visible
    for prompt in prompts:
        if prompt.texture:
            prompt.get_parent().visible = true