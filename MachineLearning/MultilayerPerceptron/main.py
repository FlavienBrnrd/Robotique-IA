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
guess = brain.predict([0, 1])

for e in range(100):
    index = randint(0,3)
    brain.train(trainingI[index], trainingO[index])
    #print("Training finish")


