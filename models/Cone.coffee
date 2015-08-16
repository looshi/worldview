###
WorldView.Cone
  Cone shaped object
###
class WorldView.Cone extends THREE.Mesh

  constructor: (options) ->
    {@lat, @long, amount, color, opacity} = options
    {girth, height, grow, scale} = options

    size = WorldView.getObjectGrowScale(options)
    geom = new THREE.CylinderGeometry(0, size.y, size.z, 20)

    geom.applyMatrix(new THREE.Matrix4().makeRotationX(THREE.Math.degToRad(90)))

    for face in geom.faces
      face.color.setHex(color)

    super(geom)
