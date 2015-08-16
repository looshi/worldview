# ----------  WorldView Constants -------------------- #

WorldView.CUBE = 'cube'
WorldView.CYLINDER = 'cylinder'
WorldView.SPHERE = 'sphere'
WorldView.CONE = 'cone'
WorldView.PIN = 'pin'
WorldView.FLAG = 'flag'
WorldView.WIDTH = 'width'
WorldView.HEIGHT = 'height'
WorldView.BOTH = 'both'
WorldView.EARTH_RADIUS = 100

###*
 * @class WorldView.World
 * @description 3D model of the earth with lat/long data representations
 *
 * world = WorldView.World(options)
 *
 * @param {Object} options object
 *
 * - `renderTo` : String dom node selector to append the world to
 * - `earthImagePath` : String path to the earth image texture (optional)
 * - `backgroundColor`: Number hex value for the background color
 * - `series` : Array Array of series data objects
 *
 *
###
class WorldView.World

  VECTOR_ZERO = new THREE.Vector3()  # 0,0,0 point
  DEFAULT_TEXTURE = '/packages/looshi_worldview/assets/earthmap4k.jpg'

  constructor: (options = {}) ->
    # options setup
    @earthImagePath = options.earthImagePath ? DEFAULT_TEXTURE
    @domNode = options.renderTo ? null
    @backgroundColor = options.backgroundColor ? 0x000000
    @series = options.series ? []

    # renderer setup
    @renderer = new THREE.WebGLRenderer(antialias:true)
    @renderer.shadowMapEnabled = true
    @renderer.autoClear = false
    @renderer.setClearColor(@backgroundColor, 1)
    @mainScene = new THREE.Scene()
    @zScene = new THREE.Scene()      # zScene renders above mainScene
    @pins = []
    @flags = []
    @camera = null
    @controls = null
    @earthParent = null
    @earth = null

    # geometry which merge objects are merged to
    @surfaceGeom = new THREE.Geometry()

    if @domNode
      @renderTo( $(@domNode) )
    @addSeriesObjects(@series)

  ###
  * Renders the scene.  Applies proportional scaling Flag and Pin objects.
  * @method renderCameraMove
  ###
  renderCameraMove : =>
    # scale pins and flags inversely proportional to zoom
    zoomScale = .006 * @camera.position.distanceTo(VECTOR_ZERO)

    for pin in @pins
      pin.scale.set(zoomScale, zoomScale, zoomScale)

    for flag in @flags
      # manually hide flags when they go behind earth when
      # the angle at Vector Zero for the triangle flag,0,camera > 90 degrees
      a = WorldView.getDistance(@camera.position, flag.position)
      b = WorldView.getDistance(flag.position, VECTOR_ZERO)
      c = WorldView.getDistance(@camera.position, VECTOR_ZERO)
      Angle = (b*b + c*c - a*a) / (2*b*c)
      # hide around 1.2 radians ( trial and error, 90 degrees = 1.57 radians)
      Angle = Math.acos(Angle)
      if Angle < 1.2
        flag.visible = true
        flag.scale.set(zoomScale, zoomScale, zoomScale)
        flag.setRotationFromQuaternion(@camera.quaternion)
      else
        flag.visible = false

    @renderScene()

  ###
  * Renders the scene.  Does not apply proportional scaling of flags or pins.
  *
  * Automatically called in all of the 'add' methods, addPin, addFlag, etc.
  * You only need to call this function if you are manually manipulating
  * the scene outside the API calls available.
  *
  * Example
  *
  * myCube = new THREE.Mesh( myGeometry, myMaterial );
  * myWorld.add( myCube );        // scene will be automatically rendered
  * myCube.position.set(3, 3, 3); // make some changes later
  * world.renderScene();          // now you'll need to call render
  * @method renderScene
  ###
  renderScene : ->
    @renderer.clear()
    @renderer.render(@mainScene, @camera)
    @renderer.clearDepth()
    @renderer.render(@zScene, @camera)

  addLighting : () ->
    ambientLight = new THREE.AmbientLight(0xcccccc)
    @camera.add( ambientLight )
    @zScene.add(ambientLight.clone())
    light = new THREE.DirectionalLight(0xffffff, .5)
    light.castShadow = true
    light.position.set(-300, 80, -100)
    light.castShadow  = true
    @zScene.add(light.clone())
    @camera.add(light)

  renderTo : (domNode) ->
    domNode.append( @renderer.domElement )
    dW = domNode.width()
    dH = domNode.height()
    @renderer.setSize(dW, dH)
    cameraFar = WorldView.EARTH_RADIUS * 6 # distance from camera to render
    @camera = new THREE.PerspectiveCamera(45, dW/dH, 1, cameraFar)
    @camera.position.z = WorldView.EARTH_RADIUS * 4
    @controls = new THREE.OrbitControls(@camera, domNode[0])
    @controls.damping = 0.2
    @controls.addEventListener('change', @renderCameraMove)
    @mainScene.add(@camera)
    @earthParent = new THREE.Group()
    @earth = new WorldView.Earth(@earthImagePath, @renderCameraMove)
    @earthParent.add(@earth)
    @mainScene.add(@earthParent)
    @addLighting()
    @renderCameraMove()
    return @earthParent

  ###
  * Sets the size of the renderer.
  * @method setSize
  * @param {Number} width
  * @param {Number} height
  * @return returns nothing
  ###
  setSize : (width, height) ->
    @camera.aspect = width / height
    @camera.updateProjectionMatrix()
    @renderer.setSize(width, height)
    @renderCameraMove()

  ###
  * Adds a 3D pin object at the given location.
  * @method addPin
  * @param {WorldView.ItemOptions} options
  * @return returns the 3D pin object.
  ###
  addPin : (options) ->
    pin = new WorldView.Pin(options)
    @pins.push(pin)
    @addToSurface(pin, options.lat, options.long)
    pin

  ###
  * @method getPin
  * @param {Number} latitude
  * @param {Number} longitude
  * @return returns the 3D pin object or null if no pin exists at this location.
  ###
  getPin : (lat, long) ->
    _.find @pins, (pin) ->
      pin.lat is lat and pin.long is long

  ###
  * Adds a flag object with text at the given location.
  * @method addFlag
  * @param {WorldView.ItemOptions} options
  * @return returns the 3D flag object.
  ###
  addFlag : (options) ->
    flag = new WorldView.Flag(options)
    @addToSurface(flag, options.lat, options.long, @zScene)
    @flags.push(flag)
    flag

  ###
  * Adds any 3D object to the surface of the earth.
  * Use this method if you need to retain interactivity or move the object
  * after it has been added to the scene.  This method returns the 3D object
  * instance for use later.
  * @method addToSurface
  * @param {THREE.Object3D} object THREE.Object3D object.
  * @param {Number} latitude
  * @param {Number} longitude
  * @return returns the 3D object.
  ###
  addToSurface : (obj, lat, long, scene) ->
    scene ?= @mainScene
    scene.add(obj)
    point = WorldView.latLongToVector3(lat, long)
    obj.position.set(point.x, point.y, point.z)
    @renderCameraMove()
    obj

  _mergeCube : (options) ->
    cube = new WorldView.Cube(options)
    @_mergeToSurface(cube, options.lat, options.long)
    cube

  _mergeCylinder : (options) ->
    cylinder = new WorldView.Cylinder(options)
    @_mergeToSurface(cylinder, options.lat, options.long)
    cylinder

  _mergeCone : (options) ->
    cone = new WorldView.Cone(options)
    @_mergeToSurface(cone, options.lat, options.long)
    cone

  ###
  * Merges mesh to the surface of the earth.
  * The object properties will no longer be editable.
  * @method _mergeToSurface
  * @param {THREE.Object3D} object
  * @param {Number} latitude
  * @param {Number} longitude
  * @return null
  ###
  _mergeToSurface : (obj, lat, long) ->

    {width, depth, radiusTop, height} = obj.geometry.parameters
    if depth # CUBE
      zOffset = depth/2 - WorldView.getObjectSurfaceOffset(width)
    else if radiusTop and height # CYLINDER
      zOffset = height/2 - WorldView.getObjectSurfaceOffset(radiusTop*2)

    point = WorldView.latLongToVector3(lat, long, zOffset)
    obj.position.set(point.x, point.y, point.z)

    WorldView.lookAwayFrom(obj, @earthParent)
    obj.updateMatrix()

    @surfaceGeom.merge(obj.geometry, obj.matrix)

    return null


  ###
  * Adds any 3D object to the scene.
  * @method add
  * @param {THREE.Object3D} object THREE.Object3D object.
  * @return returns nothing.
  ###
  add : (obj) ->
    @mainScene.add(obj)
    @renderCameraMove()

  ###
  * Removes 3D object from the scene.
  * @method remove
  * @param {THREE.Object3D} object THREE.Object3D object.
  * @return returns nothing.
  ###
  remove : (obj) ->
    @mainScene.remove(obj)
    # TODO call .dispose ()
    @renderCameraMove()

  ###
  * Adds data items to the surface.
  *
  * series objects are in the format :
  *
  * - `name` : String name of series
  * - `type` : String 3D object which represents each data item
  * - `color`: Number Color of 3D object
  * - `data`: Array of series.data Arrays
  *
  * series.data Arrays are in the format (order matters ) :
  *
  * - [latitude,
  * - longitude,
  * - amount(optional),
  * - color(optional),
  * - label (optional),
  *
  * @method addSeriesObjects
  * @param {Object} options.series object
  * @return returns nothing.
  ###
  addSeriesObjects : (series) ->
    LAT = 0
    LONG = 1
    COLOR = 2
    AMOUNT = 3
    LABEL = 4
    max = null
    min = null

    for s in series

      if Array.isArray(s.color)
        max = _.max(s.data, (item) -> return item[AMOUNT] )[AMOUNT]
        min = _.min(s.data, (item) -> return item[AMOUNT] )[AMOUNT]

      for data in s.data

        if data[COLOR]
          itemColor = data[COLOR]
        else if Array.isArray(s.color)
          percent = (data[AMOUNT]-min)/(max-min)
          itemColor = WorldView.blendColors(s.color[0], s.color[1], percent)
        else
          itemColor = s.color

        if typeof itemColor is 'string'
          itemColor = WorldView.stringToHex(itemColor)

        options = new WorldView.ItemOptions(
          lat : data[LAT]
          long : data[LONG]
          color : itemColor
          amount : data[AMOUNT]
          label : data[LABEL]
          opacity : s.opacity
          scale : s.scale
          grow : s.grow
          girth : s.girth
          height : s.height )

        switch s.type
          when WorldView.PIN then @addPin(options)
          when WorldView.FLAG then @addFlag(options)
          when WorldView.CUBE then @_mergeCube(options)
          when WorldView.CYLINDER then @_mergeCylinder(options)
          when WorldView.CONE then @_mergeCone(options)

    surfaceMaterial = new THREE.MeshLambertMaterial(
      {color: 0xffffff,
      shading: THREE.SmoothShading,
      vertexColors: THREE.VertexColors})

    surfaceMesh = new THREE.Mesh(@surfaceGeom, surfaceMaterial)
    @mainScene.add(surfaceMesh)
    @renderCameraMove()

  ###
  * Draws an arc between two coordinates on the earth.
  * @method add
  * @param {Number} fromLat
  * @param {Number} fromLong
  * @param {Number} toLat
  * @param {Number} toLong
  * @param {Number} color The color of the arc.
  * @return {WorldView.Arc} The arc object.
  ###
  addArc : (fromLat, fromLong, toLat, toLong, color) ->
    arc = new WorldView.Arc(fromLat, fromLong, toLat, toLong, color)
    @earthParent.add(arc)
    @renderScene()
    arc

  ###
  * Animates an object along an arc.
  * @method animateObjectOnArc
  * @param {WorldView.Arc} arc The Arc object to animate along.
  * @param {THREE.Object3D} object Object to move along arc.
  * @param {Number} duration Duration for the animation.
  * @return returns nothing.
  ###
  animateObjectOnArc = (arc, obj, duration) ->
    if not obj['positionOnArc']
      obj.positionOnArc = duration
    point = arc.getPoint(obj.positionOnArc)
    obj.position.set(point.x, point.y, point.z)
    obj.positionOnArc = obj.positionOnArc - 1
    if obj.positionOnArc > 0
      requestAnimationFrame () =>
        @animateObjectOnArc arc, obj
      @renderScene()
    else
      Meteor.setTimeout (=>
        @earthParent.remove(obj)
        @renderScene()
      ), 1000


# ----------  WorldView Helper Functions ------------- #

WorldView.latLongToVector3 = (lat, lon, height=0) ->
  radius = WorldView.EARTH_RADIUS
  phi = (lat)*Math.PI/180
  theta = (lon-180)*Math.PI/180
  x = -(radius+height) * Math.cos(phi) * Math.cos(theta)
  y = (radius+height) * Math.sin(phi)
  z = (radius+height) * Math.cos(phi) * Math.sin(theta)
  return new THREE.Vector3(x,y,z)

WorldView.getPointInBetween = (pointA, pointB, percentage) ->
  dir = pointB.clone().sub(pointA)
  len = dir.length()
  dir = dir.normalize().multiplyScalar(len*percentage)
  return pointA.clone().add(dir)

WorldView.getDistance = (pointA, pointB) ->
  dir = pointB.clone().sub(pointA)
  return dir.length()

WorldView.lookAwayFrom = (object, target) ->
  vector = new THREE.Vector3()
  vector.subVectors(object.position, target.position).add(object.position)
  object.lookAt(vector)

# calculates the distance of Objects bottom plane's edge to the earth
# used to position object so it does not just sit ontop as a tangent
# stack exchange description with image : http://bit.ly/1EiBj3O
WorldView.getObjectSurfaceOffset = (girth) ->
  r = WorldView.EARTH_RADIUS
  r - Math.sqrt(r*r-girth*girth/2)

WorldView.getObjectGrowScale = (options) ->
  {grow, girth, height, amount, scale} = options
  amount = amount * scale
  growScale = switch grow
    when WorldView.HEIGHT
      new THREE.Vector3(girth, girth, amount)
    when WorldView.WIDTH
      new THREE.Vector3(amount, amount, height)
    when WorldView.BOTH
      new THREE.Vector3(amount, amount, amount)
  growScale

# http://stackoverflow.com/questions/5560248/programmatically-lighten-or-darken-a-hex-color-or-rgb-and-blend-colors
WorldView.blendColors = (c0, c1, p) ->
    f = parseInt(c0.slice(1),16)
    t = parseInt(c1.slice(1),16)
    R1 = f>>16
    G1 = f>>8&0x00FF
    B1 = f&0x0000FF
    R2 = t>>16
    G2 = t>>8&0x00FF
    B2 = t&0x0000FF
    color = "0x"+(0x1000000+(Math.round((R2-R1)*p)+R1)*0x10000+(Math.round((G2-G1)*p)+G1)*0x100+(Math.round((B2-B1)*p)+B1)).toString(16).slice(1)
    color = Number(color)



WorldView.stringToHex = (color) ->
  color = color.substring(1)
  color = '0x' + color
  Number(color)



