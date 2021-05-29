extends Node2D

export (PackedScene) var Mob
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$music.stop()
	$Deathsound.play()
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get ready!")
	$music.play()
	
func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_MobTimer_timeout():
	# choosing a random location on Path2d
	$MobPath/MobSpawnLocation.set_offset(randi())
	# Create a mob instance and add it to the scene
	var mob = Mob.instance()
	add_child(mob)
	#Set the mob's directon perpendicular to the path direction
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	#set the mob's position to a random location
	mob.position = $MobPath/MobSpawnLocation.position
	#add some andomness to the direction
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# Choose the velocity
	mob.set_linear_velocity(Vector2(rand_range(mob.min_speed, mob.max_speed), 0) .rotated(direction))
