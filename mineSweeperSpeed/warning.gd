extends Area2D

var total = 0
var destroyed = false
var used = false
var distFromHome = 0
var distFromPlayer = 0
var totalScore = 0
var steps = 0
var top = false
var bot = false
var right = false
var left = false
var isHole = false
var usedBySnek = false
var mouseIn = false
var addMine = false

func unhide():

	if $hidden.visible == true:
		showText()
		$hidden.hide()
		$hidden.visible = false
		
func addMine():
	if addMine == false:
		addMine = true
		$hidden/mine.show()
	else:
		addMine = false
		$hidden/mine.hide()
		
func countNeighbors():
	for i in get_parent().get_children():
		if "danger" in i.name:
			if i.position == position + Vector2(-32,0):
				total += 1
			if i.position == position + Vector2(-32,32):
				total += 1
			if i.position == position + Vector2(0,32):
				total += 1
			if i.position == position + Vector2(32,32):
				total += 1
			if i.position == position + Vector2(32,0):
				total += 1
			if i.position == position + Vector2(32,-32):
				total += 1
			if i.position == position + Vector2(0,-32):
				total += 1
			if i.position == position + Vector2(-32,-32):
				total += 1
#	
	
#		$Particles2D.emitting = true

func showText():

	$Label.show()
	$Label.text = str(total)

#func becomeHole():
#	isHole = true
#	$cystalSprites.hide()
#	$hole.show()


func _on_warning_mouse_entered():
	mouseIn = true
	$hidden/empty.hide()
	$hidden/emptyHover.show()


func _on_warning_mouse_exited():
	mouseIn = false
	$hidden/empty.show()
	$hidden/emptyHover.hide()
	


