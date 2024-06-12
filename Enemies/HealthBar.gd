extends ProgressBar



var health = 0

func init_health(_health):
	health = _health
	max_value = health
	value = health
	$DamageBar.max_value = health
	$DamageBar.value = health

func _set_health(new_health):
	var prev_health = health
	health = min(max_value, new_health)
	value = health
	
	if health < prev_health:
		$Timer.start()
	else:
		$Damage_bar.value = health


func _on_timer_timeout():
	$DamageBar.value = health
