extends Area2D

var target = null
@export var speed: float = 300
@export var max_speed: float = 300
var player: CharacterBody2D
var spinning : bool 
var returning: bool = false
var direction: Vector2 = Vector2.ZERO
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox = %Hitbox

func _ready() -> void:
	animated_sprite.play("spin")
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	if spinning == true:
		direction = (player.global_position - global_position).normalized()

func _on_area_entered(area: Area2D) -> void:
	
	if spinning == false:
		%ReturnTimer.start()
		spinning = true;
	%TickTimer.start()
	speed = 0

func return_boomerang():
	speed = max_speed
	returning = true;

func change_target(new_target):
	target = new_target
	if player == null:
		player = get_tree().get_first_node_in_group("player")
	direction = (target.global_position - player.global_position).normalized()


func _on_return_timer_timeout() -> void:
	return_boomerang()


func _on_body_entered(body: Node2D) -> void:
	if returning == true:
		spinning = false
		returning = false
		queue_free()
		body.has_sickle = true
		body.state_machine.grapple_attacking = false


func _on_tick_timer_timeout() -> void:
	if hitbox.disabled == true:
		hitbox.set_deferred("disabled", false)
	else:
		hitbox.set_deferred("disabled", true)
