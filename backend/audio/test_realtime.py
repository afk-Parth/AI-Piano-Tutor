from backend.audio.realtime_detector import RealtimeDetector

detector = RealtimeDetector()

detector.start()

try:

    while True:

        note = detector.get_note()

        if note:
            print("EVENT:", note)

except KeyboardInterrupt:

    detector.stop()