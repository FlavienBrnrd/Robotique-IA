import pygame
import numpy as np

# Custom import
import robot


# Screen
screenWidth = 1800
screenHeight = 1024

# Goal position
goalX = screenWidth / 2
goalY = screenHeight / 2
goalPhi = 0


# time step
dt = 0.1

if __name__ == "__main__":
    # pygame init
    pygame.init()
    screen = pygame.display.set_mode(
        [screenWidth, screenHeight], pygame.DOUBLEBUF)
    pygame.display.set_caption('Robby the Diff-Robot')
    clock = pygame.time.Clock()

    # Create a new robot
    robby = robot.Robot(50, 50, 45, screen)

    # Set background color
    screen.fill((200, 200, 200))
    

    # Main entry loop
    while(True):

        # Event handling quit the game
        event = pygame.event.poll()
        if event.type == pygame.QUIT or (event.type == pygame.KEYDOWN and event.key == pygame.K_ESCAPE):
            break

        # Draw
        robby.draw()

        #  Go to Goal behaviour
        u = robby.goToGoal(goalX, goalY)
        

        # Simple go forward command
        # u = np.array([[1.0],[2.0]])

        # send the appropriate command
        X = robby.setCommand(u)

        # Update
        robby.update(X, dt)

        pygame.draw.circle(screen, pygame.Color(150, 50, 50), [
            goalX, goalY], 8)

        # Update PyGame display
        pygame.display.flip()

        # Wait 60 frames
        clock.tick(60)
