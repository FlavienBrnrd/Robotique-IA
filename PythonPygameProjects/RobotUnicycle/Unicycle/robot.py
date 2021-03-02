import numpy as np
import math
import pygame

PI = math.pi


class Robot:

    # Initialization of the robot
    def __init__(self, x, y, phi, screen):
        # Draw on this particular screen
        self.screen = screen

        # Position and orientation
        self.x = x
        self.y = y
        self.phi = math.radians(phi)

        # Definition the state vector
        self.state = np.matrix([self.x, self.y, self.phi])

        # Robot "Physical" structure
        self.wheelRaduis = 1.0
        self.ccd = 2.0  # center to center distance between wheels
        self.sensorSkirt = [-PI/2, - PI/4, PI/4, PI/2]
        self.sensorRange = 200.0
        self.radius = 20.0

    # Update
    def update(self, X, dt):
        self.x += X[0].item(0) * dt
        self.y += X[1].item(0) * dt
        self.phi += math.radians(X[2].item(0))

    # Draw
    def draw(self):
        self.screen.fill((200, 200, 200))

        # Robot base
        pygame.draw.circle(self.screen, pygame.Color(50, 150, 50), [
                           self.x, self.y], self.radius)

        # Head
        pygame.draw.line(self.screen, pygame.Color(0, 0, 255), [self.x, self.y], [
            self.x+math.cos(self.phi)*self.sensorRange, self.y+math.sin(self.phi)*self.sensorRange])

        # Sensor Skirt
        for angle in self.sensorSkirt:
            pygame.draw.line(self.screen, pygame.Color(200, 0, 105), [self.x, self.y], [
                self.x+math.cos(self.phi + angle)*self.sensorRange, self.y+math.sin(self.phi + angle)*self.sensorRange])

    # Robot Behavior
    # --------------
    # Go to goal
    def goToGoal(self, xGoal, yGoal):

        # Actuation model
        MA = np.matrix([[self.wheelRaduis/2, self.wheelRaduis/2],
                        [(self.wheelRaduis/(2*self.ccd)), (-self.wheelRaduis/(2*self.ccd))]])

        # Kinematic Model
        MC = np.matrix([[math.cos(self.phi), 0.0], [
            math.sin(self.phi), 0.0], [0.0, 1.0]])

        # Set proportional gain
        Kp = 5

        # Compute the error
        errorPos = [xGoal - self.x, yGoal - self.y]

        # Steer to the goal the desired angle
        # make sure it's radians
        phiGoal = math.atan2(errorPos[1], errorPos[0])

        # Calculate the stateDot for the goal
        stateDotGoal = np.matrix([[errorPos[0]],
                                  [errorPos[1]],
                                  [Kp * math.atan2(np.sin(phiGoal - self.phi), np.cos(phiGoal-self.phi))]])

        # Calculate the command  with pinv (linear algebra module)
        cmd = np.linalg.pinv(MA) * np.linalg.pinv(MC) * stateDotGoal
        return cmd

    def setCommand(self, controlEntry):
        # Actuation model
        MA = np.matrix([[self.wheelRaduis/2, self.wheelRaduis/2],
                        [(self.wheelRaduis/(2*self.ccd)), (-self.wheelRaduis/(2*self.ccd))]])

        # Kinematic Model
        MC = np.matrix([[math.cos(self.phi), 0.0], [
            math.sin(self.phi), 0.0], [0.0, 1.0]])

        nu = MA * controlEntry
        stateDot = MC * nu
        return stateDot

    # Check sensor with ray tracing method
    # TODO : Make avoid obstacle behaviour
    def checkSensor(self, obstacle):
        for i in range(len(self.sensorSkirt)):
            x1 = obstacle.x1
            y1 = obstacle.y1
            x2 = obstacle.x2
            y2 = obstacle.y2

           

            x3 = self.x
            y3 = self.y
            x4 = self.x + self.sensorRange*np.cos(self.sensorSkirt[i]+self.phi)
            y4 = self.y + self.sensorRange*np.sin(self.sensorSkirt[i]+self.phi)

            # calculate the u and t
            den = (x1 - x2)*(y3 - y4)-(y1 - y2)*(x3 - x4)
            if den == 0:
                return
            else:
                t = ((x1 - x3)*(y3 - y4)-(y1 - y3)*(x3 - x4)) / den
                u = -((x1 - x2)*(y1 - y3)-(y1 - y2)*(x1 - x3)) / den

                if ((t > 0) and (t < 1) and (u > 0) and (u < 1)):
                    ptx, pty = [], []
                    ptx[i] = (x1 + t*(x2-x1))
                    pty[i] = (y1 + t*(y2-y1))
                    return [ptx, pty]
                else:
                    return
