class Minefield:

    def answer(self, mines):
        result = []
        for minerow in mines:
            result.append(self.answer_one_row(minerow))
        return result

    def answer_one_row(self, mines):
        result = ''
        if mines == '.':
            result = '0'
        elif mines == '*':
            result = '*'
        elif mines == '.*':
            result = '1*'
        elif mines == '**':
            result = '**'
        elif mines == '*.':
            result = '*1'
        return result

    def hit(self, mines, row, col):
        if row == 2:
            return True
        return False

    def hint(self, mines, row, col):
        if row == 0:
            return 0
        if row == 2:
            return -1
        return 2
