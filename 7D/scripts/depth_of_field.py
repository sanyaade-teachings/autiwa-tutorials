#!/usr/bin/env python
# The aim is to provide basic values of depth of field for various focal lentgh and so on

import pdb # to debug through pdb.set_trace()
import numpy as np
import pylab as pl
import autiwa
import math
from matplotlib.ticker import FormatStrFormatter, ScalarFormatter, MaxNLocator, LogLocator


INFINITY = 100000. # mm we define the value of 'infinity', in mm, to replace negative value of the far value of DOF

d_min = 15. # mm
d_max = 20000. # mm
nb_distance = 100

#~ focal_min = 17 # mm
#~ focal_max = 100. # mm
#~ nb_focals = 3
focals = [17., 50., 100., 400.] # in mm

focal_length = 50. # mm

dof_min = 5. # mm
dof_max = 5000. # mm
nb_dof = 7
dof_step = (dof_max / dof_min)**(1/(nb_dof-1.))
dofs = [dof_min * dof_step**i for i in range(nb_dof)] # in mm, the depth of field we want
#~ dofs = [1., 50., 150., 300., 1000., 2000., 3000.] # in mm, the depth of field we want

CIRCLE_OF_CONFUSION = 0.019 # mm

#~ to generate aperture values [2.**(i/2.) for i in range(1,12)]
aperture_values = [1.4142135623730951, 2.0, 2.8284271247461903, 4.0, 5.656854249492381, 8.0, 11.313708498984761]#, 16.0, 22.627416997969522, 32.0, 45.254833995939045]
aperture_names = ["f/1.4", "f/2", "f/2.8", "f/4", "f/5.6", "f/8", "f/11"]#, "f/16", "f/22", "f/32", "f/45"]

surface_values = [1/ap for ap in aperture_values]

#~ subject_distance = 1000. # mm
#~ aperture = 1.4 # 1.4 for f/1.4
#~ circle_of_confusion = 0.019 # mm
#~ focal_length = 50. # mm

#~ [2.**(i/2.) for i in range(1,12)]
#~ [1.4142135623730951, 2.0, 2.8284271247461903, 4.0, 5.656854249492381, 8.0, 11.313708498984761, 16.0, 22.627416997969522, 32.0, 45.254833995939045]


def getDOF(subject_distance, aperture, circle_of_confusion, focal_length):
  """Function that return the depth of field given some parameters.
  The formulaes comes from http://www.dofmaster.com/equations.html
  """
  
  hyperfocal = focal_length**2 / (aperture * circle_of_confusion) + focal_length # mm

  corrected_hyperfocal = hyperfocal - focal_length
  corrected_distance = subject_distance - focal_length
  
  depthOfField_near = corrected_hyperfocal * subject_distance / (corrected_hyperfocal + corrected_distance) # mm
  depthOfField_far  = corrected_hyperfocal * subject_distance / (corrected_hyperfocal - corrected_distance) # mm

  return (depthOfField_near, depthOfField_far)

def getHyperfocal(aperture, circle_of_confusion, focal_length):
  hyperfocal = focal_length**2 / (aperture * circle_of_confusion) + focal_length # mm

  return hyperfocal

def findCorrespondingDistance(dof, aperture, circle_of_confusion, focal_length):

  IT_MAX = 200
  
  a = 200. # mm
  b = 100000. # mm

  hyperfocal = getHyperfocal(aperture=aperture, circle_of_confusion=circle_of_confusion, focal_length=focal_length)

  # We get problems for the hyperfocal, so we substract 1 millimeter
  b = min(b, hyperfocal-1.)

  if (a > b):
    print("boundaries are not in the right order : [%.0f ; %.0f]" % (a, b))
    pdb.set_trace()
  
  (dof_near, dof_far) = getDOF(subject_distance=a,
  aperture=aperture, circle_of_confusion=circle_of_confusion, focal_length=focal_length)
  dof_a = dof_far - dof_near


  (dof_near, dof_far) = getDOF(subject_distance=b,
  aperture=aperture, circle_of_confusion=circle_of_confusion, focal_length=focal_length)
  dof_b = dof_far - dof_near


  if ((dof_a > dof) and (dof_b > dof)):
    return a

  if ((dof_a < dof) and (dof_b < dof)):
    return np.NaN
    #~ pdb.set_trace()
    #~ raise ValueError("The dof cannot be found in the boundaries of distance [%f, %f]" % (d_min, d_max))
    

  c = b
  dof_c = dof_b
  for iteration in range(IT_MAX):
    if ((dof_a < dof) and (dof_c > dof)):
      b = c
      dof_b = dof_c

    elif ((dof_c < dof) and (dof_b > dof)):
      a = c
      dof_a = dof_c

    c = (a + b) / 2.
    (dof_near, dof_far) = getDOF(subject_distance=c,
    aperture=aperture, circle_of_confusion=circle_of_confusion, focal_length=focal_length)
    dof_c = dof_far - dof_near


    if ((abs(dof_c - dof) / dof) < 0.01):
      return c

  pdb.set_trace()

#~ dist = 25. # cm
#~ ap = 1.4
#~ f = 50. # mm
#~ 
#~ (dof_near, dof_far) = getDOF(subject_distance=dist*10.,
#~ aperture=ap, circle_of_confusion=CIRCLE_OF_CONFUSION, focal_length=f)
#~ dof = dof_far - dof_near
#~ print("focal = %.1f mm ; aperture = f/%.1f ; subject distance = %.1f cm" % (f, ap, dist))
#~ print("depth of field = %.1f cm" % (dof/10.))
#~ exit()





if (len(aperture_names) == len(aperture_values)):
  nb_apertures = len(aperture_names)
else:
  raise ValueError("aperture_values and aperture_names do not have the same length")

# We generate the values for the distances
delta_distance = (d_max - d_min) / float(nb_distance-1)
distances = np.array([d_min + i * delta_distance for i in range(nb_distance)])

#~ # We generate the values for the focal
#~ delta_focal = (focal_max - focal_min) / float(nb_focals-1)
#~ focals = np.array([focal_min + i * delta_focal for i in range(nb_focals)])

# We prepare the plot
fig = pl.figure(1)
nb_subplot = autiwa.get_subplot_shape(len(focals))

fig.subplots_adjust(left=0.12, bottom=0.1, right=0.96, top=0.95, wspace=0.26, hspace=0.26)

#~ myxfmt = ScalarFormatter(useOffset=True)
#~ myxfmt._set_offset(1e5)
#~ myxfmt.set_scientific(True)
#~ myxfmt.set_powerlimits((-3, 3)) 
myxfmt = FormatStrFormatter('%.0f')
myminorxfmt = FormatStrFormatter('%.1f')


# We generate a list of colors
colors = [ '#'+li for li in autiwa.colorList(len(dofs))]

for focal_length in focals:
  nb_subplot += 1
  plot_dof = fig.add_subplot(nb_subplot) # We define a fake subplot that is in fact only the plot.
  #~ dof_near = []
  #~ dof_far  = []
  for (required_dof, color) in zip(dofs, colors):
    distances = []
    for (aperture, aperture_name) in zip(aperture_values, aperture_names):
      distance = findCorrespondingDistance(dof=required_dof, aperture=aperture,
      circle_of_confusion=CIRCLE_OF_CONFUSION, focal_length=focal_length)
      
        
      distances.append(distance)

    distances = np.array(distances)


    if (required_dof < 10.):
      label = "pdc=%.1f mm" % (required_dof)
    elif (required_dof < 1000.):
      label = "pdc=%.1f cm" % (required_dof/10.)
    else:
      label = "pdc=%.1f m" % (required_dof/1000.)
      
    try:
      plot_dof.semilogx(distances/1000., surface_values, color=color, label=label)
    except:
      print("nan")
    
  plot_dof.set_xlabel("Distance (m)")
  plot_dof.set_ylabel("Ouverture")
  plot_dof.set_title("Focale %.0f mm" % focal_length)
  plot_dof.xaxis.grid(True, 'minor', color='#000000', linestyle=':')
  plot_dof.yaxis.grid(True, 'minor', color='#000000', linestyle=':')
  plot_dof.xaxis.grid(True, 'major', color='#000000', linestyle='--')
  plot_dof.yaxis.grid(True, 'major', color='#000000', linestyle='--')
  plot_dof.axis('tight')
  plot_dof.set_yticks(surface_values)
  plot_dof.set_yticklabels(aperture_names)
  plot_dof.tick_params(axis='x', which='minor', labelsize=9)
  plot_dof.legend(loc='lower right')
  plot_dof.xaxis.set_major_formatter(myxfmt)
  plot_dof.xaxis.set_minor_formatter(myminorxfmt)

#~ plot_dof.tick_params(axis='both', which='major', labelsize=10)
#~ plot_dof.tick_params(axis='both', which='minor', labelsize=7)

#~ plot_dof.xaxis.grid(True,'minor', color='#000000', linestyle=':')
#~ plot_dof.yaxis.grid(True,'minor', color='#000000', linestyle=':')
#~ plot_dof.xaxis.grid(True,'major', color='#000000', linestyle='--')
#~ plot_dof.yaxis.grid(True,'major', color='#000000', linestyle='--')
#~ 
#~ pl.axis("tight")
#~ pl.ylim(ymax=INFINITY/1000.)
#~ pl.xlabel("Distance (m)", fontsize = 14)
#~ pl.ylabel("Profondeur de champ (m)", fontsize = 14)
#~ 
#~ pl.legend(loc='lower right')
#~ pdb.set_trace()
pl.show()


#~ pdb.set_trace()
