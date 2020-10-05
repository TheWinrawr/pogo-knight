extends CanvasLayer

signal finished

onready var anim_player: AnimationPlayer = $AnimationPlayer
	
func transition_in() -> void:
	anim_player.play("transition_in")
	yield(anim_player, "animation_finished")
	emit_signal("finished")
	
func transition_out() -> void:
	anim_player.play("transition_out")
	yield(anim_player, "animation_finished")
	emit_signal("finished")
