extends Node

var highscore: int = 0

func reset() -> void:
	highscore = 0

func try_update_highscore(score: int) -> bool:
	if score > highscore:
		highscore = score
		return true
	return false
