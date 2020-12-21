import numpy as np
from random import randrange
import pygame


# Colors
orange = pygame.Color(255, 150, 0)

# Create a Points object with position x and y and a label 

class Points:

    def __init__(self):
        self.x = randrange(0, 600)
        self.y = randrange(0, 600)

        if (self.x > self.y):
            self.label = 1
        else:
            self.label = -1

    def draw(self, screen):
        pygame.draw.circle(screen, orange, [
            self.x, self.y], 8)
