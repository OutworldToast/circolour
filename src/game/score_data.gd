extends Resource
class_name ScoreData

@export var scores: Array[int]

func save() -> void:
    ResourceSaver.save(self, "user://score_data.tres")

static func load_or_create() -> ScoreData:

    var path: String = "user://score_data.tres"

    if ResourceLoader.exists(path):
        return ResourceLoader.load(path) as ScoreData
    else:
        return ScoreData.new()