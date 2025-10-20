extends Node

# Enum warna untuk logic
enum ColorType { RED, GREEN, BLUE, YELLOW }

# Mapping enum → warna visual
const COLOR_MAP := {
	ColorType.RED: Color(1, 0, 0),
	ColorType.GREEN: Color(0.0, 0.7, 0.2),
	ColorType.BLUE: Color(0.2, 0.4, 1.0),
	ColorType.YELLOW: Color(1.0, 0.9, 0.0),
}

# Nama enum untuk debug
const COLOR_NAME := {
	ColorType.RED: "RED",
	ColorType.GREEN: "GREEN",
	ColorType.BLUE: "BLUE",
	ColorType.YELLOW: "YELLOW",
}

# Ambil list semua warna aktif
func get_all() -> Array[int]:
	return ColorType.values()

func get_color(c: int) -> Color:
	return COLOR_MAP.get(c, Color.WHITE)
	
#
func color_name(c: int) -> String:
	return COLOR_NAME.get(c, "UNKNOWN")
