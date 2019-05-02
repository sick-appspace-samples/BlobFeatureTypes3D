--[[----------------------------------------------------------------------------

  Application Name:
  BlobFeatureTypes3D

  Description:
  Extracting and visualizing common blobs features on a height map.

  How to Run:
  Starting this sample is possible either by running the app (F5) or
  debugging (F7+F10). Setting a breakpoint on the first row inside the 'main'
  function allows debugging step-by-step after the 'Engine.OnStarted' event.
  Results can be seen in the image viewer on the DevicePage, either with a 3D
  visualization or a 2D visualization.
  Restarting the Sample may be necessary to show images after loading the webpage.
  To run this sample a device with AppEngine >= V2.5.0 and the relevant algorithms
  is necessary. For example TriSpectorP with latest firmware. Alternatively the
  Emulator on AppStudio 2.3 or higher can be used.

  More Information:
  Tutorial "Algorithms - Blob Analysis".

------------------------------------------------------------------------------]]

-- Loading helper decorations and functions, see Helpers.lua
local helpers = require('Helpers')

-- Loading featureType functions, see BlobFeatureTypes3D.lua
local types = require('BlobFeatureTypes3D')

--Start of Global Scope---------------------------------------------------------
print('AppEngine Version: ' .. Engine.getVersion())

local DELAY = 2000 -- ms between each type for demonstration purpose

--End of Global Scope-----------------------------------------------------------

--Start of Function and Event Scope---------------------------------------------

-- Looping through the functions
local function main()
  -- Load image from resources
  local images = Object.load('resources/image.json')
  local heightMap = images[1]
  local intensityMap = images[2]

  local plane = helpers.getReferencePlane(heightMap, nil)

  -- Blob inspections---------------------------
  types.area(heightMap, intensityMap, plane)
  Script.sleep(DELAY) -- for demonstration purpose only
  types.centroid(heightMap, intensityMap, plane)
  Script.sleep(DELAY) -- for demonstration purpose only
  types.elongation(heightMap, intensityMap, plane)
  Script.sleep(DELAY) -- for demonstration purpose only
  types.convexity(heightMap, intensityMap, plane)
  Script.sleep(DELAY) -- for demonstration purpose only
  types.compactness(heightMap, intensityMap, plane)
  Script.sleep(DELAY) -- for demonstration purpose only
  types.perimeterLength(heightMap, intensityMap, plane)
  Script.sleep(DELAY) -- for demonstration purpose only
  types.convexHull(heightMap, intensityMap, plane)
  Script.sleep(DELAY) -- for demonstration purpose only
  types.countHoles(heightMap, intensityMap, plane)
  Script.sleep(DELAY) -- for demonstration purpose only
  types.orientation(heightMap, intensityMap, plane)
  Script.sleep(DELAY) -- for demonstration purpose only

  -- Area on slope
  local slopeRegion = helpers.findSlopeRegion(heightMap, plane)
  local slope = helpers.getReferencePlane(heightMap, slopeRegion)
  types.area(heightMap, intensityMap, slope, slopeRegion)
  Script.sleep(DELAY) -- for demonstration purpose only
  types.convexity(heightMap, intensityMap, slope, slopeRegion)

  print('App finished.')
end
Script.register('Engine.OnStarted', main)
