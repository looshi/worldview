###
WorldView.Earth
  3D model of the Earth with image texture.
  doneLoading callback is invoked after the image texture is loaded
###

class WorldView.Earth
  constructor: (imagepath, doneLoading) ->
    @earthGeometry = new THREE.SphereGeometry(WorldView.EARTH_RADIUS, 64, 64)
    @earthMaterial = new THREE.MeshPhongMaterial()
    @earthMaterial.map = THREE.ImageUtils.loadTexture(
      imagepath,
      THREE.UVMapping,
      doneLoading )
    #@earthMaterial.transparent = true
    #@earthMaterial.opacity = .7
    @earth = new THREE.Mesh( @earthGeometry, @earthMaterial )
    return @earth
