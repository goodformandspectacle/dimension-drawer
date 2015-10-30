# dimension-drawer
This is a tool to show a 3D drawing of a physical thing alongside tennis ball for scale. 

Developed as part of our work for the British Museum, we made a thing that shows viewers the size of all the objects in a special collection held there, called the Waddesdon Bequest. We drew a representation of each object as a 3D shape, and added what we thought was a relatively universal object -- a tennis ball -- alongside, so people can get a feel for its size.

You can see it working here: http://wb.britishmuseum.org/by_volume

![Example of Drawn Dimensions](https://raw.githubusercontent.com/goodformandspectacle/dimension-drawings/master/dimensions-example.jpg)

(We've had a feature request from New Zealand to swap the tennis ball for a rugby ball. Let's see who wins the World Cup!) :)

## Install

You can install the Gem from the command line with:

```bundle install dimension_drawer```

Or if using Bundler, specify the Gem in your Gemfile, and run `bundle install`.

```gem 'dimension_drawer',  '~>1.0'```

## Usage

First require the gem, then initialize the object using the params `height`, `width`, `depth`, `view_width`, `view_height`, in that order. The first three refer to the dimensions of the real-world object, and should be specified in centimetres. The last two refer to the required dimensions of the SVG output – the scale doesn't really matter, but the aspect ratio between these two numbers is important.

To render the SVG, call `.cabinet_projection` method. This takes an optional `angle` param, but the default of 45 degrees is traditional.

```DimensionDrawer.new(435.41, 341.40, 102.4, 400, 320).cabinet_projection```

By default, units will be included within the SVG, but these can be turned off within an options hash:

```DimensionDrawer.new(435.41, 341.40, 102.4, 400, 320, {exlclude_units: true}).cabinet_projection```

## Styling

The SVG element has a class of `dimension-view`, the cube wireframe elements have a class of `edge` and the tennis ball has a class of `tennis-ball`. You can use these to style the SVG with CSS.

## Contributing

There are lots of ways this code could be improved, and more features that could be added. If you have particular requirements, get in touch – we’re curious to see how this code might be used.

You can contribute directly by forking the repository and submitting a Pull Request.
