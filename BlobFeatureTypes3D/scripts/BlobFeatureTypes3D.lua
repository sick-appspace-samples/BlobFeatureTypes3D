-- Loading helper decorations and functions, see Helpers.lua
local helper = require('Helpers')
--------------------------------------------------------
-- Area
--------------------------------------------------------
--@area(heightMap:Image, intensityMap:Image, plane:Shape, region:Image.PixelRegion) 
local function area(heightMap, intensityMap, plane, region)
  helper.viewer3D:clear()
  helper.viewer2D:clear()
  
  local iconicId = helper.viewer3D:addHeightmap({heightMap, intensityMap}, helper.imgDecoration, {"Reflectance"})
  local iconicId2D = helper.viewer2D:addImage(heightMap, helper.imgDecoration)
  
  -- Finding blobs
  local objectRegion
  if region == nil then -- Use full image
    objectRegion = heightMap:thresholdPlane(4, 25, plane)
  else -- Use the defined region
    objectRegion = heightMap:thresholdPlane(1, 25, plane, region)
  end
  
  local blobs = objectRegion:findConnected(100) -- at least 100 px

  -- Analyzing each blob and visualizing the result
  for i = 1, #blobs do
    local feature = blobs[i]:getArea(heightMap)
    local cog = blobs[i]:getCenterOfGravity(heightMap)

    -- Graphics
    helper.viewer2D:addPixelRegion(blobs[i], helper.decRectangles, nil, iconicId2D)
    helper.viewer3D:addPixelRegion(blobs[i], helper.decRectangles, nil, iconicId)
    helper.featureText(cog:getX(),cog:getY(),heightMap:getMax(blobs[i]), "Area = "..helper.round(feature,2).." mm^2", iconicId, iconicId2D)
  end
  helper.viewer3D:present()
  helper.viewer2D:present()
end

--------------------------------------------------------
-- Centroid
--------------------------------------------------------
--@centroid(heightMap:Image, intensityMap:Image, plane:Shape)
local function centroid(heightMap, intensityMap, plane)
  helper.viewer3D:clear()
  helper.viewer2D:clear()
  
  local iconicId = helper.viewer3D:addHeightmap({heightMap, intensityMap}, helper.imgDecoration, {"Reflectance"})
  local iconicId2D = helper.viewer2D:addImage(heightMap, helper.imgDecoration)
  
  -- Finding blobs
  local objectRegion = heightMap:thresholdPlane(4, 50, plane)
  local blobs = objectRegion:findConnected(100) -- at least 100 px

  -- Analyzing each blob and visualizing the result
  for i = 1, #blobs do
    local feature = blobs[i]:getCenterOfGravity(heightMap)
    local z = heightMap:getMax(blobs[i])
    
    -- Graphics
    helper.viewer2D:addShape(feature, helper.pointDecoration2D, nil, iconicId2D)
    feature = Point.create(feature:getX(), feature:getY(), z)
    helper.viewer3D:addShape(feature, helper.pointDecoration3D, nil, iconicId)

    local strg = "COG = ("..helper.round(feature:getX(),2) ..","..helper.round(feature:getY(),2)..")"
    helper.featureText(feature:getX(), feature:getY()+2, z, strg, iconicId, iconicId2D)
  end
  helper.viewer3D:present()
  helper.viewer2D:present()
end

--------------------------------------------------------
-- Elongation
--------------------------------------------------------
--@elongation(heightMap:Image, intensityMap:Image, plane:Shape)
local function elongation(heightMap, intensityMap, plane)
  helper.viewer3D:clear()
  helper.viewer2D:clear()
  local iconicId = helper.viewer3D:addHeightmap({heightMap, intensityMap},helper.imgDecoration, {"Reflectance"})
  local iconicId2D = helper.viewer2D:addImage(heightMap, helper.imgDecoration)
  
  -- Finding blobs
  local objectRegion = heightMap:thresholdPlane(4, 50, plane)
  local blobs = objectRegion:findConnected(100) -- at least 100 px

  -- Analyzing each blob and visualizing the result
  for i = 1, #blobs do
    local feature = blobs[i]:getElongation(heightMap)
    -- Visualize a bounding box ahelper.round each object
    local box = blobs[i]:getBoundingBoxOriented(heightMap)
    local center, _, _, _ = box:getRectangleParameters()
    local z = heightMap:getMax(blobs[i])
 
    -- Graphics
    helper.viewer2D:addShape(box, helper.lineDecoration2D, nil, iconicId2D)
    box = Shape.toShape3D(box, Transform.createTranslation3D(0,0,z))
    helper.viewer3D:addShape(box, helper.lineDecoration3D, nil, iconicId)
    helper.featureText(center:getX(), center:getY(), z,  "E = "..helper.round((feature*10)/10,2), iconicId, iconicId2D)
  end
  helper.viewer3D:present()
  helper.viewer2D:present()
end

--------------------------------------------------------
-- Convexity
--------------------------------------------------------
--@convexity(heightMap:Image, intensityMap:Image, plane:Shape, region:Image.PixelRegion)
local function convexity(heightMap, intensityMap, plane,region)
  helper.viewer3D:clear()
  helper.viewer2D:clear()
  
  local iconicId = helper.viewer3D:addHeightmap({heightMap, intensityMap},helper.imgDecoration, {"Reflectance"})
  local iconicId2D = helper.viewer2D:addImage(heightMap, helper.imgDecoration)
  
  -- Finding blobs
  local objectRegion
  if region == nil then --- Use full image
    objectRegion = heightMap:thresholdPlane(0.5, 25, plane)
  else -- Use the defined region
    objectRegion = heightMap:thresholdPlane(0.5, 25, plane, region)
  end
  
  local blobs = objectRegion:findConnected(100) -- at least 100 px

  -- Analyzing each blob and visualizing the result
  for i = 1, #blobs do
    local feature = blobs[i]:getConvexity()
    local box = blobs[i]:getBoundingBoxOriented(heightMap)
    local center, _, _, _ = box:getRectangleParameters()
    local z = heightMap:getMax(blobs[i])
        
    -- Graphics
    helper.viewer3D:addPixelRegion(blobs[i],helper.regionDecoration, nil, iconicId)
    helper.viewer2D:addPixelRegion(blobs[i],helper.regionDecoration, nil, iconicId2D)
    helper.featureText(center:getX(), center:getY(), z, "C = "..helper.round((feature*10)/10,2), iconicId, iconicId2D)
  end
  helper.viewer3D:present()
  helper.viewer2D:present()
end

--------------------------------------------------------
-- Compactness
--------------------------------------------------------
--@compactness(heightMap:Image, intensityMap:Image, plane:Shape)
local function compactness(heightMap, intensityMap, plane)
  helper.viewer3D:clear()
  helper.viewer2D:clear()
  local iconicId = helper.viewer3D:addHeightmap({heightMap, intensityMap},helper.imgDecoration, {"Reflectance"})
  local iconicId2D = helper.viewer2D:addImage(heightMap, helper.imgDecoration)
  
  -- Finding blobs
  local objectRegion = heightMap:thresholdPlane(1, 50, plane)
  local blobs = objectRegion:findConnected(100) -- at least 100 px
  
  -- Analyzing each blob and visualizing the result
  for i = 1, #blobs do
    local feature = blobs[i]:getCompactness(heightMap)
    local box = blobs[i]:getBoundingBoxOriented(heightMap)
    local center, _, _, _ = box:getRectangleParameters()
    local z = heightMap:getMax(blobs[i])
    local border = blobs[i]:getBorderRegion()
    border = border:dilate(5)
    
     -- Graphics
    helper.viewer3D:addPixelRegion(blobs[i],helper.regionDecoration, nil, iconicId)
    helper.viewer3D:addPixelRegion(border,helper.borderDecoration, nil, iconicId)
    helper.viewer2D:addPixelRegion(blobs[i],helper.regionDecoration, nil, iconicId2D)
    helper.viewer2D:addPixelRegion(border,helper.borderDecoration, nil, iconicId2D)
    helper.featureText(center:getX(), center:getY(), z, "C = "..math.floor(feature*100)/100, iconicId, iconicId2D)
  end
  helper.viewer3D:present()
  helper.viewer2D:present()
end

--------------------------------------------------------
-- Perimeter length
--------------------------------------------------------
--@perimeterLength(heightMap:Image, intensityMap:Image, plane:Shape)
local function perimeterLength(heightMap, intensityMap, plane)
  helper.viewer3D:clear()
  helper.viewer2D:clear()
  
  local iconicId = helper.viewer3D:addHeightmap({heightMap, intensityMap},helper.imgDecoration, {"Reflectance"})
  local iconicId2D = helper.viewer2D:addImage(heightMap, helper.imgDecoration)
  
  -- Finding blobs
  local objectRegion = heightMap:thresholdPlane(1, 50, plane)
  objectRegion = objectRegion:fillHoles()
  local blobs = objectRegion:findConnected(100)-- at least 100 px

  -- Analyzing each blob and visualizing the result
  for i = 1, #blobs do
    local feature = blobs[i]:getPerimeterLength(heightMap)
    local border = blobs[i]:getBorderRegion()
    border = border:dilate(5)
    local box = blobs[i]:getBoundingBoxOriented(heightMap)
    local center, _, _, _ = box:getRectangleParameters()
    local z = heightMap:getMax(blobs[i])

    -- Graphics
    helper.viewer3D:addPixelRegion(border,helper.borderDecoration, nil, iconicId)
    helper.viewer2D:addPixelRegion(border,helper.borderDecoration, nil, iconicId2D)
    helper.featureText(center:getX(), center:getY(),z, "P = "..helper.round(feature,2), iconicId, iconicId2D)
  end
  helper.viewer3D:present()
  helper.viewer2D:present()
end

--------------------------------------------------------
-- Convex hull
--------------------------------------------------------
--@convexHull(heightMap:Image, intensityMap:Image, plane:Shape)
local function convexHull(heightMap, intensityMap, plane)
  helper.viewer3D:clear()
  helper.viewer2D:clear()
  
  local iconicId = helper.viewer3D:addHeightmap({heightMap, intensityMap},helper.imgDecoration, {"Reflectance"})
  local iconicId2D = helper.viewer2D:addImage(heightMap, helper.imgDecoration)

  -- Finding blobs
  local objectRegion = heightMap:thresholdPlane(4, 50, plane)
  local blobs = objectRegion:findConnected(100)

  -- Analyzing each blob and visualizing the result
  for i = 1, #blobs do
    local feature = blobs[i]:getConvexHull()
    
    -- Graphics
    helper.viewer3D:addPixelRegion(feature,helper.regionDecoration, nil, iconicId)
    helper.viewer2D:addPixelRegion(feature,helper.regionDecoration, nil, iconicId2D)
  end
  helper.viewer3D:present()
  helper.viewer2D:present()
end

--------------------------------------------------------
-- Counting holes
--------------------------------------------------------
--@countHoles(heightMap:Image, intensityMap:Image, plane:Shape)
local function countHoles(heightMap, intensityMap, plane)
  helper.viewer3D:clear()
  helper.viewer2D:clear()
  
  local iconicId = helper.viewer3D:addHeightmap({heightMap, intensityMap},helper.imgDecoration, {"Reflectance"})
  local iconicId2D = helper.viewer2D:addImage(heightMap, helper.imgDecoration)

  -- Finding blobs
  local objectRegion = heightMap:thresholdPlane(4.5, 50, plane)
  local blobs = objectRegion:findConnected(100)

  -- Analyzing each blob and visualizing the result
  for i = 1, #blobs do
    local objectNoHoles = blobs[i]:fillHoles()
    local objectHoles = objectNoHoles:getDifference(blobs[i])
    local feature = blobs[i]:countHoles()
    local center = blobs[i]:getCenterOfGravity(heightMap)
    local z = heightMap:getMax(blobs[i])
    
    -- Graphics
    helper.viewer3D:addPixelRegion(objectHoles,helper.regionDecoration, nil, iconicId)
    helper.viewer2D:addPixelRegion(objectHoles,helper.regionDecoration, nil, iconicId2D)
    helper.featureText(center:getX(), center:getY(),z, "# = "..feature, iconicId, iconicId2D)
  end
  helper.viewer3D:present()
  helper.viewer2D:present()
end

--------------------------------------------------------
-- Orientation (principal axes)
--------------------------------------------------------
--@orientation(heightMap:Image, intensityMap:Image, plane:Shape)
local function orientation(heightMap, intensityMap, plane)
  helper.viewer3D:clear()
  helper.viewer2D:clear()
  
  local iconicId = helper.viewer3D:addHeightmap({heightMap, intensityMap},helper.imgDecoration, {"Reflectance"})
  local iconicId2D = helper.viewer2D:addImage(heightMap, helper.imgDecoration)

  -- Finding blobs
  local objectRegion = heightMap:thresholdPlane(4.5, 50, plane)
  local blobs = objectRegion:findConnected(100)

  -- Analyzing each blob and visualizing the result
  for i = 1, #blobs do
    local angle, major, minor = blobs[i]:getPrincipalAxes(heightMap)
    local center = blobs[i]:getCenterOfGravity(heightMap)
    local z = heightMap:getMax(blobs[i])
    
    -- Plotting major axis
    local x = center:getX() + major*math.cos(angle)
    local y = center:getY() + major*math.sin(angle)
    local endpointMajor = Point.create(x,y,z)
    local majorAxis = Shape3D.createLineSegment(Point.create(center:getX(), center:getY(), z),endpointMajor)
    local majorAxis2D = Shape.createLineSegment(center, Point.create(endpointMajor:getX(), endpointMajor:getY()))
    helper.viewer3D:addShape(majorAxis,helper.lineDecoration3D, nil, iconicId)
    helper.viewer2D:addShape(majorAxis2D,helper.lineDecoration2D, nil, iconicId2D)
    
    -- Plotting minor axis
    x = center:getX() + minor*math.cos(angle+math.pi/2)
    y = center:getY() + minor*math.sin(angle+math.pi/2)
    local endpointMinor = Point.create(x,y,z)
    local minorAxis = Shape3D.createLineSegment(Point.create(center:getX(), center:getY(), z),endpointMinor)
    local minorAxis2D = Shape.createLineSegment(center, Point.create(endpointMinor:getX(), endpointMinor:getY()))
    helper.viewer3D:addShape(minorAxis,helper.lineDecoration3D, nil, iconicId)
    helper.viewer2D:addShape(minorAxis2D,helper.lineDecoration2D, nil, iconicId2D)
    
    -- Printing feature value
    helper.featureText(center:getX(), center:getY(), z, "Deg = "..helper.round((math.deg(angle)*10)/10,2), iconicId, iconicId2D)
  end
  helper.viewer3D:present()
  helper.viewer2D:present()
end

--End of Function and Event Scope--------------------------------------------------

--Returning local functions
local fnc = {}
fnc.area = area
fnc.centroid = centroid
fnc.elongation = elongation
fnc.convexity = convexity
fnc.compactness = compactness
fnc.perimeterLength = perimeterLength
fnc.convexHull = convexHull
fnc.countHoles = countHoles
fnc.orientation = orientation
return fnc
