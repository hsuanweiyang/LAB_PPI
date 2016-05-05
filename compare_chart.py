__author__ = 'apple'

import os
from sys import argv
import numpy as np
#import plotly.plotly as py
#import plotly.graph_objs as go


def categorize_raw_data(raw_data_file):
    os.system('sort -n -r -k 3 ' + raw_data_file + ' > sort_' + raw_data_file)
    raw_data = os.popen('cat sort_' + raw_data_file)
    no_dis = 0
    group = np.zeros(15)
    # sub_group = np.zeros(10)
    for eachline in raw_data:
        line_data = eachline.rstrip('\n').split('\t')
        dis = int(line_data[2])
        if dis == -1:
            no_dis += 1
            continue
        group_cate = dis / 100000
        '''
        if group_cate == 0:
            group_cate = dis/10000
            sub_group[group_cate] += 1
        else:
            group[group_cate] += 1
        '''
        group[group_cate] += 1
    return group, no_dis


def accumulate_group(data_group):
    accu_data = []
    for n in range(len(data_group)):
        if n == 0:
            accu_data.append(data_group[n])
        else:
            accu_data.append(data_group[n]+accu_data[n-1])
    return accu_data


def draw_barChart(x1_data, y1_data, x2_data, y2_data):
    ppi = go.Bar(x=x1_data, y=y1_data, name='ppi')
    nonppi = go.Bar(x=x2_data, y = y2_data, name='nonppi')
    data = [ppi, nonppi]
    layout = go.Layout(barmode='group')
    fig = go.Figure(data=data, layout=layout)
    plot_url = py.plot(fig, filename='distance_distribution')

if __name__ == '__main__':
    ppi_file_input = argv[1]
    #nonppi_file_input = argv[2]
    ppi_data_group, ppi_no_dis_amount = categorize_raw_data(ppi_file_input)
    #nonppi_data_group, nonppi_no_dis_amount = categorize_raw_data(nonppi_file_input)
    '''
    accu_data = accumulate_group(data_group)
    for i in range(len(accu_data)):
        print str(100000*(i+1)) + '\t' +str(accu_data[i])
    '''
    #draw_barChart(np.append(ppi_data_group, ppi_no_dis_amount), range(100000, 1500001, 100000).append(-1),
    #              np.append(nonppi_data_group, nonppi_no_dis_amount), range(100000, 1500001, 100000).append(-1))

    a = list(range(100000, 1500001, 100000))
    a.append(-1)
    print a