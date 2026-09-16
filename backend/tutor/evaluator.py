class Evaluator:

    def __init__(self, notes):
        self.notes = notes
        self.index = 0
        self.score = 0

    def current_note(self):
        return self.notes[self.index]

    def evaluate(self, detected):

        expected = self.current_note()

        if detected == expected:

            self.score += 1
            self.index += 1

            return True

        return False

    def finished(self):

        return self.index >= len(self.notes)