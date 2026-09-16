import json
from pathlib import Path


def load_calibration():
    """
    Load calibration profile from JSON.
    """

    path = Path("backend/calibration/calibration.json")

    if not path.exists():
        return None

    with open(path, "r") as f:
        return json.load(f)


def closest_calibrated_note(frequency, calibration_data):
    """
    Find the closest calibrated note.
    """

    if frequency is None:
        return None

    closest_note = None
    smallest_difference = float("inf")

    for note, calibrated_freq in calibration_data.items():

        difference = abs(frequency - calibrated_freq)

        if difference < smallest_difference:

            smallest_difference = difference
            closest_note = note

    return closest_note