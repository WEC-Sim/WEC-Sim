#### import the simple module from the paraview
from paraview.simple import *

body = GetActiveSource()
generateSurfaceNormals1 = GenerateSurfaceNormals(Input=body)
generateSurfaceNormals1.ComputeCellNormals = 1
cellCenters1 = CellCenters(Input=generateSurfaceNormals1)

scale = 0.0001
try:
	calculator1 = Calculator(Input=cellCenters1)
	calculator1.Function = 'Hydrostatic Pressure * Normals'
	calculator1.ResultArrayName = 'hydrostatic_pressure'
	glyph1 = Glyph(Input=calculator1, GlyphType='Arrow')
	glyph1.Scalars = ['POINTS', 'Cell Area']
	glyph1.Vectors = ['POINTS', 'hydrostatic_pressure']
	glyph1.ScaleMode = 'vector'
	glyph1.ScaleFactor = scale
	glyph1.GlyphMode = 'All Points'
	glyph1.GlyphType.Invert = 1
	glyph1Display = GetDisplayProperties(glyph1, view=renderView1)
	ColorBy(glyph1Display, ('POINTS', 'GlyphVector'))
	glyph1Display.RescaleTransferFunctionToDataRange(True)
	glyph1Display.SetScalarBarVisibility(renderView1, True)	
	Hide(glyph1, renderView1)
	RenameSource('calculator: hydrostatic_pressure', calculator1)
	RenameSource('glyph: hydrostatic_pressure', glyph1)
except:
	Delete(calculator1)
	del calculator1

try:
	calculator2 = Calculator(Input=cellCenters1)
	calculator2.Function = 'Wave Pressure Linear * Normals'
	calculator2.ResultArrayName = 'froude-krylov_pressure_linear'
	glyph2 = Glyph(Input=calculator2, GlyphType='Arrow')
	glyph2.Scalars = ['POINTS', 'Cell Area']
	glyph2.Vectors = ['POINTS', 'froude-krylov_pressure_linear']
	glyph2.ScaleMode = 'vector'
	glyph2.ScaleFactor = scale
	glyph2.GlyphMode = 'All Points'
	glyph2.GlyphType.Invert = 1
	glyph2Display = GetDisplayProperties(glyph2, view=renderView1)
	ColorBy(glyph2Display, ('POINTS', 'GlyphVector'))
	glyph2Display.RescaleTransferFunctionToDataRange(True)
	glyph2Display.SetScalarBarVisibility(renderView1, True)	
	Hide(glyph2, renderView1)
	RenameSource('calculator: froude-krylov_pressure_linear', calculator2)
	RenameSource('glyph: froude-krylov_pressure_linear', glyph2)
except:
	Delete(calculator2)
	del calculator2

try:
	calculator3 = Calculator(Input=cellCenters1)
	calculator3.Function = 'Wave Pressure NonLinear * Normals'
	calculator3.ResultArrayName = 'froude-krylov_pressure_non-linear'
	glyph3 = Glyph(Input=calculator3, GlyphType='Arrow')
	glyph3.Scalars = ['POINTS', 'Cell Area']
	glyph3.Vectors = ['POINTS', 'froude-krylov_pressure_non-linear']
	glyph3.ScaleMode = 'vector'
	glyph3.ScaleFactor = scale
	glyph3.GlyphMode = 'All Points'
	glyph3.GlyphType.Invert = 1
	glyph3Display = GetDisplayProperties(glyph3, view=renderView1)
	ColorBy(glyph3Display, ('POINTS', 'GlyphVector'))
	glyph3Display.RescaleTransferFunctionToDataRange(True)
	glyph3Display.SetScalarBarVisibility(renderView1, True)	
	Hide(glyph3, renderView1)
	RenameSource('calculator: froude-krylov_pressure_non-linear', calculator3)
	RenameSource('glyph: froude-krylov_pressure_non-linear', glyph3)
except:
	Delete(calculator3)
	del calculator3

try:
	calculator4 = Calculator(Input=cellCenters1)
	calculator4.Function = '(Hydrostatic Pressure + Wave Pressure NonLinear) * Normals'
	calculator4.ResultArrayName = 'total_pressure'
	glyph4 = Glyph(Input=calculator4, GlyphType='Arrow')
	glyph4.Scalars = ['POINTS', 'Cell Area']
	glyph4.Vectors = ['POINTS', 'total_pressure']
	glyph4.ScaleMode = 'vector'
	glyph4.ScaleFactor = scale
	glyph4.GlyphMode = 'All Points'
	glyph4.GlyphType.Invert = 1
	glyph4Display = GetDisplayProperties(glyph4, view=renderView1)
	ColorBy(glyph4Display, ('POINTS', 'GlyphVector'))
	glyph4Display.RescaleTransferFunctionToDataRange(True)
	glyph4Display.SetScalarBarVisibility(renderView1, True)	
	Hide(glyph4, renderView1)
	RenameSource('calculator: total_pressure', calculator4)
	RenameSource('glyph: total_pressure', glyph4)
except:
	Delete(calculator4)
	del calculator4


try:
	calculator5 = Calculator(Input=cellCenters1)
	calculator5.Function = '(Wave Pressure NonLinear - Wave Pressure Linear) * Normals'
	calculator5.ResultArrayName = 'froude-krylov_delta_pressure'
	glyph5 = Glyph(Input=calculator5, GlyphType='Arrow')
	glyph5.Scalars = ['POINTS', 'Cell Area']
	glyph5.Vectors = ['POINTS', 'froude-krylov_delta_pressure']
	glyph5.ScaleMode = 'vector'
	glyph5.ScaleFactor = scale
	glyph5.GlyphMode = 'All Points'
	glyph5.GlyphType.Invert = 1
	glyph5Display = GetDisplayProperties(glyph5, view=renderView1)
	ColorBy(glyph5Display, ('POINTS', 'GlyphVector'))
	glyph5Display.RescaleTransferFunctionToDataRange(True)
	glyph5Display.SetScalarBarVisibility(renderView1, True)	
	Hide(glyph5, renderView1)
	RenameSource('calculator: froude-krylov_delta_pressure', calculator5)
	RenameSource('glyph: froude-krylov_delta_pressure', glyph5)
except:
	Delete(calculator5)
	del calculator5

