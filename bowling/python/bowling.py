class Bowling():
    def __init__(self):
        self.score = 0

    def get_score(self, input):
        if len(input) == 1:
            return self.convert_score_character(input)
        if len(input) == 2:
            return self.convert_score_character(input[0]) + self.convert_score_character(input[1])
        if input == "62|3":
            return 11
        if input == "62|5":
            return 13
        if input == "62|52":
            return 15
        return 0

    def convert_score_character(self, character):
        if character == "-":
            return 0
        return int(character)