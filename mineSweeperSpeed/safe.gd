extends Area2D
var used = false
var distFromHome = 0
var distFromPlayer = 0
var totalScore = 0
var steps = 0
var isHole = false
var usedBySnek = false
var mouseIn = false
var addMine = false

func addMine():
	if addMine == false:
		addMine = true
		$hidden/mine.show()
	else:
		addMine = false
		$hidden/mine.hide()
	
	

func unhide():
#	if $hidden.visible == true:
#		$hidden.hide()
#		if dir == 'top':
#			$hitOnce/hitTop.show()
#		elif dir == 'bot':
#			$hitOnce/hitBot.show()
#		elif dir == 'right':
#			$hitOnce/hitRight.show()
#		elif dir == 'left':
#			$hitOnce/hitLeft.show()
	if $hidden.visible == true:
		get_parent().get_parent().clearUnknown(position)
		$hidden.hide()
		$hidden.visible = false
		



func _on_safe_mouse_entered():
	mouseIn = true
	$hidden/empty.hide()
	$hidden/emptyHover.show()


func _on_safe_mouse_exited():
	mouseIn = false
	$hidden/empty.show()
	$hidden/emptyHover.hide()
