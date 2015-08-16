

<!-- Start WorldView.coffee -->

##### WorldView.World

3D model of the earth with lat/long data representations
world = WorldView.World(options)

###### Params:

* **Object** *options* object
- `renderTo` : String dom node selector to append the world to
- `earthImagePath` : String path to the earth image texture (optional)
- `backgroundColor`: Number hex value for the background color
- `series` : Array Array of series data objects

##### renderCameraMove()

Renders the scene.  Applies proportional scaling to surface objects.

##### renderScene()

Renders the scene.  Does not apply proportional scaling of surface objects.

Automatically called in all of the 'add' methods, addPin, addFlag, etc.
You only need to call this function if you are manually manipulating
the scene outside the API calls available.

Example

myCube = new THREE.Mesh( myGeometry, myMaterial );
myWorld.add( myCube );        // scene will be automatically rendered
myCube.position.set(3, 3, 3); // make some changes later
world.renderScene();          // now you'll need to call render

##### addPin(options)

Adds a 3D pin object at the given location.

###### Params:

* **WorldView.ItemOptions** *options*

###### Return:

* returns the 3D pin object.

##### getPin(latitude, longitude)

###### Params:

* **Number** *latitude*
* **Number** *longitude*

###### Return:

* returns the 3D pin object or null if no pin exists at this location.

##### addFlag(options)

Adds a flag object with text at the given location.

###### Params:

* **WorldView.ItemOptions** *options*

###### Return:

* returns the 3D flag object.

##### addCube(options)

Adds a cube object at the given location.

###### Params:

* **WorldView.ItemOptions** *options*

###### Return:

* returns the 3D cube object.

##### addCylinder(options)

Adds a cylinder object at the given location.

###### Params:

* **WorldView.ItemOptions** *options*

###### Return:

* returns the 3D cube object.

##### addToSurface(object, latitude, longitude)

Adds any 3D object to the surface of the earth.

###### Params:

* **THREE.Object3D** *object* THREE.Object3D object.
* **Number** *latitude*
* **Number** *longitude*

###### Return:

* returns the 3D object.

##### add(object)

Adds any 3D object to the scene.

###### Params:

* **THREE.Object3D** *object* THREE.Object3D object.

###### Return:

* returns nothing.

##### remove(object)

Removes 3D object from the scene.

###### Params:

* **THREE.Object3D** *object* THREE.Object3D object.

###### Return:

* returns nothing.

##### addSeriesObjects(options.series)

Adds data items to the surface.

series objects are in the format :

- `name` : String name of series
- `type` : String 3D object which represents each data item
- `color`: Number Color of 3D object
- `data`: Array of series.data Arrays

series.data Arrays are in the format (order matters ) :

- [latitude,
- longitude,
- amount(optional),
- color(optional),
- label (optional),

###### Params:

* **Object** *options.series* object

###### Return:

* returns nothing.

##### add(fromLat, fromLong, toLat, toLong, color)

Draws an arc between two coordinates on the earth.

###### Params:

* **Number** *fromLat*
* **Number** *fromLong*
* **Number** *toLat*
* **Number** *toLong*
* **Number** *color* The color of the arc.

###### Return:

* returns nothing.

##### animateObjectOnArc(arc, object, duration)

Animates an object along an arc.

###### Params:

* **WorldView.Arc** *arc* The Arc object to animate along.
* **THREE.Object3D** *object* Object to move along arc.
* **Number** *duration* Duration for the animation.

###### Return:

* returns nothing.

<!-- End WorldView.coffee -->

