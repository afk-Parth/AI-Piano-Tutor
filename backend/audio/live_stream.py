import sounddevice as sd
import librosa
import numpy as np

NOTE_NAMES = [
    'C', 'C#', 'D', 'D#', 'E', 'F',
    'F#', 'G', 'G#', 'A', 'A#', 'B'
]


def frequency_to_note(freq):
    if freq <= 0:
        return None

    midi = round(69 + 12 * np.log2(freq / 440.0))

    note = NOTE_NAMES[midi % 12]
    octave = (midi // 12) - 1

    return f"{note}{octave}"


def analyze_chunk(audio, sr):
    """
    Returns detected note or None.
    """

    audio = audio.flatten()

    # RMS energy for silence detection
    energy = np.sqrt(np.mean(audio ** 2))

    # Ignore silence/background noise
    if energy < 0.015:
        return None

    pitches = librosa.yin(
        audio,
        fmin=50,
        fmax=2000,
        sr=sr
    )

    pitches = pitches[~np.isnan(pitches)]

    if len(pitches) == 0:
        return None

    frequency = np.median(pitches)

    return frequency_to_note(frequency)


print("Listening continuously...")
print("Press Ctrl+C to stop.\n")

sample_rate = 44100
duration = 0.3   # Faster response

# State machine variables
waiting_for_release = False

try:

    while True:

        audio = sd.rec(
            int(duration * sample_rate),
            samplerate=sample_rate,
            channels=1,
            dtype='float32'
        )

        sd.wait()

        note = analyze_chunk(audio, sample_rate)

        # No note detected (silence)
        if note is None:

            # Reset state so the next note can be detected
            waiting_for_release = False

            continue

        # New key press detected
        if not waiting_for_release:

            print("Detected:", note)

            waiting_for_release = True


except KeyboardInterrupt:

    print("\nStopped listening.")