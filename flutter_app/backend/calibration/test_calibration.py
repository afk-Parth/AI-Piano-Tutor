from backend.calibration.calibration_utils import (
    load_calibration,
    closest_calibrated_note
)


calibration = load_calibration()

print("\nLoaded Calibration:\n")

for note, freq in calibration.items():

    print(f"{note}: {freq:.2f} Hz")


while True:

    user_input = input(
        "\nEnter frequency (or q to quit): "
    )

    if user_input.lower() == "q":
        break

    frequency = float(user_input)

    predicted = closest_calibrated_note(
        frequency,
        calibration
    )

    print("Predicted:", predicted)