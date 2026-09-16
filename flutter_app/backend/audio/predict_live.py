import sounddevice as sd
import soundfile as sf
import librosa
import numpy as np

NOTE_NAMES = ['C', 'C#', 'D', 'D#', 'E', 'F',
              'F#', 'G', 'G#', 'A', 'A#', 'B']


def frequency_to_note(freq):
    if freq <= 0:
        return None

    midi = round(69 + 12 * np.log2(freq / 440.0))

    note = NOTE_NAMES[midi % 12]
    octave = (midi // 12) - 1

    return f"{note}{octave}"


def detect_note_from_audio(audio, sr):
    """
    Detect note directly from an audio array.
    Used by the realtime detector.
    """

    if len(audio) == 0:
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

    note = frequency_to_note(frequency)

    return note


def analyze_audio(audio_path):
    """
    Analyze a saved audio file.
    Used for testing/debugging.
    """

    y, sr = librosa.load(audio_path, sr=None)

    note = detect_note_from_audio(y, sr)

    if note is None:
        return None, None

    pitches = librosa.yin(
        y,
        fmin=50,
        fmax=2000,
        sr=sr
    )

    pitches = pitches[~np.isnan(pitches)]

    frequency = np.median(pitches)

    return frequency, note


def detect_note():
    """
    Original blocking detector.
    Keeps existing functionality intact.
    """

    duration = 0.8
    sample_rate = 44100

    print("🎹 Listening...")

    audio = sd.rec(
        int(duration * sample_rate),
        samplerate=sample_rate,
        channels=1,
        dtype='float32'
    )

    sd.wait()

    audio = audio.flatten()

    sf.write("live_recording.wav", audio, sample_rate)

    print("🔍 Checking note...")

    note = detect_note_from_audio(audio, sample_rate)

    return note


if __name__ == "__main__":

    print("\n=== Live Piano Note Detection ===")

    input("\nPress Enter and then play ONE piano key...")

    note = detect_note()

    if note is None:
        print("\nCould not detect a note.")
    else:
        print(f"\nPredicted Note: {note}")