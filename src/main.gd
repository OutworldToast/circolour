extends Node2D
class_name Main

@onready var high_scores: HighScores = $CanvasLayer/UI/HighScores
@onready var pause_menu: PauseMenu = $CanvasLayer/UI/PauseMenu

@onready var main_menu: MainMenu = $CanvasLayer/UI/MainMenu
@onready var tutorial_menu: VBoxContainer = $CanvasLayer/UI/TutorialMenu
@onready var volume_slider: VolumeSlider = $CanvasLayer/UI/VolumeSlider

@onready var main_game: Game = $Game
@onready var mini_game: MiniGame = $MiniGame

var fullscreen: bool = false:
	set(value):
		fullscreen = value

		if fullscreen:
			settings_data.window_size = DisplayServer.window_get_size()
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_size(settings_data.window_size)

		save_settings_data()


var score_data: ScoreData
var settings_data: SettingsData

func _ready() -> void:

	# load data
	load_score_data()
	load_settings_data()

	toggle_main_game(false)

#region Helpers
func toggle_main_game(on: bool) -> void:

	if on:
		if not main_game.is_inside_tree():
			add_child(main_game)

		main_game.start()
	else:
		if main_game.is_inside_tree():
			remove_child(main_game)

		main_game.ongoing = false

func handle_pause() -> void:
	get_tree().paused = not get_tree().paused
	pause_menu.visible = get_tree().paused


func return_to_main_menu() -> void:
	main_menu.visible = true
	volume_slider.visible = true

	if not mini_game.is_inside_tree():
		add_child(mini_game)

func load_score_data() -> void:
	score_data = ScoreData.load_or_create()
	main_game.scores = score_data.scores

func save_score_data() -> void:
	score_data.scores = main_game.scores
	score_data.save()

func load_settings_data() -> void:
	settings_data = SettingsData.load_or_create()

	volume_slider.slider.value = settings_data.volume

	fullscreen = settings_data.fullscreen

	if not fullscreen:
		DisplayServer.window_set_size(settings_data.window_size)


	if settings_data.colors:
		main_game.colors = settings_data.colors

func save_settings_data() -> void:
	settings_data.fullscreen = fullscreen

	if not fullscreen:
		settings_data.window_size = DisplayServer.window_get_size()

	settings_data.volume = volume_slider.slider.value

	settings_data.colors = main_game.colors
	settings_data.save()

#endregion Helpers


#region ButtonSignals

func _on_exit_button_pressed() -> void:
	save_settings_data()
	get_tree().quit()


func _on_tutorial_button_pressed() -> void:
	tutorial_menu.visible = true
	main_menu.visible = false
	volume_slider.visible = false

	if mini_game.is_inside_tree():
		remove_child(mini_game)


func _on_start_button_pressed() -> void:

	if mini_game.is_inside_tree():
		remove_child(mini_game)

	main_menu.visible = false

	toggle_main_game(true)


func _on_tutorial_menu_return_button_pressed() -> void:
	tutorial_menu.visible = false
	return_to_main_menu()


func _on_pause_menu_restart_pressed() -> void:
	handle_pause()
	main_game.ongoing = false
	main_game.start()


func _on_pause_menu_resume_pressed() -> void:
	pause_menu.visible = false
	await main_game.start_signal()
	get_tree().paused = false


func _on_pause_menu_return_pressed() -> void:
	handle_pause()
	toggle_main_game(false)
	return_to_main_menu()

#endregion ButtonSignals

func _on_game_score_earned() -> void:
	save_score_data()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") and main_game.ongoing:
		handle_pause()

	if Input.is_action_just_pressed("fullscreen"):

		fullscreen = not fullscreen


func _on_volume_slider_volume_changed(_value: float) -> void:
	save_settings_data()
