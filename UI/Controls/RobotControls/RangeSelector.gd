extends HBoxContainer

func setName(newName):
	$Name.text = newName

func getName():
	return $Name.text

var rngMin = -1.0
var rngMax = 1.0

func setRange(rangeMin, rangeMax):
	rngMin = rangeMin
	rngMax = rangeMax
	$ToRange.text = " to: " + str(rangeMin) + " up to " + str(rangeMax)

func getInRange(val) -> float:
	var rmin = int($MinLine.text)
	var rmax = int($MaxLine.text)
	if (rmin == rmax):
		return 0.0
	var ret = range_lerp(val, rmin, rmax, rngMin, rngMax)
	if (abs(ret) < float($DeadzoneLine.text)):
		return 0.0
	else:
		return ret

func _ready():
	pass
