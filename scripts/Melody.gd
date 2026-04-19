class_name Melody extends Resource


@export var melody: Array[AudioSampler.Note]


func get_len() -> int:
	var note_len = 3
	var total_len = 0
	
	for note in melody:
		if note in AudioSampler.PAUSE_TIME.keys():
			total_len += 10 * AudioSampler.PAUSE_TIME[note]
		else:
			total_len += note_len 
	return total_len
