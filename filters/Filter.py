# library imports
import timeit
import sys
import numpy as np
from abc import ABC, abstractmethod

# local imports
from Parsing import *

class Filter(ABC):
    '''
    Parent class for navigation filters
    '''
    def __init__(self, t, x0, x_true, Y, Ht, R):
        '''
        Input:
         - t; time steps associated with data
         - x0; state estimate -- near true position (m,)
         - x_true; true user trajectory (m,n)
         - Y; measurements at each time step (l,n)
         - Ht; measurement model partials, accepts 1 arg (state), returns (l,m)
         - R; measurement covariance matrix, accepts 1 arg (time), returns (l,l)
        '''

        # dimensions
        self.l = np.shape(Y)[0]         # dimension of measurements
        self.m = np.shape(x_true)[0]    # dimension of state
        self.n = np.shape(x_true)[1]    # number of data points

        # vectors and matrices
        self.t  = t                     # list of time steps
        self.x0 = x0                    # nominal initial state
        self.x_true = x_true            # true state
        self.Y  = Y                     # observed measurements         
        self.Ht = Ht                    # measurement partials
        self.R  = R                     # measurement covariance matrix function

        self.x = np.zeros((self.m,self.n))          # state estimate
        self.y = np.zeros((self.l,self.n))          # position measurements
        self.P = np.zeros((self.m,self.m,self.n))   # covariance matrix

        self._i = 0                     # initialize sim step

    def __enter__(self):
        ''' Support for with statements '''
        return self

    def __exit__(self, ex_type, ex_val, ex_traceback):
        ''' Catch exit errors '''
        if ex_type is not None:
            print("\nExecution type:", ex_type)
            print("\nExecution value:", ex_val)
            print("\nTraceback:", ex_traceback)

    @property
    def i(self):
        return self._i

    def step(self):
        ''' Increment time step of simulation '''
        self._i += 1

    @abstractmethod
    def evaluate(self, verbose=False):
        '''
        Iterate through sat data and determine estimated state at each time step
        '''
        pass

    def plot(self, ax, last=False, batch=True):
        # Compute RMS position error
        t = [x / 3600 for x in self.t]   # get time in hours
        e = [0] * self.n
        std = [0] * self.n
        for j in range(0,self.n):
            diff  = self.x[0:3,j] 
            diff -= self.x_true[0:3,0] if batch else self.x_true[0:3,j]
            var = np.diag(self.P[:,:,j])
            e[j] = np.sqrt(np.dot(diff, diff))              # rms pos error
            std[j] = 3 * np.sqrt(var[0] + var[1] + var[2])  # std of est.

        # Plot RMS position error
        mc, = ax.plot(t, e, color='gray', linestyle='dotted', linewidth=1, label='Monte-Carlo run')
        stat, = ax.plot(t, std, color='green', label='3?? error') if last else (None,)
        return mc, stat