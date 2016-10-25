import minefield
import unittest

class TestMinefield(unittest.TestCase):

    def test_single_nonmine_returns_zero(self):
        mines = ['.']
        mine = minefield.Minefield()
        self.assertEqual(['0'], mine.answer(mines))

    def test_single_mine_returns_star(self):
        mines = ['*']
        mine = minefield.Minefield()
        self.assertEqual(['*'], mine.answer(mines))

    def test_space_before_single_mine_hints_one(self):
        mines = ['.*']
        mine = minefield.Minefield()
        self.assertEqual(['1*'], mine.answer(mines))

    def test_space_after_single_mine_hints_one(self):
        mines = ['*.']
        mine = minefield.Minefield()
        self.assertEqual(['*1'], mine.answer(mines))

    def test_all_mines(self):
        mines = ['**']
        mine = minefield.Minefield()
        self.assertEqual(['**'], mine.answer(mines))

    def test_2_row_empty_minefield_returns_all_zeros(self):
        mines = ['.','.']
        mine = minefield.Minefield()
        self.assertEqual(['0','0'], mine.answer(mines))

    def test_no_hit_at_one_one(self):
        mines = ['..','..','**']
        mine = minefield.Minefield()
        self.assertEqual(False, mine.hit(mines, 1, 1))

    def test_hit_at_row_2_col_1(self):
        mines = ['..','..','**']
        mine = minefield.Minefield()
        self.assertEqual(True, mine.hit(mines, 2, 1))

    def test_hint_at_1_1_hints_2(self):
        mines = ['..','..','**']
        mine = minefield.Minefield()
        self.assertEqual(2, mine.hint(mines, 1, 1))

    def test_hint_at_0_0_hints_0(self):
        mines = ['..','..','**']
        mine = minefield.Minefield()
        self.assertEqual(0, mine.hint(mines, 0, 0))

    def test_hint_at_2_2_hints_game_over(self):
        mines = ['..','..','**']
        mine = minefield.Minefield()
        self.assertEqual(-1, mine.hint(mines, 2, 2))
       

if __name__ == '__main__':
    unittest.main()
