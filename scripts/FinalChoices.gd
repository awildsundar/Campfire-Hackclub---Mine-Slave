extends HBoxContainer
class_name FinalChoices

var black_screen: ColorRect

func _on_button_pressed() -> void:
	black_screen.show()
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
