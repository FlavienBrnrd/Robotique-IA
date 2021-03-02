"""Class which describe a neural network"""
from numpy import array, exp, tanh, transpose, random, ones


# Creation of the activation function
def sigmoid(x):
    return (1/(1+exp(-x)))

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
        self.weightsIH = random.rand(self.inputsNodes, self.hiddenNodes)
        self.weightsHO = random.rand(self.hiddenNodes, self.outputsNodes)

        # Create bias vector for the Hidden and the Output
        self.biasH = ones(self.hiddenNodes)
        self.biasO = ones(self.outputsNodes)

        self.weightsBiasH = random.rand(self.hiddenNodes)
        self.weightsBiasO = random.rand(self.outputsNodes)

    def predict(self, inputs):
        # Convert entry into array
        inputs = array(inputs)

        # This is the feed forward mechanism
        # compute weighted sum for INPUT to HIDDEN and add the hidden bias

        # self.hiddenInputs = dot(inputs, self.weightsIH)
        self.hiddenInputs = inputs@self.weightsIH

        self.hiddenInputs += self.biasH

        # use the activation function
        self.hiddenOutputs = sigmoid(self.hiddenInputs)

        # compute the weighted sum for HIDDEN to OUTPUT and add the output bias
        outputs = self.hiddenOutputs@self.weightsHO
        outputs += self.biasO

        # calculate the guess with the activation function
        guess = sigmoid(outputs)

        return guess

    def train(self, inputs, targets):
        # Convert entry into array
        inputs = array(inputs)
        targets = array(targets)

        # This is the backpropagation mechanism
        # Gradient descent algorithm to tweaks weights values
        # First step : calulate the feed forward (prediction)
        outputs = self.predict(inputs)

        # Compute the error for the output
        error = targets - outputs

        # calculation of the gradient
        gradient = derSigmoid(outputs)
        gradient = gradient@error
        gradient = gradient * self.lr
        