Package.describe({
  summary : 'Displays a 3D model of the earth with latitude longitude points and arcs between them.',
  version : '0.1.0'
})

Package.onUse(function(api){
  api.use('templating','client');
  api.use('coffeescript','client');
  api.use('davidcittadini:three@0.71.12')

  api.add_files('assets/droid_sans_regular.typeface.js','client');

  api.export('WorldView');
  api.add_files('WorldView.js','client');
  api.add_files('models/Earth.coffee');
  api.add_files('models/Pin.coffee');
  api.add_files('models/Arc.coffee');
  api.add_files('models/Text.coffee');
  api.add_files('models/Flag.coffee');
  api.add_files('models/Cube.coffee');
  api.add_files('models/Cylinder.coffee');
  api.add_files('models/Cone.coffee');
  api.add_files('ItemOptions.coffee','client');
  api.add_files('WorldView.coffee','client');
  api.add_files('assets/earthmap4k.jpg','client');

})