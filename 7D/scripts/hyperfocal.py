#!/usr/bin/env python
# The aim is to provide hyperfocal for a range of values in aperture and focal

import pdb # to debug through pdb.set_trace()
import matplotlib.pyplot as pl
import numpy as np
from matplotlib.ticker import FormatStrFormatter, ScalarFormatter

focal_min = 17 # mm
focal_max = 100. # mm
nb_focals = 100

CIRCLE_OF_CONFUSION = 0.019 # mm

#~ to generate aperture values [2.**(i/2.) for i in range(1,12)]
aperture_values = [1.4142135623730951, 2.0, 2.8284271247461903, 4.0, 5.656854249492381, 8.0, 11.313708498984761]#, 16.0, 22.627416997969522, 32.0, 45.254833995939045]
aperture_names = ["f/1.4", "f/2", "f/2.8", "f/4", "f/5.6", "f/8", "f/11"]#, "f/16", "f/22", "f/32", "f/45"]

if (len(aperture_names) == len(aperture_values)):
  nb_apertures = len(aperture_names)
else:
  raise ValueError("aperture_values and aperture_names do not have the same length")

def getHyperfocal(aperture, circle_of_confusion, focal_length):
  hyperfocal = focal_length**2 / (aperture * circle_of_confusion) + focal_length # mm

  return hyperfocal

# We generate the values for the focal
delta_focal = (focal_max - focal_min) / float(nb_focals-1)
focals = np.array([focal_min + i * delta_focal for i in range(nb_focals)])

# We prepare the plot
fig = pl.figure(1)
plot_hyperfocal = fig.add_subplot(111) # We define a fake subplot that is in fact only the plot.

for (aperture, aperture_name) in zip(aperture_values, aperture_names):
  hyperfocals = []
  for focal_length in focals:
    hyperfocal = getHyperfocal(aperture=aperture, circle_of_confusion=CIRCLE_OF_CONFUSION, focal_length=focal_length)
    hyperfocals.append(hyperfocal)
  hyperfocals = np.array(hyperfocals)
  
  plot_hyperfocal.semilogy(focals, hyperfocals/1000., label=aperture_name)

plot_hyperfocal.yaxis.set_major_formatter(FormatStrFormatter('%.0f'))
plot_hyperfocal.yaxis.set_minor_formatter(FormatStrFormatter('%.0f'))

plot_hyperfocal.tick_params(axis='both', which='major', labelsize=10)
plot_hyperfocal.tick_params(axis='both', which='minor', labelsize=7)

plot_hyperfocal.xaxis.grid(True,'minor', color='#000000', linestyle=':')
plot_hyperfocal.yaxis.grid(True,'minor', color='#000000', linestyle=':')
plot_hyperfocal.xaxis.grid(True,'major', color='#000000', linestyle='--')
plot_hyperfocal.yaxis.grid(True,'major', color='#000000', linestyle='--')


pl.xlabel("Distance Focale (mm)", fontsize = 14)
pl.ylabel("Hyperfocale (m)", fontsize = 14)
pl.axis("tight")
pl.legend(loc='lower right')

pl.savefig("hyperfocal.pdf", format="pdf")

#~ pl.show()
