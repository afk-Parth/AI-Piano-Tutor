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

    rms = np.sqrt(np.mean(audio ** 2))

    # Ignore silence/background noise
    if rms < 0.01:
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


def wait_for_note():

    sample_rate = 44100
    duration = 0.5

    print("Listening...")

    consecutive_count = 0
    previous_note = None

    while True:

        audio = sd.rec(
            int(duration * sample_rate),
            samplerate=sample_rate,
            channels=1,
            dtype='float32'
        )

        sd.wait()

        audio = audio.flatten()

        note = analyze_chunk(audio, sample_rate)

        if note is None:
            continue

        if note == previous_note:

            consecutive_count += 1

        else:

            previous_note = note
            consecutive_count = 1

        # Require same note twice
        if consecutive_count >= 2:

            return note