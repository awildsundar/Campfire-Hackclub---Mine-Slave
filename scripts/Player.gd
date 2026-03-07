extends CharacterBody3D
class_name Player

@onready var raycast: RayCast3D = $CameraController/Camera3D/RayCast3D
@onready var animation: Sprite2D = $Sprite2D

var speed : float = 5.0
var strength : float = 50.0

var ore: int = 0
var money: float = 0.0

var direction: Vector3

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		get_tree().quit()
	elif event.is_action_pressed("interact"):
		interact()

	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

func interact() -> void:
	if raycast.is_colliding():
		var body: Object = raycast.get_collider()
		if body is BaseInteractable:
			body.interact(self)
