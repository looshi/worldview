###
WorldView.Cube
  3D cube shaped object
###
class WorldView.Cube extends THREE.Mesh

  constructor: (options) ->
    {@lat, @long, amount, color, opacity} = options
    {girth, height, grow, scale} = options

    size = WorldView.getObjectGrowScale(options)
    geom = new THREE.BoxGeometry(size.x, size.y, size.z)

    for face in geom.faces
      face.color.setHex(color)

    super(geom)
