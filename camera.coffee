class Spec extends Spine.Model
  @configure 'Spec', 'fov', 'ratio', 'near', 'far'

  # Defaults

  fov: 45
  ratio: 4/3
  near: 1
  far: 5

class Camera extends Spine.Module
  @include Spine.Log
  trace: true
  logPrefix: '(Camera)'

  constructor: (spec = {}) ->

    #
    # Initialization
    #

    @spec = Spec.create(spec)

    #
    # Perspective matrix (p)
    #

    @persp = mat4.create()
    @setPers()
    @spec.bind('update', =>
      @log 'Spec has just changed!', @spec
      @setPers()
      @setModelViewPers()
    )

    #
    # ModelView matrix (mv)
    #

    @modelView = mat4.create()
    mat4.identity  @modelView

    #
    # ModelViewPerspective matrix (mvp)
    #

    @modelViewPersp = mat4.create()
    @setModelViewPers()

    @

  setPers: =>
    @log 'setPers'
    mat4.perspective(@spec.fov, @spec.ratio, @spec.near, @spec.far, @persp)

    @

  setModelViewPers: ->
    @log 'setModelViewPers'
    mat4.multiply(@modelView, @persp, @modelViewPersp)

    @

  translate: (x, y, z) ->
    mat4.translate @modelView, [x, y, z]

  rotate: (val, vecX, vecY, vecZ) ->
    mat4.rotate @modelView, val, [vecX, vecY, vecZ]

  scale: (x, y, z) ->
    mat4.scale @modelView, [x, y, z]

  print: ->
    @log @constructor.toCSSMatrix(@modelViewPersp)

  @toCSSMatrix: do =>
    epsilon = (x) -> if Math.abs(x) < 1e-6 then 0 else x

    (matrix) ->
      "matrix3d(#{(epsilon(i) for i in matrix).join(',')})"

@Camera = Camera
module?.exports = exports