jQuery ->
  new CarrierWaveCropper()

class CarrierWaveCropper
  constructor: ->
    $('#merchandises_merchpic_cropbox').Jcrop
      aspectRatio: 1
      setSelect: [0, 0, 200, 200]
      onSelect: @update
      onChange: @update

  update: (coords) =>
    $('#merchandises_merchpic_crop_x').val(coords.x)
    $('#merchandises_merchpic_crop_y').val(coords.y)
    $('#merchandises_merchpic_crop_w').val(coords.w)
    $('#merchandises_merchpic_crop_h').val(coords.h)
    @updatePreview(coords)

  updatePreview: (coords) =>
    $('#merchandises_merchpic_previewbox').css
      width: Math.round(100/coords.w * $('#merchandises_merchpic_cropbox').width()) + 'px'
      height: Math.round(100/coords.h * $('#merchandises_merchpic_cropbox').height()) + 'px'
      marginLeft: '-' + Math.round(100/coords.w * coords.x) + 'px'
      marginTop: '-' + Math.round(100/coords.h * coords.y) + 'px'
