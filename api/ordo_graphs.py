import argparse
import collections
import itertools
import os
import re
import sys

import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns

sns.set_theme()
palette = itertools.cycle(sns.color_palette())
# palette = itertools.cycle(['#C8909D', '#5E8E9C', '#90B0E5', '#8F74CE', '#635AA6'])

def find_ordo_file(root_dir):
    for path, subdirs, files in os.walk(root_dir, followlinks=False):
        for filename in files:
            if filename == 'ordo.out':
                return os.path.join(path, filename)

def parse_ordo_file(filename):
    p = re.compile('.*nn-epoch(\\d*)\\.nnue')
    with open(filename, 'r') as ordo_file:
        rows = []
        for line in ordo_file.readlines():
            if 'nn-epoch' in line and 'nnue' in line:
                fields = line.split()
                run_epoch = fields[1]
                run = run_epoch.split('/')[0]
                epoch = int(p.match(run_epoch)[1])
                rating = float(fields[3])
                error = float(fields[4])
                rows.append((run, epoch, rating, error))
        return rows

def ordo_plot_png_image(root_dirs):
    fig = plt.figure()
    fig.set_size_inches(15, 9)
    ax_elo = fig.add_subplot()
    ax_elo.set_ylim([-40, 10])
    ax_elo.set_xlabel('epoch')
    ax_elo.set_ylabel('elo')
    for root_dir in root_dirs:
        ordo_file = find_ordo_file(root_dir)
        if not ordo_file:
            print('Did not find ordo file. Skipping.')
            continue
        print(f'Found ordo file {ordo_file}')
        rows = parse_ordo_file(ordo_file)
        if len(rows) == 0:
           continue
        rows = sorted(rows, key=lambda r: (r[1], r[0]))
        runs = sorted(list(set([row[0] for row in rows])))
        color = next(palette)
        for run_to_plot in runs:
            epochs, elos, errors = [], [], []
            for row in rows:
                run, epoch, elo, error = row
                if run == run_to_plot:
                    epochs.append(epoch)
                    elos.append(elo)
                    errors.append(error)
            print(f'Found ordo data for {len(epochs)} epochs')
            plot_kwargs = { 'label': f"{root_dir.split('/')[-1]} {run_to_plot}" }
            if 'master-net' in root_dir:
                plot_kwargs['linewidth'] = 3
            elif 'experiment_control' in root_dir:
                plot_kwargs['linewidth'] = 2
            else:
                plot_kwargs['linewidth'] = 2
            elos, errors = np.array(elos), np.array(errors)
            if True:  # error bars
                plot_kwargs.update({ 'yerr': errors })
                ax_elo.errorbar(epochs, elos, c=color, **plot_kwargs)
            else:  # error bands
                plt.plot(epochs, elos, color=color)
                plt.fill_between(epochs, elos - errors, elos + errors,
                                 color=color, alpha=0.2)
    ax_elo.axhline(y = 0, color = 'g', linestyle = '--')
    ax_elo.legend()
    plt.savefig('/tmp/plot.png', dpi=100)
    with open('/tmp/plot.png', 'rb') as f:
        return f.read()
