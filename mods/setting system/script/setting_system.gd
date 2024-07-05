extends Node

var options := {
	"BGM_volume":1
}

func init_setting():
	for option in options.keys():
		call(option,options[option])

func change_setting():
	pass

func pppp():
	print(1)
