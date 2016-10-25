import hand
import unittest

class TestHand(unittest.TestCase):

    def test_constructor_raises_exception_with_only_one_card(self):
        self.assertRaises(RuntimeError, hand.Hand, ['2H'])
    
    def test_constructor_with_five_cards(self):
        list_of_cards = ['2C','3D','4H','KS', 'AH']
        actual = hand.Hand(list_of_cards)
        self.assertListEqual(list_of_cards, actual.cards)

    def test_cards_are_valid_suits(self):
        self.assertRaises(RuntimeError, hand.Hand, ['2J','3P','4X','5Z','6Y'])

    def test_cards_need_a_suit_and_a_value(self):
        self.assertRaises(RuntimeError, hand.Hand, ['2','S','K','5','8'])

    def test_cards_need_only_a_suit_and_value(self):
        self.assertRaises(RuntimeError, hand.Hand, ['2H4','2HH','2C','4S','2C'])

    def test_the_winner_wins(self):
        hand1 = hand.Hand(['AH','AH','AC','AS','AC'])
        hand2 = hand.Hand(['2H','2H','2C','4S','2C'])
        self.assertTrue(hand1.beats(hand2))

    def test_the_loser_losez(self):
        hand1 = hand.Hand(['AH','AH','AC','AS','AC'])
        hand2 = hand.Hand(['2H','2H','2C','4S','2C'])
        self.assertFalse(hand2.beats(hand1))

    def test_ace_high_wins(self):
        hand1 = hand.Hand(['2H', '3H', '4H', '5H', 'AC'])
        hand2 = hand.Hand(['2H','2H','2C','4S','2C'])
        self.assertTrue(hand1.beats(hand2))


if __name__ == '__main__':
    unittest.main()