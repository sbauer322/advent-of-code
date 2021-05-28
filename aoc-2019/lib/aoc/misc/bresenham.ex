defmodule AOC.Misc.Bresenham do
  def bresenham_line(x0, y0, x1, y1) do
    plot_line(x0, y0, x1, y1)
  end

  def plot_line_low(x0, y0, x1, y1) do
    dx = x1 - x0
    dy = y1 - y0
    yi = 1

    {yi, dy} =
      if dy < 0 do
        yi = -1
        dy = -dy
        {yi, dy}
      else
        {yi, dy}
      end

    difference = 2 * dy - dx
    y = y0

    Enum.map_reduce(x0..x1, {y, difference}, fn x, {y, difference} ->
      # plot(x,y)
      plot = {x, y}

      {y, difference} =
        if difference > 0 do
          y = y + yi
          difference = difference - 2 * dx
          {y, difference}
        else
          {y, difference}
        end

      difference = difference + 2 * dy

      {plot, {y, difference}}
    end)
  end

  def plot_line_high(x0, y0, x1, y1) do
    dx = x1 - x0
    dy = y1 - y0
    xi = 1

    {xi, dx} =
      if dx < 0 do
        xi = -1
        dx = -dx
        {xi, dx}
      else
        {xi, dx}
      end

    difference = 2 * dx - dy
    x = x0

    Enum.map_reduce(y0..y1, {x, difference}, fn y, {x, difference} ->
      plot = {x, y}

      {x, difference} =
        if difference > 0 do
          x = x + xi
          difference = difference - 2 * dy
          {x, difference}
        else
          {x, difference}
        end

      difference = difference + 2 * dx

      {plot, {x, difference}}
    end)
  end

  def plot_line(x0, y0, x1, y1) do
    if abs(y1 - y0) < abs(x1 - x0) do
      if x0 > x1 do
        plot_line_low(x1, y1, x0, y0)
      else
        plot_line_low(x0, y0, x1, y1)
      end
    else
      if y0 > y1 do
        plot_line_high(x1, y1, x0, y0)
      else
        plot_line_high(x0, y0, x1, y1)
      end
    end
  end
end
