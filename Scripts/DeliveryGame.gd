extends Node2D
signal time_up

var score:int = 0
@onready var timer := $Timer

#UI Reference
@onready var lbl_score: Label = $CanvasLayer/Control/Score
@onready var lbl_high_score: Label = $CanvasLayer/Control/HighScore
@onready var lbl_time: Label = $CanvasLayer/Control/TimeCount
@onready var game_over_panel: Panel = $"CanvasLayer/Control/Game Over Panel"
@onready var lbl_score_final: Label = $"CanvasLayer/Control/Game Over Panel/Score Final"
@onready var lbl_high_score_final: Label = $"CanvasLayer/Control/Game Over Panel/HighScore Final"
@onready var btn_restart: Button = $"CanvasLayer/Control/Game Over Panel/Restart"
@onready var btn_main_menu: Button = $"CanvasLayer/Control/Game Over Panel/Main Menu"

func _process(delta: float) -> void:
	var t := int(ceil(timer.time_left))
	lbl_time.text = "%d" % t

func _ready() -> void:
	randomize()
	timer.wait_time = 60
	timer.timeout.connect(_on_time_out)
	
	btn_restart.pressed.connect(_on_retry)
	btn_main_menu.pressed.connect(_on_main_menu)
	game_over_panel.visible = false
	_ui_reset()

	var active_colors: Array[int] = []
	var any_random := false

	for rec in $Recipients.get_children():
		rec.package_delivered.connect(_on_package_delivered)
		if rec.fixed_color != -1:
			if not active_colors.has(rec.fixed_color):
				active_colors.append(rec.fixed_color)
		else:
			any_random = true

	if any_random:
		var pool := ColorSets.get_all()
		for rec in $Recipients.get_children():
			if rec.fixed_color == -1:
				rec.randomize_desired(pool)
		for c in pool:
			if not active_colors.has(c):
				active_colors.append(c)

	if active_colors.is_empty():
		active_colors = ColorSets.get_all()

	$Truck.set_colors(active_colors)
	print("[Game] Start 60s. Warna aktif:", _names(active_colors))

func _on_time_out() -> void:
	emit_signal("time_up")
	print("[Game] TIME UP → GAME OVER. Final score:", score)
	_show_gameover()

func _on_package_delivered(correct: bool, delivered: int) -> void:
	if correct:
		score += 1
		lbl_score.text = "Score : " + str(score)
		if score > PlayerData.highscore:
			PlayerData.highscore = score
			lbl_high_score.text = "HighScore : " + str(score)
	else:
		print("[Miss] Wrong color. Total=%d" % score)

func _names(arr: Array[int]) -> String:
	var s := []
	for a in arr: s.append(ColorSets.color_name(a))
	return ", ".join(s)

func _show_gameover() -> void:
	get_tree().paused = true
	lbl_score_final.text = "Score : " + str(score)
	var broke := PlayerData.try_update_highscore(score)
	lbl_high_score_final.text = "HighScore : " + str(score)
	game_over_panel.visible = true
	print("[Game] TIME UP → GAME OVER. Final score:", score, " Highscore:", PlayerData.highscore)

func _on_retry() -> void:
	get_tree().paused = false
	print("Restart")
	get_tree().reload_current_scene()

func _on_main_menu() -> void:
	get_tree().paused = false
	print("Main Menu")
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func _ui_reset() -> void:
	get_tree().paused = false
	score = 0
	lbl_score.text = "Score : %d" % score
	lbl_high_score.text = "HighScore : " + str(PlayerData.highscore)
	lbl_time.text  = str(int(timer.wait_time))
	game_over_panel.visible = false
