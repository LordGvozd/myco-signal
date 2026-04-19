extends Control

@onready
var audio_player: AudioSampler = $AudioStreamPlayer2D

@onready
var spectrogramma: Spectrogramma = $Spectrogramma

@export var buttons: Array[SoundButton]

@export
var melody: Melody

var is_playing: bool = false

@export
var buttons_colors: Array[Color]
	
var correct_sequence: Array[int] = []
var input_sequence: Array[int]
var correct_notes: Array[AudioSampler.Note]
var event_on_done: IEvent
var sound_on_done: AudioStreamMP3
var shader_on_done: ShaderMaterial
	
func _ready() -> void:
	show_all()
	
	Bus.subscribe(OpenElectrod, open)
	
	for index in len(buttons):
		buttons[index].button_down.connect(_on_btn_down.bind(index))
		
	self.visible = false

func open(event: OpenElectrod) -> void:
	correct_sequence = []
	input_sequence = []
	correct_notes = []
	melody = event.melody
	is_playing = false
	event_on_done = event.on_done_event
	sound_on_done = event.sound
	shader_on_done = event.shader
	spectrogramma.clear_points()
	show_all()
	
	visible = true

func _on_btn_down(index: int) -> void:
	print(input_sequence)
	if correct_sequence:
		if index == correct_sequence[len(input_sequence)]:
			audio_player.play_note(correct_notes[len(input_sequence)])
			input_sequence.append(index)
			print("CORRECT")
		else:
			for btn in buttons:
				btn.modulate = Color.RED * 2
			audio_player.play_note(AudioSampler.Note.C2)
			input_sequence = []
			await get_tree().create_timer(.5).timeout
			show_all()
			
		if correct_sequence == input_sequence:
			print("WINWIN")
			for i in range(10):
					for btn in buttons:
						if i % 2 == 0:
							btn.modulate = btn.base_color
						else:
							btn.modulate = btn.base_color * 2
					await get_tree().create_timer(.5).timeout
					
			input_sequence = []
			hide_all()

			var event_closed = CloseElectrod.new()
			event_closed.shader = shader_on_done
			event_closed.sound = sound_on_done
			
			Bus.create_event(event_closed)
			Bus.create_event(event_on_done)
			print(event_on_done.number)
			visible = false
			
func play_melody() -> void:
	is_playing = true
	var x = 0
	var kvant = spectrogramma.size.x / len(melody.melody)
	var y = 0

	var index = 0
	for note in melody.melody:
		
		spectrogramma.add_point(Vector2(x, y))
		if note in AudioSampler.PAUSE_TIME.keys():
			await get_tree().create_timer(AudioSampler.PAUSE_TIME[note]).timeout
			y = 0
			x += kvant
			spectrogramma.add_point(Vector2(x, y))

			continue
		
		# Play note
		hide_all()
		y = AudioSampler.NOTE_FREQUENCIES[note] / 15
		x += kvant 
		
		
		spectrogramma.add_point(Vector2(x, y))

		var btn = buttons[correct_sequence[index]]

		btn.modulate = btn.base_color
		index += 1
		audio_player.play_note(note)

	await get_tree().create_timer(.3).timeout
	is_playing = false
	hide_all()
	await get_tree().create_timer(.5).timeout

	show_all()

func hide_all() -> void:
	$Button.disabled = true
	
	for btn in buttons:
		btn.modulate = Color.GRAY
		
	
	
func show_all() -> void:
	$Button.disabled = false
		
	for btn in buttons:
		btn.modulate = btn.base_color

func _plays():
	spectrogramma.clear_points()
	
	# correct_sequence = []
	
	input_sequence = []
	if len(correct_sequence) == 0:
		correct_notes = []
		for i in len(melody.melody):
			if melody.melody[i] in AudioSampler.PAUSE_TIME.keys():
				continue
			if len(correct_sequence) > 0:
				# Выбираем другую кнопку, чтобы они не повторялись
				var r = correct_sequence[-1]
				while r == correct_sequence[-1]:
					r = randi_range(0, len(buttons) - 1)
				
				correct_sequence.append(r)
				correct_notes.append(melody.melody[i])
			else:
				var r = randi_range(0, len(buttons) - 1)
				correct_sequence.append(r)
				correct_notes.append(melody.melody[i])


func _on_button_button_down() -> void:
	hide_all()
	
	_plays()

	play_melody()
	
