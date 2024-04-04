import os
import numpy as np
from colour import Color


def sort_by_hue(colors):
    # Convert the colors to the HSV color space
    hue_values = np.array([color.hue for color in colors])

    # Sort the colors by hue
    sorted_idxs = np.argsort(hue_values)
    sorted_colors = [colors[i] for i in sorted_idxs]

    return sorted_colors


if __name__ == '__main__':
    # Then we read the ~/.config/vis/colors/cli-visualizer file
    # and sort the colors by hue and write them back to the file
    home_dir = os.path.expanduser('~')
    with open(f'{home_dir}/.config/vis/colors/cli-visualizer', 'r') as f:
        colors = [Color(line.strip()) for line in f]

    sorted_colors = sort_by_hue(colors)
    with open(f'{home_dir}/.config/vis/colors/cli-visualizer', 'w+') as f:
        for color in sorted_colors:
            f.write(color.hex_l + '\n')
