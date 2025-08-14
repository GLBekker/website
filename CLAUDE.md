# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview
Virtual Life corporate website - a modern, cyberpunk-themed static website showcasing company services, team, and interactive demos.

## Architecture
**Type**: Static HTML website with modern CSS animations and interactive JavaScript games
**Structure**:
- Pure HTML/CSS/JavaScript (no build tools or framework dependencies)
- Bootstrap 5.3.0 for responsive grid and components
- FontAwesome 6.4.0 for icons
- Custom cyberpunk design system with neon effects

## Key Files
- `index.html` - Main landing page with hero, about, services, and contact sections
- `style.css` - Comprehensive cyberpunk-themed styling with animations and effects
- `game.html` - Neon Runner game demo
- `sheep_rumble.html` - Sheep Rumble game demo
- `terms.html` - Terms and conditions page
- `design_system.html` - Design system documentation
- `templates/change-request.html` - Change request form template

## Design System
**Color Palette**:
- Black: #000000
- Deep Navy: #111827
- Neon Blue: #00C8FF (primary accent)
- Electric Purple: #9900FF
- Magenta Pink: #FF00CC
- Cyan Blue: #0099CC
- Light Gray: #CCCCCC
- White: #FFFFFF

**Typography**:
- Headers: 'Orbitron' (futuristic, uppercase)
- Body: 'Inter' (clean, readable)
- Code/Tech: 'Share Tech Mono' (monospace)

**Key Visual Effects**:
- Glitch animations on headers
- Neon glow effects
- Particle animations
- Scanline overlays
- Gradient borders and shadows
- Hover state transformations

## Development Guidelines
Since this is a static site with no build process:
- Edit HTML/CSS/JavaScript files directly
- Test changes by opening HTML files in a browser
- Use CDN links for external dependencies (Bootstrap, FontAwesome)
- Maintain cyberpunk aesthetic with neon colors and tech-inspired animations
- Ensure responsive design works on mobile devices
- Keep performance in mind - animations should be GPU-accelerated

## Testing
No automated testing framework. Manual testing process:
1. Open HTML files directly in browser
2. Test responsive breakpoints (mobile, tablet, desktop)
3. Verify animations and hover effects
4. Check cross-browser compatibility (Chrome, Firefox, Safari, Edge)
5. Test interactive elements (forms, games, navigation)
