extends Node

@export var initial_state : State

var current_state : State
var states: Dictionary = {}
var player : CharacterBody2D

@export var animation_tree : AnimationTree;
var held_dir;
@export var attacking = false;
var attack_dir;

func _ready():
	animation_tree.active = true
	player = get_tree().get_first_node_in_group("player")
	for child : State  in get_children():
		states[child.name.to_lower()] = child
		child.Transitioned.connect(on_child_transition)
		
	if initial_state:
		initial_state.Enter()
		current_state = initial_state

func _process(delta):
	if current_state:
		current_state.Update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.Physics_Update(delta)
	
		
	if player.direction:
		held_dir = player.direction
	animation_tree.set("parameters/run/blend_position", held_dir)
	animation_tree.set("parameters/idle/blend_position", held_dir)
	animation_tree.set("parameters/attack/blend_position", attack_dir)
	
func on_child_transition(state, new_state_name):
	if state != current_state:
		return
		
	var new_state = states.get(new_state_name.to_lower())
	
	if !new_state:
		return
	
	if current_state:
		current_state.Exit()
	
	new_state.Enter()
	
	current_state = new_state
	
func attack(dir: String):
	match dir:
		"Up":
			attack_dir = Vector2(0, 1)
		"Down":
			attack_dir = Vector2(0, -1)
		"Left":
			attack_dir = Vector2(-1, 0)
		"Right":
			attack_dir = Vector2(1, 0)
	attacking = true
	


func _on_attack_cd_timeout() -> void:
	attacking = false;
