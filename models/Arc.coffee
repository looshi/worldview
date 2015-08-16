###
WorldView.Arc
  Arc between two latitude/longitude points on the surface of Earth.
###
class WorldView.Arc extends THREE.Line

  constructor: (fromLat, fromLong, toLat, toLong, color) ->

    color ?= 0xffffff  # default to white if no color specified

    a = WorldView.latLongToVector3(fromLat, fromLong)
    b = WorldView.latLongToVector3(toLat, toLong)

    m1 = WorldView.getPointInBetween(a, b, .4)
    m2 = WorldView.getPointInBetween(a, b, .6)

    # extend offset higher if the points are further away
    offset =  Math.exp( .5 * WorldView.getDistance(a, b) )

    m1 = new THREE.Vector3(offset*m1.x, offset*m1.y, offset*m1.z)
    m2 = new THREE.Vector3(offset*m2.x, offset*m2.y, offset*m2.z)

    @curve = new THREE.CubicBezierCurve3(a, m1, m2, b )
    geometry = new THREE.Geometry()
    geometry.vertices = @curve.getPoints( 100 )
    material = new THREE.LineBasicMaterial(color: color,linewidth: 2, fog:true)

    super( geometry, material )

  getPoint: (percentDistance) ->
    @curve.getPoint(percentDistance / 100)
