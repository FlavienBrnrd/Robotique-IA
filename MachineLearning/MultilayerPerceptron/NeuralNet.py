"""Class which describe a neural network"""
import numpy as np


# Creation of the activation function
def sigmoid(x):
    return (1/(1+np.exp(-x)))

# derivative of the sigmoid function
# x needs to be passed throught sigmoid first


def derSigmoid(x):
    return x * (1 - x)


class NeuralNet:

    def __init__(self, sizeInput, sizeHidden, sizeOutput, learningRate):
        # Learning rate
        self.lr = learningRate

        # set the dimensions of the neural network
        self.inputsNodes = sizeInput
        self.outputsNodes = sizeOutput
        self.hiddenNodes = sizeHidden

        # Create random weight matrix between Input => Hidden and Hidden => Output
        self.weightsIH = np.random.rand(self.inputsNodes, self.hiddenNodes)
        self.weightsHO = np.random.rand(self.hiddenNodes, self.outputsNodes)

        # Create bias vector for the Hidden and the Output
        self.biasH = np.ones(self.hiddenNodes)
        self.biasO = np.ones(self.outputsNodes)

        self.weightsBiasH = np.random.rand(self.hiddenNodes)
        self.weightsBiasO = np.random.rand(self.outputsNodes)

    def predict(self, inputs):
        # Convert entry into np.array
        inputs = np.array(inputs)

        # This is the feed forward mechanism
        # compute weighted sum for INPUT to HIDDEN and add the hidden bias

        self.hiddenInputs = np.dot(inputs, self.weightsIH)

        self.hiddenInputs += self.biasH

        # use the activation function
        self.hiddenOutputs = sigmoid(self.hiddenInputs)

        # compute the weighted sum for HIDDEN to OUTPUT and add the output bias
        outputs = np.dot(self.hiddenOutputs, self.weightsHO)
        outputs += self.biasO

        # calculate the guess with the activation function
        guess = sigmoid(outputs)

        return guess

    def train(self, inputs, targets):
        # Convert entry into np.array
        inputs = np.array(inputs)
        targets = np.array(targets)

        # This is the backpropagation mechanism
        # Gradient descent algorithm to tweaks weights values
        # First step : calulate the feed forward (prediction)
        outputs = self.predict(inputs)

        # Compute the error for the output
        error = targets - outputs

        # Compute the error for the hidden
        weightsHO_T = np.transpose(self.weightsHO)

        errorH = np.dot(error, weightsHO_T)

        # Update the weights
        hiddenOutputs_T = np.transpose(self.hiddenOutputs)
        inputs_T = np.transpose(inputs)

        # calculate gradient and the delta change for the weights
        gradientO = np.dot(error, derSigmoid(outputs))
        deltaWHO = np.dot(gradientO, hiddenOutputs_T)
        print(deltaWHO)
        # self.weightsHO += self.lr * deltaWHO

        gradientH = errorH * derSigmoid(self.hiddenOutputs)
        deltaWIH = np.dot(gradientH, inputs_T)
        # self.weightsIH += self.lr * deltaWIH
