__author__ = 'Hsuanwei'
import os, sys
import numpy as np
from math import log, exp
import logging
import timeit
from sys import argv

def generate_train_test(input_file):
    os.system('./generate_train_test.pl ' + input_file)
    train_data = 'data_train'
    test_data = 'data_test'
    return train_data, test_data


def auto_svm_process(train_data, test_data, ori_dim, add_dim, predict_result_file_name='predict_svm'):
    start_time = timeit.default_timer()
    os.system('svm-scale -s train-scale-info ' + train_data + ' > scale-train-data')
    os.system('svm-scale -r train-scale-info ' + test_data + ' > scale-test-data')
    c_para, g_para = get_svm_grid_parameter(ori_dim, add_dim, 'scale-train-data')
    logging.info('c:' + str(c_para) + '\tg:' + str(g_para))
    os.system('svm-train -b 1 -h 0 -c ' + str(c_para) + ' -g ' + str(g_para) + ' scale-train-data svm-model')
    os.system('svm-predict -b 1 scale-test-data svm-model ' + predict_result_file_name)
    stop_time = timeit.default_timer()
    logging.info('[Processing time] :' + str(stop_time-start_time) + '  (sec)')
    return predict_result_file_name


def get_svm_grid_parameter(ori_dim, add_dim, p_scale_train):
    default_gamma = log(1/(float(ori_dim)+add_dim))/log(2)
    gamma_start = default_gamma-1
    gamma_stop = default_gamma+1
    logging.info('Dimension of original feature : ' + str(ori_dim) + '\tDimension of added feature : ' + str(add_dim))
    logging.info('default : ' + str(default_gamma))
    logging.info('gamma range : ' + str(gamma_start) + '~' + str(gamma_stop))
    os.system('svm-grid -log2c -1,1,0.5 -log2g ' + str(gamma_start) + ',' + str(gamma_stop) + ',0.5 ' + p_scale_train)
    os.system('sort -n -r -k 3 ' + p_scale_train + '.out > sort_grid')
    grid_result = np.loadtxt('sort_grid')
    trigger = 0
    for each_grid in grid_result:
        if trigger == 0:
            best_rate = each_grid[2]
            best_c = each_grid[0]
            best_g = each_grid[1]
            trigger = 1
            continue
        if (each_grid[2] > best_rate) or (best_rate == each_grid[2] and best_g == each_grid[1] and best_c > each_grid[0]):
            best_rate = each_grid[2]
            best_c = each_grid[0]
            best_g = each_grid[1]
    parameter_c = 2**(float(best_c))
    parameter_g = 2**(float(best_g))
    return parameter_c, parameter_g


if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO)
    input_file = argv[1]
    output_file = argv[2]
    original_dim = argv[3]
    add_dim = argv[4]
    logging.info('File Input : ' + input_file)
    train, test = generate_train_test(input_file)
    auto_svm_process(train, test, int(original_dim), int(add_dim), output_file)
