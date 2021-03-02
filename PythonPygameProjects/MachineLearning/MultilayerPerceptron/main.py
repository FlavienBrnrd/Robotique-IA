from NeuralNet import NeuralNet as nn
import numpy as np
from random import randint

nbInputs = 2
nbHidden = 3
nbOutputs = 1
learningRate = 0.5

trainingI = [[0, 0], [0, 1], [1, 0], [1, 1]]
trainingO = [0, 1, 1, 0]

brain = nn(nbInputs, nbHidden, nbOutputs, learningRate)
guess = brain.predict([1, 1])

print(guess)

brain.train(trainingI[0], trainingO[0])