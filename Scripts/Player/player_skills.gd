extends Node

var skills :Dictionary[String, Dictionary] = {} 

func _ready():
	load_skills()
	print(skills)
	for skill in skills:
		print(skill)

func load_skills():
	var f = FileAccess.open("res://Databases/skills.csv", FileAccess.READ)
	if f == null:
		push_error("skills.csv not found!")
		return

	# skip header
	f.get_csv_line(";")
	print("skills.csv found!")
	while not f.eof_reached():
		var row = f.get_csv_line(";")
		if row.size() < 3:  # pastikan ada 3 kolom
			continue

		var name = row[0].strip_edges()
		var value = row[1].strip_edges().to_int()
		var duration = row[2].strip_edges().to_int()

		skills[name] = {
			"value": value,
			"duration": duration
		}
	f.close()
