# Evenline Visual Design Specification

## Status and source of truth

This is the visual source of truth for the first implementation phase. It is derived from the uploaded reference composite for the Evenline Event Booking App UI Kit:
[Dribbble reference](https://dribbble.com/shots/18322327-Evenline-Event-Booking-App-UI-Kit).

The source frames are raster screenshots embedded in a composite. Values below are therefore measured or estimated from the visible mobile frames and should be refined against original-resolution exports when available. Do not replace an unspecified detail with a generic Material default.

## Design direction

The visual language is a light, editorial event-discovery interface with warm orange actions, near-black text, very pale cool-gray surfaces, compact rounded containers, and generous white space. The interface is information-dense but calm: imagery carries personality, while text and controls remain restrained.

The reference uses an iPhone-like mobile canvas. The visible frames are approximately 280-300 px wide in the uploaded composite and appear to represent a logical mobile viewport close to 375 x 812 px. Implementation should use a 375 px reference design width, preserve proportions at standard phones, and reflow content at tablet widths rather than uniformly enlarging every element.

## Global canvas and safe areas

- Background: white or near-white throughout the main content.
- Content width: full mobile width minus approximately 20-24 px side margins.
- Primary horizontal inset: approximately 20 px on detail/settings screens and approximately 16 px on dense discovery screens.
- Top safe area: approximately 10-18 px below the status bar before content begins.
- Bottom safe area: device home-indicator area remains white; fixed actions sit above it.
- The reference does not show a persistent app-wide title bar. Most screens use a compact custom header with a back arrow, centered title where needed, and right-side icon actions.

## Color system

The following values are visual approximations from the screenshots and should be sampled from the original frames before final polish:

| Token | Approximate value | Usage |
|---|---|---|
| `background` | `#FFFFFF` | Main page and safe-area background. |
| `surface` | `#FCFCFC` | Light card interiors and image-adjacent surfaces. |
| `surfaceMuted` | `#F7F9FA` | Search fields, filter fields, inactive controls, and subtle list backgrounds. |
| `textPrimary` | `#17191B` | Headings, titles, prices, selected labels. |
| `textSecondary` | `#969DA3` | Supporting metadata, descriptions, inactive labels. |
| `textTertiary` | `#B8BEC2` | Very quiet helper copy and disabled states. |
| `primaryOrange` | `#FF7A45` | Main buttons, selected navigation icon, active tab underline, active switches. |
| `orangeSoft` | `#FFF1E9` | Price pills, soft selected surfaces, and secondary orange backgrounds. |
| `navySelected` | `#0E3F56` | Selected ticket header/card state and dark emphasis surfaces. |
| `border` | `#E8ECEE` | Light card borders and dividers. |
| `success` | `#2DBB78` | Selection check marks and positive status. |
| `black` | `#101214` | Device-like text/icon emphasis and dark controls. |

Avoid saturated purple, default Material seed colors, and arbitrary per-widget colors. Event imagery may introduce additional colors only inside image containers.

## Typography hierarchy

The reference appears to use a clean geometric sans-serif with compact proportions. The exact font is not determinable from the screenshots alone. Use one centrally configured font family and verify it against the supplied originals before selecting a bundled font.

- Screen title / primary heading: approximately 20-22 px, bold, line height around 1.2.
- Section heading: approximately 14-16 px, semibold/bold.
- Event title: approximately 12-14 px, semibold/bold, usually 1-2 lines.
- Body copy: approximately 11-13 px, regular, relaxed line height.
- Metadata: approximately 9-11 px, regular, gray.
- Button label: approximately 11-12 px, semibold.
- Price emphasis: approximately 12-16 px, semibold/bold depending on placement.
- Avoid oversized Material display styles, automatic letter spacing, and excessive capitalization.
- Text is generally sentence case. Labels such as `Upcoming Events`, `Popular Now`, and `Order summary` use compact title case.

## Spacing system

Use centralized tokens based on a compact 4 px rhythm:

- `space4`: icon-to-label and very tight internal gaps.
- `space8`: metadata gaps, card row gaps, and compact control padding.
- `space12`: standard control gap and card internal gap.
- `space16`: primary content inset and section gap baseline.
- `space20`: larger section separation and detail-screen inset.
- `space24`: major screen section separation.
- `space32`: onboarding/hero separation and large content transitions.

These are starting tokens, not permission to normalize every gap. The screenshot-specific values take precedence when a measured gap differs.

## Corner radii

The reference uses visibly rounded but not pill-heavy containers:

- Large image/event containers: approximately 10-14 px.
- Standard cards: approximately 10-12 px.
- Input fields and soft panels: approximately 10-12 px.
- Buttons: approximately 10-12 px.
- Date chips and compact pills: approximately 6-8 px.
- Circular avatars and icons: fully circular.
- Avoid default Material 20+ px card radii unless a future reference frame proves it.

## Shadows and borders

Cards are mostly defined by white space, subtle borders, and very soft shadows rather than heavy elevation.

- Default shadow: low-opacity black, small blur, short vertical offset.
- Use no shadow when a border or adjacent white space already separates the surface.
- Borders are pale gray and approximately 1 px.
- Do not use Material elevation values that create dark gray edges.

## Buttons

Primary buttons are warm orange, compact, and usually anchored to the lower portion of the screen or purchase footer.

- Fill: `primaryOrange`.
- Text: white, semibold.
- Height: approximately 42-48 px.
- Horizontal padding: approximately 20-24 px.
- Radius: approximately 10-12 px.
- Main actions such as `Get a Ticket`, `Continue`, `Place Order`, `Apply`, and `Save Changes` are orange filled buttons.
- Secondary actions such as `Follow` and `Message` use white backgrounds with a thin orange or dark outline.
- Avoid full-width filled buttons merely because Material makes them convenient; use the reference width and anchoring for each screen.

## Inputs and selection controls

- Search fields are pale gray, borderless, rounded rectangles approximately 44-50 px high.
- Search icon is small, left aligned with approximately 14-16 px inset.
- Placeholder text is small and gray.
- Filter rows use pale surfaces or white rows with generous vertical padding.
- Selected categories use a green check at the trailing edge; unselected rows use quiet gray marks or no mark.
- Date selection uses a five-item horizontal row of compact date tiles. Selected date is dark navy with white text; unselected dates are white/pale with gray text.
- Switches use orange for active and light gray for inactive, with a compact iOS-like shape.

## Image containers and imagery

Images are important as color blocks and content anchors, but exact assets may be replaced with placeholders.

- Home feature/event images: wide landscape containers, approximately 2:1 to 2.2:1, with 10-12 px radius.
- Compact event thumbnails: square or near-square, approximately 58-64 px, with 8-10 px radius.
- Organizer cover: wide landscape banner with a rounded or clipped lower edge as shown.
- Organizer/avatar images: circular, approximately 44-60 px depending on context.
- Agenda images: circular thumbnails.
- Map preview: wide rectangular panel with a soft radius; map imagery is a contained visual, not a full-screen map.
- Placeholder treatment must preserve dimensions, crop mode, and radius. Do not replace image areas with an arbitrary icon-only box in the final visual pass.

## Event cards

There are several distinct reusable card patterns:

### Home feature card

A prominent horizontal or landscape card under the first discovery section. It contains the event image, compact date badge or metadata, title, location, price/action, and rounded outer corners. It is separated from the next section by approximately 20-24 px.

### Compact event row

A white row/card with a 58-64 px rounded thumbnail on the left, title and location in the middle, and a small price pill or action on the right. Internal padding is approximately 10-12 px. The title may wrap to two lines without changing the thumbnail dimensions.

### Organizer event card

Similar compact row, but used inside organizer profiles and recommendation lists. It may include the organizer/location line and a soft orange price pill.

### Ticket card

A bordered rounded card with a dark navy selected header for the selected ticket type, event thumbnail/title/price, availability text, benefit affordance, and quantity stepper. The selected card has a stronger dark border; the unselected card stays pale and neutral.

## Headers and icon treatment

- Back arrow: small, dark, left aligned with approximately 20 px inset.
- Centered title: approximately 13-15 px bold when a screen title is present.
- Right actions: share, favorite, edit, settings, more, or notification icons; use thin line icons with compact hit areas.
- Icons are dark gray/black by default, orange when selected, and gray when inactive.
- Avoid oversized filled Material icons. Use outlined icons with consistent stroke weight and optical size.
- Notification affordance on home is a compact bell icon, sometimes with a small orange accent/badge.

## Bottom navigation

The reference bottom navigation is a white, fixed-height bar above the device safe area with five destinations:

1. Home
2. Explore
3. Favorites
4. Ticket
5. Profile

Each destination has a small outlined icon and a compact label. The selected destination uses orange icon/text; inactive destinations use light gray. There is no prominent Material navigation indicator pill. The bar should have a subtle top separation or shadow and approximately 64-72 px content height before the safe area.

## Screen-specific structures

### Home benchmark: frame 1

1. Status bar and compact location header.
2. Small `Find events near` label.
3. Bold location line, such as `California, USA`.
4. Notification action at upper right.
5. Search field below the header.
6. `Upcoming Events` section with a prominent event row/card.
7. `Popular Now` heading with `See All` action.
8. Horizontal event-card carousel, clipped at the right edge to signal horizontal scrolling.
9. Fixed five-item bottom navigation.

Frame 2 is an alternate home content state and adds stacked recommendation rows plus a `Who to follow` horizontal organizer carousel. It should validate that the home layout can support both a featured/upcoming variant and a recommendation-heavy variant without changing the global header or navigation.

### Event detail: frames 3-4

The first detail frame emphasizes the event overview and the second emphasizes organizer, agenda, and map information. Both use a custom back/action header, wide image or map blocks, concise text, and an orange purchase footer. The footer must remain visually stable as content varies.

### Ticket selection: frame 5

The date row is a horizontal five-item selector. Ticket options are stacked cards. The selected card uses a navy header and dark border. Total and `Continue` sit in a lower purchase area.

### Order summary: frame 6

The event summary sits above a bordered order-summary panel. Payment method is a separate row with a right-side `Change` affordance. Total and `Place Order` form the lower purchase footer.

### Organizer/profile and settings: frames 7-14

These screens share the custom compact header, rounded image/avatar treatment, small text hierarchy, orange action buttons, thin dividers, and white space. Tabs use orange text and a thin orange underline rather than a Material indicator pill.

## Responsive behavior

- Preserve the 375 px visual proportions at standard phone widths.
- At small phone widths, reduce horizontal gutters only when necessary; do not shrink text below its hierarchy token.
- At tablet widths, constrain the content to a readable centered column or use a deliberate two-column composition only where the reference pattern supports it. Do not stretch compact mobile cards across the entire tablet width.
- Horizontal carousels remain horizontal and visibly clipped at the viewport edge.
- Fixed footers and bottom navigation must account for safe-area padding.
- Long titles wrap; they must not overflow or force image containers to resize.

## Validation rules for implementation

For every rebuilt screen, compare a rendered screenshot with the corresponding reference frame and record:

- Canvas and outer inset difference.
- Section y-position and height difference.
- Card width, height, radius, and image aspect-ratio difference.
- Text size, weight, line wrapping, and baseline difference.
- Button width, height, radius, and placement difference.
- Icon size, alignment, and stroke treatment difference.
- Navigation height, destination count, and selected-state difference.
- Scroll direction and visible clipping difference.
- Any overlap, overflow, or safe-area mismatch.

Do not claim visual fidelity without completing this screenshot comparison. Exact assets are optional; geometry and visual hierarchy are not.

## Open measurement questions

The following require original-resolution screenshots or direct pixel sampling before final token values are frozen:

- Exact font family and font metrics.
- Exact orange, navy, gray, and background color values.
- Exact mobile logical viewport dimensions.
- Exact shadow blur/opacity.
- Exact card heights in the home variants.
- Whether the two home frames represent carousel/page states or separate home configurations.
- Exact icon set and stroke widths.
