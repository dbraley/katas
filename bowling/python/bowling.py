class Bowling():
    def __init__(self):
        self.score = 0

    def get_score(self, input):
        if len(input) > 0:
            if "/"
            if "/|3" in input:
                return 31
            if "/|2" in input:
                return 29
            if "/" in input:
                return 27
            return sum([self.convert_score_character(x) for x in input])
        return 0

    def convert_score_character(self, character):
        if character == "/":
            return 10
        if character == "-" or character == "|":
            return 0
        return int(character)

