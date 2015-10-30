
class DimensionDrawer

  def initialize(height, width, depth, view_width, view_height, options = {})
    @height = height
    @width = width
    @depth = depth
    @view_height = view_height
    @view_width = view_width
    @scale = options[:scale]
    @exclude_units = options[:exclude_units]
  end

  def cabinet_projection(angle = 45)

    margin = 20

    # This is an artificial number which approximates perspective.
    depth_scale = 0.5

    scaled_depth = @depth * depth_scale

    lines = []

    total_height = @height + height_given_angle_and_hyp(angle, scaled_depth)
    total_width = @width + width_given_angle_and_hyp(angle, scaled_depth) + 6.7

    height_scale = (@view_height - (margin * 2)) / total_height
    width_scale = (@view_width - (margin * 2)) / total_width

    calculated_scale = [height_scale, width_scale].min

    if @scale.is_a? Float
      scale = @scale
    elsif @scale.is_a? Array
      scale = @scale.sort.reverse.detect {|x| calculated_scale > x } || calculated_scale
    else
      scale = calculated_scale
    end

    # the front box
    lines << rect(
      margin,
      @view_height - (margin + (scale * @height)),
      scale * @width,
      scale * @height
    )

    # first diagonal line
    lines << line(
      margin,
      (@view_height - (margin + (scale * @height))),
      margin + width_given_angle_and_hyp(angle, scale * @depth * depth_scale),
      (@view_height - (margin + (scale * @height) + height_given_angle_and_hyp(angle, scale * scaled_depth)))
    )

    # second diagonal line
    lines << line(
      margin + (scale * @width),
      (@view_height - (margin + (scale * @height))),
      margin +  (scale * @width) + width_given_angle_and_hyp(angle, scale * scaled_depth),
      (@view_height - (margin + (scale * @height) + height_given_angle_and_hyp(angle, scale * scaled_depth)))
    )

    # third diagonal line
    lines << line(
      margin + (scale * @width),
      (@view_height - margin),
      margin +  (scale * @width) + width_given_angle_and_hyp(angle, scale * scaled_depth),
      (@view_height - (margin + height_given_angle_and_hyp(angle, scale * scaled_depth)))
    )

    # top line
    lines << line(
      margin + width_given_angle_and_hyp(angle, scale * scaled_depth),
      (@view_height - (margin + (scale * @height) + height_given_angle_and_hyp(angle, scale * scaled_depth))),
      margin + width_given_angle_and_hyp(angle, scale * scaled_depth) + (scale * @width),
      (@view_height - (margin + (scale * @height) + height_given_angle_and_hyp(angle, scale * scaled_depth))),
    )

    # right line
    lines << line(
      margin + width_given_angle_and_hyp(angle, scale * scaled_depth) + (scale * @width),
      (@view_height - (margin + (scale * @height) + height_given_angle_and_hyp(angle, scale * scaled_depth))),
      margin + width_given_angle_and_hyp(angle, scale * scaled_depth) + (scale * @width),
      (@view_height - margin - height_given_angle_and_hyp(angle, scale * scaled_depth))
    )

    unless @exclude_units

      # Width text
      lines << text(margin + (scale * @width) / 2, @view_height - margin - 4, measurement_label(@width), :middle)

      # Hight text
      lines << text(margin + (scale * @width) - 2, @view_height - margin - ((scale * @height) / 2), measurement_label(@height), :end)

      # Depth text
      lines << text(
        margin + (width_given_angle_and_hyp(angle, scale * scaled_depth) / 2) + 20,
        @view_height - margin -(scale * @height) - (height_given_angle_and_hyp(angle, scale * scaled_depth) / 2),
         measurement_label(@depth), :start)

    end

    "<svg viewbox=\"0 0 400 320\" class=\"dimension-view\">" +
      lines.join('') +
      tennis_ball(scale, margin + (scale * @width) + margin, @view_height - margin) +
    "</svg>"

  end

  private

  def measurement_label(cm)

    if cm < 1
      unit = 'mm'
      value = cm * 10
    elsif cm < 100
      unit = 'cm'
      value = cm
    else
      unit = 'm'
      value = cm / 100
    end

    value = "%g" % value.round(1)

    "#{value} #{unit}"
  end

  def width_given_angle_and_hyp(angle, hyp)
    radians = angle.to_f / 180 * Math::PI
    hyp.to_f * Math.cos(radians)
  end

  def height_given_angle_and_hyp(angle, hyp)
    radians = angle.to_f / 180 * Math::PI
    hyp.to_f * Math.sin(radians)
  end

  def longest_length
    [@height, @width, @depth].max
  end

  def tennis_ball(scale, x, y)

    tennis_ball_height = (6.7 * scale)

    transformed_scale = tennis_ball_height / 280

    "<g fill-rule=\"evenodd\" transform=\"translate(#{x},#{y - tennis_ball_height})\">
      <g class=\"tennis-ball\" transform=\"scale(#{transformed_scale},#{transformed_scale})\">
        <circle class=\"ball\" cx=\"140.5\" cy=\"140.5\" r=\"139.5\"></circle>
        <path class=\"line\" d=\"M35.4973996,48.6564543 C42.5067217,75.8893541 47.1024057,103.045405 48.5071593,129.267474 C49.2050919,142.295548 49.1487206,156.313997 48.4007524,171.179475 C47.3170518,192.717458 44.831768,215.405368 41.2689042,238.548172 C44.0920595,241.405174 47.0377013,244.140872 50.0973089,246.746747 C54.274085,220.981656 57.1814249,195.664391 58.388118,171.681997 C59.152645,156.487423 59.2103921,142.12682 58.4928407,128.732526 C56.9456805,99.8522041 51.6525537,69.9875212 43.5965239,40.1505937 C40.7799535,42.8710386 38.077622,45.7089492 35.4973996,48.6564543 L35.4973996,48.6564543 Z\"></path>
        <path class=\"line\" d=\"M209.929126,19.4775696 C207.210255,20.7350524 204.523231,22.0798819 201.877774,23.5155872 C185.816543,32.2321125 172.62404,43.5997536 163.365582,57.9858795 C152.309799,75.1647521 147.361062,95.9365435 149.519284,120.438716 C153.246233,162.750546 177.6149,202.948254 215.783496,239.999593 C219.369774,243.480895 223.018502,246.874207 226.714223,250.176799 C229.361836,248.092694 231.93214,245.91478 234.420126,243.648068 C230.467945,240.143617 226.570656,236.534305 222.748767,232.824289 C186.140739,197.287837 162.958794,159.047704 159.480716,119.561284 C157.514766,97.2419721 161.935618,78.6859198 171.774644,63.3976879 C180.045966,50.5454103 191.971382,40.2695847 206.647666,32.3046788 C211.02518,29.9289759 215.539302,27.8153877 220.133919,25.9481492 C216.833521,23.6494818 213.429097,21.4897954 209.929126,19.4775696 L209.929126,19.4775696 Z\"></path>
    </g></g>"
  end


  def line(x1, y1, x2, y2)
    "<line x1=\"#{x1}\" y1=\"#{y1}\" x2=\"#{x2}\" y2=\"#{y2}\" class=\"edge\"></line>"
  end


  def rect(x, y, width, height)
    "<rect x=\"#{x}\" y=\"#{y}\" width=\"#{width}\" height=\"#{height}\" class=\"edge\"></rect>"
  end

  def text(x, y, text_content, text_anchor)
    "<text x=\"#{x}\" y=\"#{y}\" text-anchor=\"#{text_anchor}\">#{text_content}</text>"
  end

end