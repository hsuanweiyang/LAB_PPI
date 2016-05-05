__author__ = 'Hsuanwei'

import random
from sys import argv
import os


# combine pair with feature(ex.distance)
def combine_pair_feature(pair_filename, feature_filename):
    pair_file = os.popen('cat ' + pair_filename).readlines()
    feature_file = os.popen('cat ' + feature_filename).readlines()

    for each_line in pair_file:
        exist = 0
        pair = each_line.rstrip('\n').split('\t')
        for n in feature_file:
            feature_data = n.rstrip('\n').split('\t')

            if feature_data[0] == pair[0] and feature_data[1] == pair[1]:
                print n.rstrip('\n')
                exist = 1
                break
            elif feature_data[0] == pair[1] and feature_data[1] == pair[0]:
                print n.rstrip('\n')
                exist = 1
                break
        if exist == 0:
            print pair[0] + '\t' + pair[1] + '\t-1'


def random_generate_nonppi(raw_nonppi_file, data_amount):
    num = random.sample(xrange(14976187), data_amount)
    pair_file = os.popen('cat ' + raw_nonppi_file).readlines()
    output = open('random_nonppi_pair',mode='w')
    for i in range(len(num)):
        pair = pair_file[num[i]]
        output.write(pair)
    output.close()


# random generate same amount of non-ppi data as ppi data to be negative data set for comparing
def combine_nonppi_feature(pair_file, data_amount):
    random_generate_nonppi(pair_file, data_amount)
    combine_pair_feature('random_nonppi_pair', 'random_gene_distance_nonppi')







if __name__ == '__main__':
    ppiPair_file = argv[1]
    #nonPpi_file = argv[2]
    feature_file = argv[2]
    combine_pair_feature(ppiPair_file, feature_file)


