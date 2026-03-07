extends Control
class_name ShopUI

@export var money_display: Label


enum ActionType {ADD, SUBTRACT, SET}
var player: Player = null
var money: float = 0.0
var rate: float = 50.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.y = 1080
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2.ZERO, 0.25).set_trans(
		Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	money = player.money
	money_display.text = "   $" + str(money)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func change_money(amount: float, action: ActionType) -> void:
	match action:
		ActionType.ADD:
			money += amount
		ActionType.SUBTRACT:
			money -= amount
		ActionType.SET:
			money = amount
	money_display.text = "   $" + str(money)


func _on_exit_button_pressed() -> void:
	player.money = money
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(0.0, 1080.0), 0.25).set_trans(
		Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	await tween.finished
	queue_free()


func _on_convert_pressed() -> void:
	var converted: float = player.ore * rate
	change_money(converted, ShopUI.ActionType.ADD)
	player.ore = 0
