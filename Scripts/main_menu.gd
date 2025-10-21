extends CanvasLayer

@onready var high_scores: Label = $Control/Panel/HighScores
@onready var play: Button = $Control/Panel/Play
@onready var exit: Button = $Control/Panel/Exit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	high_scores.text = "%d" %PlayerData.highscore
	
	play.pressed.connect(_on_play)
	exit.pressed.connect(_on_exit)

func _on_play() -> void:
	print("Play")
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_exit() -> void:
	print("Exit")
	get_tree().quit()
