import React from 'react';
import Svg, { Circle, Path } from 'react-native-svg';

const DiscoverIcon = ({ color = '#fff', focused = false, size = 24 }) => {
  return (
    <Svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <Circle
        cx="11"
        cy="11"
        r="8"
        stroke={color}
        strokeWidth={focused ? "2.5" : "2"}
        strokeLinecap="round"
        strokeLinejoin="round"
      />
      <Path
        d="M21 21L16.65 16.65"
        stroke={color}
        strokeWidth={focused ? "2.5" : "2"}
        strokeLinecap="round"
        strokeLinejoin="round"
      />
    </Svg>
  );
};

export default DiscoverIcon;