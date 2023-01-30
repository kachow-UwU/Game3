extends Node

const FILE_NAME := "user://savegame.save"
const default_level := 1
const default_retry := 0


var level := 1
var retry := 0

var loaded = {}

func removeSave() -> void:
	var dir = Directory.new()
	dir.remove("user://savegame.save")
	
func save_dictionnary(_is_new = false) -> Dictionary:
	var save_dict = {
		"level": level
	}
	return save_dict
	
func save_game(is_new: bool = false) -> void:
	var file = File.new()
	file.open(FILE_NAME, File.WRITE)
	var dic = save_dictionnary(is_new)
	file.store_line(to_json(dic))
	file.close()

func add_level() -> void:
	level += 1
	save_game()
	
func add_restart() -> void:
	retry += 1
	save_game()

func save_exist() -> bool:
	var file = File.new()
	return file.file_exists(FILE_NAME)
	

	
func load_game():
	var file = File.new()
	if file.file_exists(FILE_NAME):
		file.open(FILE_NAME, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			loaded = data
			level = loaded["level"]
		else:
			printerr("corrupted data")
	else:
		printerr("no saved data")

func get_level() -> int:
	load_game()
	return loaded["level"]

func get_retry() -> int:
	load_game()
	return loaded["retry"]
