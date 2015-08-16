###
WorldView.Flag
  Flag shape with text on it.
###

class WorldView.Flag extends THREE.Group

  constructor: (options) ->
    {@lat, @long, color, opacity, label} = options

    text = new WorldView.Text(label, 0xffffff, false, .0001)

    padding = .4  # adds padding around the text inside the rectangle
    rectW = text.width + (padding * 2.5)
    rectH = text.height + (padding * 2)
    flagH = 1
    flagW = .5

    flagShape = new THREE.Shape()
    flagShape.moveTo(0, 0)
    flagShape.lineTo(0, flagH+rectH)
    flagShape.lineTo(rectW, flagH+rectH)
    flagShape.lineTo(rectW, flagH)
    flagShape.lineTo(flagW, flagH)
    flagShape.lineTo(0, 0)

    points = flagShape.createPointsGeometry()
    geometry = new THREE.ShapeGeometry(flagShape)
    sMat = new THREE.MeshPhongMaterial({color: color, side: THREE.DoubleSide})
    shapeMesh = new THREE.Mesh(geometry,sMat)
    sMat.transparent = true
    sMat.opacity = opacity

    super()
    @add(shapeMesh)
    @add(text)
    shapeMesh.position.set(0,0,.01)
    text.position.set(padding, flagH+padding, 0.02)
