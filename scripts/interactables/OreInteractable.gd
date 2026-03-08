extends BaseInteractable
class_name OreInteractable

var health: float = 100.0
@onready var health_bar: ProgressBar3D = $ProgressBar3D

func _ready() -> void:
	health_bar.max_value = health
	health_bar.value = health

# Called when the node enters the scene tree for the first time.
func interact(player: Player) -> void:
	health -= player.strength
	health_bar.value = health
	if health <= 0.0:
		player.ore += 1
		player.ore_count_display.text = "Ores: " + str(player.ore)
		queue_free()
