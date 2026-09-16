from backend.tutor.song_loader import load_song
from backend.tutor.evaluator import Evaluator
from backend.audio.live_listener import wait_for_note        

song = load_song("backend/tutor/songs/twinkle.json")

notes = song["notes"]

evaluator = Evaluator(notes)


while not evaluator.finished():

    expected = evaluator.current_note()

    print(f"\nPlay: {expected}")

    detected = wait_for_note()

    print("Detected:", detected)

    if evaluator.evaluate(detected):

        print("✓ Correct")

    else:

        print("✗ Try Again")


print("\nSession Complete")

print(f"Score: {evaluator.score}/{len(notes)}")