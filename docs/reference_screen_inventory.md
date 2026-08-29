# Evenline Reference Screen Inventory

## Source and numbering

The source is the uploaded composite of screenshots from the Evenline Dribbble UI kit:
[Evenline Event Booking App UI Kit](https://dribbble.com/shots/18322327-Evenline-Event-Booking-App-UI-Kit).

The frame numbers below follow reading order: left to right, then top to bottom. The composite contains 14 visible frames. Names and purposes are classified from the visible UI. Where a purpose is inferred from labels rather than confirmed by a complete flow, it is marked as inferred.

## Visible frames

| Frame | Suggested screen name | Purpose | Role | Surface | Major UI components | Product requirement | Reusable patterns |
|---|---|---|---|---|---|---|---|
| 1 | Home - upcoming and popular | Discover nearby/upcoming events and popular events. | Attendee | Full screen | Location header, notification icon, search field, upcoming event feature card, horizontal popular-event cards, bottom navigation. | Home screen, notifications entry point. | App header, search field, event card, section header, bottom navigation. |
| 2 | Home - recommendations and organizers | Discover recommended events and organizers to follow. | Attendee | Full screen | Location header, notification icon, search field, stacked recommendation cards, “Who to follow” horizontal organizer cards, bottom navigation. | Home screen, favorites/following-related discovery. | Recommendation list row, organizer card, section header, bottom navigation. |
| 3 | Event details - overview | Review an event and start ticket purchase. | Attendee | Full screen | Back/share/favorite actions, large event image, video overlay, title, date card, event description, “Show more”, price range, tickets-left text, quantity controls, primary CTA. | Event details, favorites, booking flow, live availability. | Detail header, image frame, date tile, quantity stepper, orange CTA. |
| 4 | Organizer profile / event detail | View event organizer, agenda, and location before booking. | Attendee | Full screen | Back/share/favorite actions, organizer avatar/name/verification, follow button, agenda cards, map preview, venue callout, price and CTA. | Event details, organizer card, map preview, favorites/following. | Organizer identity row, agenda item, map panel, sticky purchase footer. |
| 5 | Ticket selection | Select a date, ticket type, and quantity. | Attendee | Full screen | Back/title header, horizontal date selector, ticket-type cards, selected state, ticket availability, benefit link, quantity controls, total, continue CTA. | Booking flow, ticket types, quantity selection. | Date selector, ticket card, selected border/header, quantity stepper, purchase footer. |
| 6 | Order summary | Review ticket order and payment method before placing order. | Attendee | Full screen | Back/title header, event summary card, order summary rows, fee row, total, payment method row, change action, place-order CTA. | Booking flow, mock payment, confirmation. | Summary card, key-value rows, payment row, purchase footer. |
| 7 | Organizer profile - events | View an organizer, follow them, and browse their events/collections/about tabs. | Attendee | Full screen | Cover image, back/more controls, avatar, organizer identity, follower count, message/follow buttons, tabs, event list cards, bottom navigation. | Organizer discovery, favorites/following. | Cover header, avatar overlap, segmented tabs, compact event card. |
| 8 | Event filters | Filter event discovery by date, category, price, and type. | Attendee | Full screen or filter page | Close/title header, date-range field, categories list with selection states, price selector, event-type selector, apply CTA. | Search/filtering: category, date range, price range, city/type extension. | Form row, selection list, trailing check, orange bottom CTA. |
| 9 | Follow organizer onboarding | Choose organizers or collections to follow during onboarding. | Attendee | Full screen | Skip action, title/subtitle, search field, horizontal recommendation cards, organizer/event metadata, per-card follow buttons, continue CTA. | Onboarding, favorites/following. | Onboarding header, recommendation card, outline follow button, fixed CTA. |
| 10 | Following - organizers | Manage followed people and organizers and discover suggestions. | Attendee | Full screen | Back/title header, People/Organizer segmented control, followed organizer rows, following buttons, suggestions carousel, bottom safe area. | Favorites/following, organizer discovery. | Segmented control, avatar row, compact orange action button, suggestion card. |
| 11 | Profile | View account statistics and the user’s events/collections/about content. | Attendee | Full screen | Back/title header, edit/settings icons, avatar, name/email, three-stat summary, tabs, event list, bottom navigation. | Profile, favorites, tickets, settings entry points. | Profile header, stat panel, tabs, compact event card, bottom navigation. |
| 12 | Push notification settings | Configure notification channels. | Attendee | Full screen | Back/title header, icon-labelled settings rows, descriptions, toggles, separators. | Notifications, profile settings. | Settings row, leading line icon, two-line label, switch. |
| 13 | Linked accounts | Link third-party accounts and save account changes. | Attendee | Full screen | Back/title header, profile identity, provider rows, provider icons, toggles, save CTA. | Authentication, profile settings, Google Sign-In. | Provider row, toggle, fixed orange CTA. |
| 14 | Language selection | Search and select the application language. | Attendee | Full screen | Back/title header, search field, language rows with flags, selected check state. | Localization. | Search field, language row, trailing selection state. |

## Role classification

All visible frames are attendee-facing. Frames 7 and 10 are organizer discovery/profile experiences, but they are still shown from the attendee role. No organizer-owned dashboard, event editor, attendee list, or QR scanner frame is visible.

## Surface classification notes

The uploaded frames appear to be complete mobile screens rather than modal dialogs or bottom sheets. Frame 8 is a dedicated filter page, not visibly a bottom sheet. Frame 9 is a full onboarding step. The purchase footer in frames 3, 4, 5, and 6 is part of the screen layout and should remain visually anchored near the bottom above the device safe area.

## Required screens not directly represented

The following product-scope screens are not directly represented in the uploaded reference. They must be designed using the same visual language, not generic Material layouts:

- Splash screen.
- Sign in, sign up, forgot password, password reset, and email verification states.
- Explicit onboarding carousel pages other than the follow-organizer step.
- Search results with loading, empty, error, and populated states.
- Favorites/saved-events list.
- Notification list and notification detail/navigation state.
- Ticket list with upcoming/past tabs.
- Ticket detail and generated QR code.
- Booking confirmation and mock payment result states.
- Organizer dashboard with sold tickets, capacity, and revenue.
- Create/edit event multi-step form.
- Event cover/gallery upload states and upload progress.
- Ticket type builder.
- Organizer attendee list.
- QR scanner, successful check-in, already-checked-in, invalid-token, and error states.
- Delete-account and re-authentication screens.
- Offline/connectivity banner and queued/failed booking state.
- Loading shimmer and error retry variants for every list screen.

## Existing project correspondence

| Reference frame(s) | Closest existing project screen | Current correspondence |
|---|---|---|
| 1-2 | [lib/features/home/presentation/home_page.dart](../lib/features/home/presentation/home_page.dart) | Same broad discovery purpose, but current sections/cards differ materially from the reference. |
| 3-4 | [lib/features/event/presentation/event_detail_page.dart](../lib/features/event/presentation/event_detail_page.dart) | Same route purpose, but gallery, organizer, map, ticket structure, and footer composition are incomplete. |
| 5-6 | [lib/features/tickets/presentation/booking_flow_page.dart](../lib/features/tickets/presentation/booking_flow_page.dart) | Same two-step flow, but current controls and card proportions are generic and data is simplified. |
| 7 | [lib/features/organizer/presentation/organizer_page.dart](../lib/features/organizer/presentation/organizer_page.dart) | The existing page is an organizer publishing form, not the reference’s attendee-facing organizer profile. |
| 8 | [lib/features/explore/presentation/explore_page.dart](../lib/features/explore/presentation/explore_page.dart) | Same discovery area, but filters are not implemented and category panels are unrelated to the reference. |
| 9-10 | No direct equivalent | Following flows are missing. |
| 11 | [lib/features/profile/presentation/profile_page.dart](../lib/features/profile/presentation/profile_page.dart) | Same route purpose, but profile statistics, tabs, event list, and settings actions are missing. |
| 12 | No direct equivalent | Notification settings are missing. |
| 13 | [lib/features/auth/presentation/auth_page.dart](../lib/features/auth/presentation/auth_page.dart) | Authentication exists, but linked-account UI and provider integrations are missing. |
| 14 | No direct equivalent | Language selection is missing. |

## First benchmark

Frame 1 is the recommended first visual benchmark because it establishes the primary home hierarchy, the global canvas, section spacing, event-card language, search treatment, and bottom navigation. Frame 2 should be used immediately afterward to validate the home screen’s alternate content state and horizontal organizer-card pattern.
