class Cameras extends Spine.Controller
  constructor: ->
    super

    # instantiate a camera object
    @cam = new Camera(@spec)

    # GUI
    gui = new dat.GUI()

    spec = gui.addFolder('spec')
    for k, v of @cam.spec.attributes() when k isnt 'id'
      spec
        .add(@cam.spec, k)
        .onChange((val) =>
          @cam.spec.updateAttribute(k, val)
        )
    gui.add(@cam, 'print')

cam1 = new Cameras(el: $('#world1'))
cam2 = new Cameras(
  el: $('#world2')
  spec:
    fov: 30
    far: 10
)

# Export
@cam1 = cam1
module?.exports = cam1

@cam2 = cam2
module?.exports = cam2