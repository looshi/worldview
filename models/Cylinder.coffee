###
WorldView.Cylinder
  Cylinder shaped object
###
class WorldView.Cylinder extends THREE.Mesh

  constructor: (options) ->
    {@lat, @long, amount, color, opacity} = options
    {girth, height, grow, scale} = options

    size = WorldView.getObjectGrowScale(options)
    geom = new THREE.CylinderGeometry(size.x, size.y, size.z, 20)

    geom.applyMatrix(new THREE.Matrix4().makeRotationX(THREE.Math.degToRad(90)))

    for face in geom.faces
      face.color.setHex(color)

    super(geom)
