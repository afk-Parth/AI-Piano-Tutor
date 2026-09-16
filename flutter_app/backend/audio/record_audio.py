import sounddevice as sd
import soundfile as sf

duration = 3  # seconds
sample_rate = 44100

print("Recording will start...")
print("Play a piano note!")

audio = sd.rec(
    int(duration * sample_rate),
    samplerate=sample_rate,
    channels=1
)

sd.wait()

sf.write("D.wav", audio, sample_rate)

print("Recording saved as recording.wav")