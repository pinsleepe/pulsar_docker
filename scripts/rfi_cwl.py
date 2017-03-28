#!/usr/local/bin/python
from rfipip import rfiObs, rfiDatabase
import matplotlib.pyplot as plt, mpld3
import numpy as np
import argparse

parser = argparse.ArgumentParser(description='Plot outgoing p0 dsim data.',
                                 formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument('--path',
                    dest='path',
                    type=str, action='store',
                    default='',
                    help='Path to the fil file')
args = parser.parse_args()
path = ''
if args.path != '':
    path = args.path
if path == '':
    raise RuntimeError('Could not find a path to use.')

fil_rfiObs1 = rfiObs.RfiObservation(path=path,
                                    fil_file=True)
header = fil_rfiObs1.file.header
start_time = header.tobs//2  # in seconds
duration = 1  # in seconds
block, nsamples = fil_rfiObs1.read_time_freq(start_time, duration)
start_sample = long(start_time / fil_rfiObs1.file.header.tsamp)
fig = plt.figure()
ax = plt.subplot(1, 1, 1)
plt.imshow(block,
           extent=[start_sample * fil_rfiObs1.file.header.tsamp,
                   (start_sample + np.shape(block)[1]) * fil_rfiObs1.file.header.tsamp,
                   np.shape(block)[0], 0],
           cmap='viridis',
           aspect='auto')
ax.set_aspect("auto")
ax.set_xlabel('observation time (secs)')
ax.set_ylabel('freq channel')
ax.set_title(header.source_name)
ax.set_aspect('auto')
mpld3.save_html(fig, header.source_name + '.html')
