class_name AudioSampler extends AudioStreamPlayer2D

enum Note {
	P01, P02, P03, P04, P05, P06, P07, P08, P09,
	P1, P2, P3, P4, P5, P6, P7, P8, P9,
	C2, Cs2, D2, Ds2, E2, F2, Fs2, G2, Gs2, A2, As2, B2,

	C3, Cs3, D3, Ds3, E3, F3, Fs3, G3, Gs3, A3, As3, B3,

	# Октава 4
	C4, Cs4, D4, Ds4, E4, F4, Fs4, G4, Gs4, A4, As4, B4,
	# Октава 5
	C5, Cs5, D5, Ds5, E5, F5, Fs5, G5, Gs5, A5, As5, B5,
	# Октава 6
	C6, Cs6, D6, Ds6, E6, F6, Fs6, G6, Gs6, A6, As6, B6
}

const PAUSE_TIME = {
	# Паузы с ведущим нулём (десятые доли)
	Note.P01: 0.1,
	Note.P02: 0.2,
	Note.P03: 0.3,
	Note.P04: 0.4,
	Note.P05: 0.5,
	Note.P06: 0.6,
	Note.P07: 0.7,
	Note.P08: 0.8,
	Note.P09: 0.9,
	
	# Паузы без ведущего нуля (целые значения)
	Note.P1: 1.0,
	Note.P2: 2.0,
	Note.P3: 3.0,
	Note.P4: 4.0,
	Note.P5: 5.0,
	Note.P6: 6.0,
	Note.P7: 7.0,
	Note.P8: 8.0,
	Note.P9: 9.0
}
# Словарь частот для каждой ноты
const NOTE_FREQUENCIES = {
	# Октава 2
	Note.C2:   65.41, Note.Cs2:  69.30, Note.D2:   73.42, Note.Ds2:  77.78,
	Note.E2:   82.41, Note.F2:   87.31, Note.Fs2:  92.50, Note.G2:   98.00,
	Note.Gs2: 103.83, Note.A2:  110.00, Note.As2: 116.54, Note.B2:  123.47,
	# Октава 3
	Note.C3:  130.81, Note.Cs3: 138.59, Note.D3:  146.83, Note.Ds3: 155.56,
	Note.E3:  164.81, Note.F3:  174.61, Note.Fs3: 185.00, Note.G3:  196.00,
	Note.Gs3: 207.65, Note.A3:  220.00, Note.As3: 233.08, Note.B3:  246.94,
	# Октава 4
	Note.C4:  261.63, Note.Cs4: 277.18, Note.D4:  293.66, Note.Ds4: 311.13,
	Note.E4:  329.63, Note.F4:  349.23, Note.Fs4: 369.99, Note.G4:  392.00,
	Note.Gs4: 415.30, Note.A4:  440.00, Note.As4: 466.16, Note.B4:  493.88,
	# Октава 5
	Note.C5:  523.25, Note.Cs5: 554.37, Note.D5:  587.33, Note.Ds5: 622.25,
	Note.E5:  659.25, Note.F5:  698.46, Note.Fs5: 739.99, Note.G5:  783.99,
	Note.Gs5: 830.61, Note.A5:  880.00, Note.As5: 932.33, Note.B5:  987.77,
	# Октава 6
	Note.C6: 1046.50, Note.Cs6: 1108.73, Note.D6: 1174.66, Note.Ds6: 1244.51,
	Note.E6: 1318.51, Note.F6: 1396.91, Note.Fs6: 1479.98, Note.G6: 1567.98,
	Note.Gs6: 1661.22, Note.A6: 1760.00, Note.As6: 1864.66, Note.B6: 1975.53
}


# Ссылка на эффект PitchShift
var pitch_effect: AudioEffectPitchShift
# Частота, с которой записан ваш оригинальный звук (настраивается вручную на слух)
@export var original_reference_hz: float = 261.63  # По умолчанию C4

func _ready():
	# 1. Создаём и настраиваем шину с эффектом
	var bus_name = "PitchShiftBus"
	var bus_index = AudioServer.get_bus_index(bus_name)
	
	# Если шины нет, создаём её
	if bus_index == -1:
		AudioServer.add_bus()
		bus_index = AudioServer.get_bus_count() - 1
		AudioServer.set_bus_name(bus_index, bus_name)
	
	# 2. Создаём и добавляем эффект PitchShift
	pitch_effect = AudioEffectPitchShift.new()
	pitch_effect.fft_size = AudioEffectPitchShift.FFT_SIZE_2048  # Баланс качество/задержка
	pitch_effect.oversampling = 4
	AudioServer.add_bus_effect(bus_index, pitch_effect, 0)
	
	# 3. Направляем этот плеер на нашу шину
	self.bus = bus_name
	
	

		
# Публичный метод: Играть текущий stream как указанную ноту
func play_note(target_note: Note, from_position: float = 0.0):
	# Если звук не загружен, выходим
	if not stream:
		push_error("AudioStream не назначен в MusicSampler")
		return
	
	# Вычисляем нужный pitch_scale
	var target_hz = NOTE_FREQUENCIES[target_note]
	pitch_effect.pitch_scale = target_hz / original_reference_hz
	
	# Воспроизводим
	play(from_position)

# Публичный метод: Играть ноту с явно указанным коэффициентом (обход частот)
func play_with_pitch_scale(pitch_value: float, from_position: float = 0.0):
	pitch_effect.pitch_scale = pitch_value
	play(from_position)

# Вспомогательный метод: Быстрая смена референсной частоты на лету
func set_reference_note(ref_note: Note):
	original_reference_hz = NOTE_FREQUENCIES[ref_note]
