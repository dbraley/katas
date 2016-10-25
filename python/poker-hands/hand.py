class Hand:

    def __init__(self, cards):
        self.suits = ['H','D','C','S']
        self.aces = ['AH','AD','AC','AS']
        if len(cards) != 5:
            raise RuntimeError('Hand needs 5 cards')
        for card in cards:
            if len(card) != 2:
                raise RuntimeError('Invalid card')
            if card[1] not in self.suits:
                raise RuntimeError('Invalid suit')
        self.cards = cards

    def beats(self, other_hand):
        if any([card in self.aces for card in self.cards]):
            return True
        if self.cards[0][0] == 'A':
            return True
        else:
            return False
