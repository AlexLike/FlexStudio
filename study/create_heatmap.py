import numpy as np
import matplotlib.pyplot as plt
import matplotlib.cm as cm
import pandas as pd
from scipy.ndimage import gaussian_filter

def plot_helper(x, y, s, bins=1000):
    heatmap, xedges, yedges = np.histogram2d(x, y, bins=bins, range=[[0,1450],[0,1120]])
    heatmap = gaussian_filter(heatmap, sigma=s)

    extent = [xedges[0], xedges[-1], yedges[0], yedges[-1]]
    return heatmap.T, extent

def heatmap(tap_x,tap_y,error_x,error_y):
    # Format the test data

    taps = [tap_x, tap_y]
    error = [error_x, error_y]
    # #Plot the Heatmaps of the two tests
    fig, axs = plt.subplots(1, 2)
    sigmas = [0,1]
    types = ['direct', 'indirect']
    for ax, s in zip(axs.flatten(), sigmas):
        ax.plot(taps[0][s], taps[1][s], 'k.', markersize=5)
        img, extent = plot_helper(error[0][s], error[1][s], 16)
        ax.imshow(img, extent=extent, origin='lower', cmap=cm.jet)
        ax.set_title("Test of "+types[s]+" responsivity interface.")
        ax.invert_yaxis()
    plt.show()

if __name__ == '__main__':
    data = pd.read_csv("study/study_results.csv")
    tap_x = [[],[]] #direct, indirect
    tap_y = [[],[]]
    error_x = [[],[]]
    error_y = [[],[]]
    for t,t_x,t_y,e_x,e_y in zip(data['Task type'],data['Tap x coord.'], data['Tap y coord.'], data['Error x coord.'], data['Error y coord.']):
        if t == 'direct':
            tap_x[0].append(t_x)
            tap_y[0].append(t_y)
            if type(e_x) == type(' '):
                error_x[0].append(e_x)
                error_y[0].append(e_y)
        elif t == 'indirect':
            tap_x[1].append(t_x)
            tap_y[1].append(t_y)
            if type(e_x) == type(' '):
                error_x[1].append(e_x)
                error_y[1].append(e_y)
    for i in range(2):
        tap_x[i] = list(map(int,' '.join(tap_x[i]).split(' ')))
        tap_y[i] = list(map(int,' '.join(tap_y[i]).split(' ')))
        error_x[i] = list(map(int,' '.join(error_x[i]).split(' ')))
        error_y[i] = list(map(int,' '.join(error_y[i]).split(' ')))
    print(tap_x)
    heatmap(tap_x,tap_y,error_x,error_y)