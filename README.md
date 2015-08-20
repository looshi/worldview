##### WorldView

Meteor package which renders a 3D globe with latitude longitude data points.

Uses Three.js

Checkout the examples here : [worldview.meteor.com](http://worldview.meteor.com/)

![worldview screenshot](https://cloud.githubusercontent.com/assets/1656829/9375901/f40351ec-46ba-11e5-9262-5f5d19ed0902.png "WorldView Screenshot")

##### Installation

$ meteor add looshi:worldview

##### Usage

Instantiate the world with a monolithic options object.  The options object is similar to Highcharts options -- it contains all the configuration for the world and objects, plus the series data points to plot.

```javascript
new WorldView.World(options);
```

##### WorldView Options Object

|option  | type | description |
| ------- | ---- | ------------ |
| renderTo  | String| dom node selector to append the world to, '#myDiv' |
| earthImagePath  | String | path to the earth image texture (optional), defaults to the image shown above. |
| backgroundColor  | String | background color |
| series  | Array |  Array of Series Options Objects, see below |

##### Series Options Object
| option  | type | description |
| ------- | ---- | ------------ |
| name  | String| name of series  ( optional ) , currently does nothing, eventually may be part of a legend.|
| type  | String | 3D object.  Available objects are : WorldView.CUBE, WorldView.CYLINDER, WorldView.PIN, WorldView.FLAG, WorldView.CONE |
| color  | String or Array | color ( optional).  If an array is used the color for each object will be a gradient value between the provided colors based on the data amount.  e.g. ['#ff0000','#'0000ff'] Will color objects lower amount closer to red and higher amount closer to blue.  ( optional )|
| scale  | Number | Multiplier applied to each data point's amount.  ( optional )|
| grow | String |  WorldView.HEIGHT - object height increases, WorldView.WIDTH - object width increases, WorldView.BOTH - object width and height increase.   ( optional )|
| girth  | Number | If grow = WorldView.HEIGHT, girth defines each object's girth.  ( optional )|
| height | Number | If grow = WorldView.WIDTH, height defined each object's height.  ( optional )|
| opacity | Number | Number from zero to 1.  Currently only Flags and pins support opacity.  ( optional )|
| data  | Array |  Array of Series Data Arrays, see below |

##### Series Data Array

Array which represents a single data point.  Order matters.

```javascript
[latitude,longitude,amount,color,label]
```
##### Series Data Array
| index | name | type | description |
| ----- | ---- | ---- | ------------ |
| 0  | latitude | Number | The latitude. |
| 1  | longitude | Number | The longitude. |
| 2  | amount | Number | The value for this data point. |
| 3  | color | Number | This will override the color specified in Series Options.  ( optional ) |
| 4  | label | Number | Text that appears, currently only used in WorldView.FLAG objects. |

