###
WorldView.Text
  extruded 3d text
###
class WorldView.Text extends THREE.Group

  constructor: (text, color, bevel, thickness, center) ->
    @width = 1
    @height = 1
    @color = color
    color ?= 0xff0000
    flat = THREE.FlatShading
    smooth = THREE.SmoothShading
    mat = new THREE.MeshFaceMaterial([
      new THREE.MeshPhongMaterial({ color: 0xffffff, shading: flat }),
      new THREE.MeshPhongMaterial({ color: color, shading: smooth })
    ])

    options =
      size: 1
      height: thickness ?= 1
      curveSegments: 10
      font: 'droid sans'
      weight: 'normal'
      style: 'normal'
      bevelThickness: .01
      bevelSize: .01
      bevelEnabled: bevel ?= true
      material: 0
      extrudeMaterial: 1

    geom = new THREE.TextGeometry text, options

    geom.computeBoundingBox()
    geom.computeVertexNormals()
    @width = geom.boundingBox.max.x - geom.boundingBox.min.x
    @height = geom.boundingBox.max.y - geom.boundingBox.min.y
    text = new THREE.Mesh(geom, mat)
    text.frustumCulled = false

    if center
      xOffset = -0.5 * @width
      yOffset = -0.5 * @height
      text.position.set(xOffset, yOffset, 0)

    super()
    @add text
