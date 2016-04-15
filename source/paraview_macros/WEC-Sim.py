from paraview.simple import *
import os
import numpy as np

model = GetActiveSource()
renderView1 = GetActiveViewOrCreate('RenderView')
renderView1.CameraParallelProjection = 1
Hide(model, renderView1)

# waves
extractBlock1 = ExtractBlock(Input=model)
extractBlock1.BlockIndices = [1, 2]
extractBlock1Display = Show(extractBlock1, renderView1)
extractBlock1Display.ColorArrayName = [None, '']
extractBlock1Display.DiffuseColor = [0.0, 0.0, 1.0]
extractBlock1Display.Opacity = 0.75
RenameSource('waves', extractBlock1)
calculator1 = Calculator(Input=extractBlock1)
calculator1.Function = 'coordsZ'
calculator1.ResultArrayName = 'elevation'
RenameSource('elevation', calculator1)

# ground
tmp = model.GetProperty('FileName')
dir = os.path.dirname(str(tmp)[1:-2])
filename = dir + os.sep + 'ground.txt'
f = open(filename,'r')
ground = np.loadtxt(f)
f.close()
gextent = ground[0]
gdepth = -ground[1]
MoorDyn = ground[2]
plane1 = Plane()
plane1.Origin = [-gextent,-gextent,gdepth]
plane1.Point1 = [gextent,-gextent,gdepth]
plane1.Point2 = [-gextent,gextent,gdepth]
plane1Display = Show(plane1, renderView1)
plane1Display.ColorArrayName = [None, '']
plane1Display.DiffuseColor = [0.6666666666666666, 0.6666666666666666, 0.4980392156862745]
plane1Display.EdgeColor = [0.5000076295109483, 0.36787975890745406, 0.12631418326085297]
RenameSource('ground', plane1)

# bodies
filename = dir + os.sep + 'bodies.txt'
f = open(filename,'r')
bodies = model.GetDataInformation().GetCompositeDataInformation().GetNumberOfChildren() - 1
if MoorDyn:
	bodies = bodies-1
for i in range(bodies):
	SetActiveSource(model)
	extractBlock1_2 = ExtractBlock(Input=model)
	extractBlock1_2.BlockIndices = [2+(i*2)+1, 2+(i*2)+2]
	extractBlock1_2Display = Show(extractBlock1_2, renderView1)
	extractBlock1_2Display.ColorArrayName = [None, '']
	name = f.readline()[:-1]
	color = np.fromstring(f.readline()[:-1],sep=' ')
	opacity = np.fromstring(f.readline()[:-1],sep=' ')
	RenameSource('body_'+str(i+1)+': '+name , extractBlock1_2)
	extractBlock1_2Display.DiffuseColor = color
	extractBlock1_2Display.Opacity = opacity 
	f.readline()
f.close()

# mooring
if MoorDyn:
	SetActiveSource(model)
	extractBlock1_3 = ExtractBlock(Input=model)
	extractBlock1_3.BlockIndices = [2+((bodies-1)*2)+1+2, 2+((bodies-1)*2)+2+2]
	extractBlock1_3Display = Show(extractBlock1_3, renderView1)
	extractBlock1_3Display.ColorArrayName = [None, '']
	RenameSource('MoorDyn', extractBlock1_3)
	extractBlock1_3Display.DiffuseColor = [0.0, 0.0, 0.0]
	extractBlock1_3Display.Opacity = 1.0

