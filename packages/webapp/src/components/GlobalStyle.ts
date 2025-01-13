import { createGlobalStyle } from 'styled-components';
// Optionally, import Blueprint's color system if you want to use it
import { Colors } from '@blueprintjs/core';

const GlobalStyle = createGlobalStyle`
  body {
    // ... existing styles ...
    background-color: #f5f5f5; // Light grey color
    // Alternatively, use Blueprint's light grey
    // background-color: ${Colors.LIGHT_GRAY5};
  }
`;

export default GlobalStyle; 