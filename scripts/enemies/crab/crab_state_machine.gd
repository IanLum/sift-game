extends StateMachine

@onready var aggro_radius: Area2D = $Track/AggroRadius
@onready var tracking_radius: Area2D = $Track/TrackingRadius
@onready var attack_radius: Area2D = $Attack/AttackRadius
@onready var attack_timer: Timer = $Attack/AttackTimer
@onready var health_component: HealthComponent = get_node("../HealthComponent")

var facing_direction: Vector2 = Vector2(0, 1)
var is_dead = false

func _ready():
	super._ready()
	attack_timer.connect("timeout", _on_attack_finished)
	health_component.connect("died", _on_death)

func _physics_process(delta: float) -> void:
	if is_dead:
		transition_to("Dead")
	elif state.name == "KnockedUp":
		transition_to("KnockedUp")
	elif (
		not attack_radius.get_overlapping_bodies().is_empty() or 
		not attack_timer.is_stopped()
	):
		transition_to("Attack")
	elif (
		not aggro_radius.get_overlapping_bodies().is_empty() or (
			state.name in ["Track", "Attack"] and
			not tracking_radius.get_overlapping_bodies().is_empty()
		)
	):
		transition_to("Track")
	else:
		transition_to("Idle")

	state.handle_physics(delta)

func _on_attack_finished():
	transition_to("Idle")

func _on_death():
	is_dead = true

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "knocked_up":
		transition_to("Idle")


func _on_hurtbox_component_effect_applied(effect):
	if effect == "knocked_up":
		transition_to("KnockedUp")
