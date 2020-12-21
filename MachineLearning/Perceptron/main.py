from points import Points
from perceptron import Perceptron
import pygame
from math import floor

# Screen configurations
screenWidth = 600
screenHeight = 600

# Color
green = pygame.Color(50, 150, 50)
red = pygame.Color(150, 50, 50)
blue = pygame.Color(50, 55, 250)

# Create a new perceptron
p = Perceptron()

# Test with this input
testPt = [570, 554]

# Creation of a training dataSet (known values)
dataSetX = []
dataSetY = []
dataSetLabel = []
pts = []
SIZE = 10000
for i in range(0, SIZE):
    pt = Points()
    pts.append(pt)
    dataSetX.append(pt.x)
    dataSetY.append(pt.y)
    dataSetLabel.append(pt.label)

inputs = []

# Training data
trainingData = []
trainingTargets = []
for i in range(floor(SIZE/2)):
    trainingData.append([dataSetX[i], dataSetY[i]])
    trainingTargets.append(dataSetLabel[i])
    # Train model with some data ==> the first half of the dataSet
    p.train(trainingData[i], trainingTargets[i])

print(f"Training DONE ==> new weight : {p.weights}")

print("Predict the label for this point ==> {0} ==> the guessed label is {1}".format(
    testPt, p.predict(testPt)))

if __name__ == "__main__":
    # pygame init
    pygame.init()
    screen = pygame.display.set_mode(
        [screenWidth, screenHeight], pygame.DOUBLEBUF)
    pygame.display.set_caption('Simple Perceptron Classification')
    clock = pygame.time.Clock()

    # Set background color
    screen.fill((240, 240, 240))

    # Main entry loop
    while(True):

        # Event handling quit the game
        event = pygame.event.poll()
        if event.type == pygame.QUIT or (event.type == pygame.KEYDOWN and event.key == pygame.K_ESCAPE):
            break

        # Draw the x = -y line
        pygame.draw.line(screen, (0, 0, 0), [
                         0, 0], [screenWidth, screenHeight], 2)

        # With the blue point drawn at testPT let's predict the class
        # 1 if it's above the line -1 if it's under the line
        pygame.draw.circle(screen, blue, testPt, 10)

        pygame.display.flip()

        # Wait 60 frames
        clock.tick(60)
