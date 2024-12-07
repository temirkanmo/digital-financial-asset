# Digital financial asset for Alfa-Bank
#
# Author: Temirkan Uvizhev <temirkanuvi@gmail.com>

from blockchain import Blockchain, Block
from time import time


def main():
    # Blockchain is initialized
    bc = Blockchain()

    # Alice transferred 100 tokens to Bob
    bc.addBlock(Block(str(int(time())), ({"from": "Alice", "to": "Bob", "amount": 100})))
    
    # Bob transferred 100 tokens back to Alice
    bc.addBlock(Block(str(int(time())), ({"from": "Bob", "to": "Alice", "amount": 100})))

    # Print blockahin
    print(bc)


if __name__ == "__main__":
    main()
