# Frame 1 Visual Comparison

## Scope

This report covers only the attendee home benchmark: Frame 1, Home - Upcoming and Popular.

## Validation performed

- Direct Dart analysis of [home_page.dart](../lib/features/home/presentation/home_page.dart): passed.
- Existing onboarding-to-home widget test: passed after updating its stale assertion from `Featured events` to the reference label `Upcoming Events`.
- Original OneDrive workspace launch: blocked because generated iOS and Android build directories are read-only OneDrive reparse points.
- Local-copy Android launch: passed from `C:\Dev\evenline_event_app_local` after `flutter pub get`.
- Final Android framebuffer: refreshed and captured at `C:\Dev\evenline_visual_validation\frame1_android_final_v2.png` from the connected vivo Y19.
- Flutter VM connection later dropped after installation, so the final screenshot was captured directly with ADB from the rendered device framebuffer.

## Implemented reference comparison

| Area | Current implementation | Reference target | Status |
|---|---|---|---|
| Page structure | Location header, search, Upcoming Events, Popular Now, bottom navigation | Same visible hierarchy | Aligned structurally |
| Header | Compact location block and notification icon | Compact location block and bell action | Approximate; requires rendered comparison |
| Search | Custom pale rounded field with leading search icon | Pale rounded search field | Approximate |
| Upcoming card | Custom white rounded row with image placeholder, metadata, and Join action | Compact event row with image/date treatment, metadata, and Join | Approximate; placeholder art is intentionally different |
| Popular section | Horizontal scrolling fixed-width cards | Horizontal card carousel, clipped at right edge | Aligned structurally |
| Popular card geometry | 188 px width, 106 px image region, rounded container | Narrow landscape event card with large image and compact metadata | Approximate; requires screenshot comparison |
| Colors | Centralized orange, pale field, black, gray, and soft shadow tokens | Warm orange actions, white canvas, pale fields, muted metadata | Approximate token match |
| Bottom navigation | Custom five-item bar: Home, Explore, Favorites, Ticket, Profile | Five-item reference navigation with orange active state | Aligned structurally |
| Scroll behavior | Vertical page plus horizontal Popular Now list | Vertical page plus horizontal carousel | Aligned structurally |
| Assets | Deterministic colored placeholder artwork | Illustrated event imagery | Intentionally different per requirement |

## Final rendered comparison

The refreshed Android framebuffer was directly inspected against the supplied Frame 1 screenshot. The home hierarchy, margins, section order, horizontal carousel behavior, custom five-item navigation, and overflow-free card layout are present.

### MUST FIX for visual fidelity

- None identified from the available screenshot comparison that can be corrected without introducing reference-unsupported behavior.

### ACCEPTABLE because exact assets are unavailable

- Reference event illustrations are represented by deterministic colored placeholder artwork.
- The exact reference font is unavailable, so font metrics and line wrapping are approximate.
- Available Flutter line icons approximate the reference icon set but do not reproduce its exact stroke geometry.

### DATA differences

- Local event titles, dates, prices, venues, and metadata do not match the example content shown in the reference.
- Firestore's configured default database does not exist, so the app renders local fallback event data during validation.

### NOT YET VERIFIED

- Exact pixel-level color sampling and shadow opacity from original-resolution design exports.
- Small-phone and tablet screenshots from the rebuilt home screen. The widget test confirms no overflow in the exercised layout, but device captures at those widths remain outstanding.
- Interactive notification/search behavior is intentionally outside this visual-only pass.

No Frame 2 or other screen was implemented.

## Environment workaround

The original source workspace remains at its OneDrive path. For local Android development, use the non-OneDrive copy at `C:\Dev\evenline_event_app_local`, which was created without `.dart_tool`, `build`, and `.git`, then initialized with `flutter pub get`. This avoids destructive cleanup of synchronized generated files. The source workspace itself was not moved or deleted.
