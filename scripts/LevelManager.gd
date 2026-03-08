extends Node3D
class_name LevelManager

@export var day_number: int = 1
@export_enum("STRENGTH", "SPEED") var debuff: String = "STRENGTH"
@export_range(0.0, 1.0) var debuff_amount: float
@export var debuff_text: Label
@export var debuff_display: Control
@export var debuff_text_time: float = 1.0
@export var quota: float
@export var rate: float = 1.0
@export var next_day: PackedScene
@export var player: Player
@export var cave_gen: CaveGenerator

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if cave_gen != null:
		cave_gen.generate_cave()
	
	if debuff_amount != 0.0:
		match debuff:
			"STRENGTH":
				player.strength = player.strength * debuff_amount
				debuff_text.text = "You feel weaker..."
			"SPEED":
				player.speed = player.speed * debuff_amount
				debuff_text.text = "You feel slower..."
		
		await get_tree().create_timer(debuff_text_time/2).timeout
		debuff_display.show()
		debuff_display.modulate = Color.TRANSPARENT
		var tween = get_tree().create_tween()
		tween.tween_property(debuff_display, "modulate", Color.WHITE, 0.25)

		await get_tree().create_timer(debuff_text_time).timeout
		var tween2 = get_tree().create_tween()
		tween2.tween_property(debuff_display, "modulate", Color.TRANSPARENT, 0.25)
		await tween2.finished
		debuff_display.hide()

func quota_reached(money: float) -> bool:
	if money >= quota:
		print("Quota Reached!")
		return true
	else:
		return false
