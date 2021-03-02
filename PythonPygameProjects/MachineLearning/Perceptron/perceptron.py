import numpy as np
import random
import math

# Algorithm behind the simple perceptron
# 1- for each inputs multiply that input by its weight
# 2- Sum all weigthed inputs
# 3- Compute the output of the perceptron (pass through an activation function)


class Perceptron:

    def __init__(self):
        self.weights = [0, 0]
        self.learningRate = 0.05

        # init the weights with random value [-1 ; 1]
        for i in range(len(self.weights)):
            self.weights[i] = random.randrange(-1, 1)
           
        print(f"Initial weights are : {self.weights}")

    def predict(self, inputs):
        wSum = 0

        for i in range(len(self.weights)):
            wSum += inputs[i] * self.weights[i]
        outputs = np.tanh(wSum)
        return outputs

    def train(self, inputs, target):
        guess = self.predict(inputs)
        
        error = target - guess
        
        # Tune the weights according to the error
        for i in range(len(self.weights)):
            self.weights[i] += error * inputs[i] * self.learningRate

        
        


