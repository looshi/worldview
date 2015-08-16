###
WorldView.Pin
  Sphere shape.  TODO : make a tear drop shape.
###
class WorldView.Pin extends THREE.Mesh

  constructor: (options) ->
    {@lat, @long, color, opacity} = options
    # TODO make this a tear drop shape
    # possible solution : http://codepen.io/mjkaufer/pen/doQpLj
    geom = new THREE.SphereGeometry(1, 16, 16)
    mat = new THREE.MeshPhongMaterial( { color: color } )
    mat.transparent = true
    mat.opacity = opacity
    super( geom, mat )
