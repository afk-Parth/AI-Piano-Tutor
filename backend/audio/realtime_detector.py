import queue
import threading
import numpy as np

import sounddevice as sd

from backend.audio.predict_live import detect_note_from_audio


class RealtimeDetector:

    def __init__(
        self,
        samplerate=44100,
        blocksize=8192,
        channels=1
    ):

        self.samplerate = samplerate
        self.blocksize = blocksize
        self.channels = channels

        self.audio_queue = queue.Queue()

        self.running = False

        self.stream = None
        self.worker = None

        self.latest_event = None

        self.last_prediction = None
        self.stable_count = 0

        self.active_note = None

        self.required_stability = 2
        self.required_silence = 2

        self.silence_count = 0

    def audio_callback(self, indata, frames, time, status):

        if status:
            print(status)

        audio = indata[:, 0].copy()

        self.audio_queue.put(audio)
    def start(self):

        self.running = True

        self.worker = threading.Thread(
            target=self.processing_loop,
            daemon=True
        )

        self.worker.start()

        self.stream = sd.InputStream(
            samplerate=self.samplerate,
            blocksize=self.blocksize,
            channels=self.channels,
            callback=self.audio_callback
        )

        self.stream.start()

        print("🎹 Realtime detector started")

    def stop(self):

        self.running = False

        if self.stream:
            self.stream.stop()
            self.stream.close()

        print("🛑 Realtime detector stopped")

    def processing_loop(self):

        while self.running:

            audio = self.audio_queue.get()

            rms = np.sqrt(np.mean(audio ** 2))

        # Ignore silence/background noise
            if rms < 0.001:
                self.handle_silence()
                continue

            note = detect_note_from_audio(
            audio,
            self.samplerate
            )

            if note is None:
                self.handle_silence()
            else:
                self.handle_prediction(note)
    def handle_prediction(self, note):

        self.silence_count = 0

        if note == self.last_prediction:
            self.stable_count += 1
        else:
            self.last_prediction = note
            self.stable_count = 1

        if self.stable_count < self.required_stability:
            return

        if note != self.active_note:

            self.active_note = note

            self.latest_event = note

            print(note, flush=True)

    def handle_silence(self):

        self.silence_count += 1

        if self.silence_count >= self.required_silence:

            self.active_note = None

            self.last_prediction = None

            self.stable_count = 0

    def get_note(self):

        note = self.latest_event

        self.latest_event = None

        return note