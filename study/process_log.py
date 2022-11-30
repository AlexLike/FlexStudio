import numpy as np
import matplotlib.pyplot as plt
import matplotlib.cm as cm
import pandas as pd
from scipy.ndimage import gaussian_filter
import sys, getopt
import os.path

panel_names = {
    'Cozy Campfire': 1,
    'Plumber': 1
}

test_type = {
    'indirect': 1,
    'direct' : 2
}

def plot_helper(x, y, s, bins=1000):
    heatmap, xedges, yedges = np.histogram2d(x, y, bins=bins, range=[[0,1350],[0,1020]])
    heatmap = gaussian_filter(heatmap, sigma=s)

    extent = [xedges[0], xedges[-1], yedges[0], yedges[-1]]
    return heatmap.T, extent

def heatmap(tests):
    # Format the test data
    taps = [[np.array(tests[0]['taps'][0]), np.array(tests[0]['taps'][1])], [np.array(tests[1]['taps'][0]), np.array(tests[1]['taps'][1])]]
    error = [[np.array(tests[0]['error'][0]), np.array(tests[0]['error'][1])], [np.array(tests[1]['error'][0]), np.array(tests[1]['error'][1])]]
    # #Plot the Heatmaps of the two tests
    fig, axs = plt.subplots(1, 2)
    sigmas = [0,1]
    for ax, s in zip(axs.flatten(), sigmas):
        ax.plot(taps[s][0], taps[s][1], 'k.', markersize=5)
        img, extent = plot_helper(error[s][0], error[s][1], 30)
        ax.imshow(img, extent=extent, origin='lower', cmap=cm.jet)
        ax.set_title("Test of "+tests[s]['name'])
        ax.invert_yaxis()
    plt.show()

def onLayerMenu(x, y):
    int_x = int(x)
    int_y = int(y)
    if int_x>10 and int_x<190:
        if int_y>250 and int_y<790:
            return True
    return False

def readData(inputfile):
    test1 = {
        'type':"",
        'actions':{},
        'taps':[[],[]],
        'error': [[],[]], ## faulty taps
        'time': ""
    }
    test2 = {
        'type':"",
        'actions':{},
        'taps':[[],[]],
        'error': [[],[]], ## faulty taps
        'time': ""
    }
    tests = [test1,test2]
    recording = False
    last_action = [None, None]
    with open(inputfile) as file:
        current_test = None
        test_done = 0
        for line in file:
            action = line.rstrip('\n').split()
            if len(action)>10:
                action = action[10:]
                if action[0] == 'Opened':
                    if current_test != None:
                        print("ERROR: Opening new panel without closing the last one!")
                    else:
                        last_action = [None,None]
                        panel =  ' '.join(action[6:])
                        if panel in panel_names:
                            current_test = test_done
                            continue
                if action[0] == 'Dismissed':
                    if current_test != None:
                        test_done += 1
                    current_test = None
                    last_action = [None,None]
                if current_test != None:
                    if action[0] == 'Touch':
                        if recording:
                            x = str(int(float(action[3][1:-1])))
                            y = str(int(float(action[4][:-1])))
                            if last_action[0] != None and last_action[1] != None:
                                tests[current_test]['error'][0].append(last_action[0])
                                tests[current_test]['error'][1].append(last_action[1])
                                tests[current_test]['taps'][0].append(last_action[0])
                                tests[current_test]['taps'][1].append(last_action[1])
                            if not onLayerMenu(x,y):
                                last_action = [x,y]
                            else:
                                # leave commented out to ignore all touches in layer menu
                                # uncomment to log all touches in layer menu as correct touches
                                # tests[current_test]['tap'][0].append(x) 
                                # tests[current_test]['tap'][1].append(y) 
                                last_action = [None,None]

                    else:
                        if action[0] == 'Testing':
                            tests[current_test]['type'] = action[2]
                        if action[0] == 'The':
                            if action[2] == 'begins':
                                recording = True
                            elif action[2] == 'finishes':
                                recording = False
                                tests[current_test]['time'] = action[-2]
                        elif recording:
                            key = " ".join(action).rstrip('.')
                            tests[current_test]['actions'][key] = tests[current_test]['actions'].get(key,0) + 1 
                            if last_action[0] != None and last_action[1] != None:
                                tests[current_test]['taps'][0].append(last_action[0])
                                tests[current_test]['taps'][1].append(last_action[1])
                        last_action = [None,None]
    return tests

def writeData(result, id, outputfile):
    file_exists = True
    if not os.path.isfile(outputfile):
        print("Results file doesn't exist on the given path!")
        print("Creating the results file...")
        file_exists = False

    header_idx = {
        "Participant's ID": 0,
        "Task type": 1,
        "Task completion time": 2, 
        "Total number of taps": 3, 
        "Number of erroneous inputs": 4,
        "Resized frame": 5,
        "Selected layer": 6,
        "Toggled layer visibility": 7,
        "Toggled ResponsivityControlView": 8,
        "Toggled pin location": 9,
        "Toggled keyframe": 10,
        "Moved position in keyframe": 11,
        "Tap x coord.": 12, 
        "Tap y coord.": 13, 
        "Error x coord.": 14, 
        "Error y coord.": 15
    }
    header = ["Participant's ID", "Task type", "Task completion time", "Total number of taps", "Number of erroneous inputs", 
    "Resized frame", "Selected layer", "Toggled layer visibility", "Toggled ResponsivityControlView", "Toggled pin location", "Toggled keyframe", "Moved position in keyframe",
    "Tap x coord.", "Tap y coord.", "Error x coord.", "Error y coord."]

    data = [[0 for i in range(16)] for j in range(2)]

    for i in range(2):
        data[i][0] = id
        data[i][1] = result[i]['type']
        data[i][2] = result[i]['time']
        if len(result[i]['taps'][0]) != len(result[i]['taps'][1]):
            print("ERROR: Number of x-coord. and y-coord. of touches isn't equal")
            return
        data[i][3] = len(result[i]['taps'][0])
        data[i][12] = ' '.join(result[i]['taps'][0])
        data[i][13] = ' '.join(result[i]['taps'][1])
        if len(result[i]['error'][0]) != len(result[i]['error'][1]):
            print("ERROR: Number of x-coord. and y-coord. of erroneous inputs isn't equal")
            return
        data[i][4] = len(result[i]['error'][0])
        data[i][14] = ' '.join(result[i]['error'][0])
        data[i][15] = ' '.join(result[i]['error'][1])
        for key in result[i]['actions'].keys():
            data[i][header_idx[key]] = result[i]['actions'][key]

    data = pd.DataFrame(data, columns=header)
    if file_exists: 
        data.to_csv(outputfile, mode='a', index=False, header=False)
        print("Data added to the results file.")
        return
    data.to_csv(outputfile, index=False)
    print("New results file created.")
    return

if __name__ == "__main__":
    id = "5" 
    inputfile = "study/"+id+"/relevant.log"
    outputfile = "study/study_results.csv"
    argv = sys.argv[1:]

    # if len(argv)< 3:
    #     print("Arguments missing!")
    #     print("\t Usage: process_log.py -I <Participant's ID> -i <inputfile.log> -o <outputfile.csv>")
    #     sys.exit()
    # try:
    #     opts, args = getopt.getopt(argv, "hI:i:o:",["Id=","ifile=","ofile="])
    # except getopt.GetoptError:
    #     print("Arguments missing!")
    #     print("\t Usage: process_log.py -I <Participant's ID> -i <inputfile.log> -o <outputfile.csv>")
    #     sys.exit(2)
    # for opt, arg in opts:
    #     if opt == '-h':
    #         print("\t Usage: process_log.py -I <Participant's ID> -i <inputfile.log> -o <outputfile.csv>")
    #         sys.exit()
    #     elif opt in ("-i", "--ifile"):
    #         inputfile = arg
    #     elif opt in ("-o", "--ofile"):
    #         outputfile = arg
    #     elif opt in ("-I", "--Id"):
    #         id = arg

    if not os.path.isfile(inputfile):
        print("Wrong path to inputfile!")
        sys.exit()
    result = readData(inputfile)
    # print(result[0])
    # print(result[1])
    writeData(result,id,outputfile)

















