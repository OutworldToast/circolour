extends Resource
class_name SettingsData

@export var fullscreen: bool = false
@export var window_size: Vector2 = Vector2(1280, 720)

@export var volume: float = 50.0
@export var colors: Array[Color] = []

func save() -> void:
    ResourceSaver.save(self, "user://settings_data.tres")

static func load_or_create() -> SettingsData:

    var path: String = "user://settings_data.tres"

    if ResourceLoader.exists(path):
        return ResourceLoader.load(path) as SettingsData
    else:
        return SettingsData.new()