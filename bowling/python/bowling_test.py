import unittest
from bowling import Bowling


class BowlingTest(unittest.TestCase):
    def setUp(self):
        self.bowling = Bowling()

    def test_working(self):
        self.assertEqual(0, self.bowling.get_score(""))

    def test_score(self):
        self.assertEqual(5, self.bowling.get_score("5"))

    def test_score_six(self):
        self.assertEqual(6, self.bowling.get_score("6"))

    def test_score_seven(self):
        self.assertEqual(7, self.bowling.get_score("7"))

    def test_score_can_add_frame(self):
        self.assertEqual(7, self.bowling.get_score("52"))

    def test_score_one_eight(self):
        self.assertEqual(9, self.bowling.get_score("18"))

    def test_score_dash(self):
        self.assertEqual(0, self.bowling.get_score("-"))

    def test_score_5dash(self):
        self.assertEqual(5, self.bowling.get_score("5-"))

    def test_score_6dash(self):
        self.assertEqual(6, self.bowling.get_score("6-"))

    def test_score_2_frames(self):
        self.assertEqual(11, self.bowling.get_score("62|3"))

    def test_score_2_frames_again(self):
        self.assertEqual(13, self.bowling.get_score("62|5"))

    def test_score_2_complete(self):
        self.assertEqual(15, self.bowling.get_score("62|52"))

    def test_score_2_complete_again(self):
        self.assertEqual(16, self.bowling.get_score("52|63"))

    def test_score_9_frames_complete(self):
        self.assertEqual(18, self.bowling.get_score("11|11|11|11|11|11|11|11|11"))