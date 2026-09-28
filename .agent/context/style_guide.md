# Style Guide: Tailor Master Craft Theme

## 1. Color Palette

| Token Name | Hex Code | Purpose & Usage |
| :--- | :--- | :--- |
| **Primary (Deep Indigo)** | `#1B365D` | App bars, prominent headers, primary action buttons, branding |
| **Accent / Urgency (Amber)** | `#D97706` | Urgent deadline badges, chalk tags, active stepper states, FAB |
| **Background (Soft Linen)** | `#F8FAFC` | Scaffold background, screen canvas |
| **Surface (Pure White)** | `#FFFFFF` | Card surfaces, dialog backgrounds, input field backgrounds |
| **Text Primary** | `#0F172A` | High-contrast readable headings, customer names, token badges |
| **Text Secondary** | `#475569` | Subtitles, measurement units, metadata dates |
| **Text Muted** | `#94A3B8` | Hints, placeholders, disabled indicators |
| **Divider & Border** | `#E2E8F0` | Subtle card borders, dividers, outline buttons |

### Status Colors
- **Pending:** `#64748B` (Slate Gray)
- **Cutting:** `#0284C7` (Sky Blue)
- **Stitching:** `#D97706` (Amber)
- **Trial Ready:** `#7C3AED` (Purple)
- **Completed:** `#059669` (Emerald Green)
- **Delivered:** `#16A34A` (Forest Green)
- **Urgent Warning:** `#DC2626` (Crimson Red)

---

## 2. Typography Hierarchy

Using high-legibility sans-serif fonts tailored for quick glances in workshop lighting:
- **Display / Token:** 22pt - 28pt, Bold, monospace or high-weight numeric styling (e.g., `#B-104`).
- **Heading Large:** 20pt, SemiBold, Primary color.
- **Heading Medium:** 16pt, SemiBold.
- **Body Large:** 15pt, Regular / Medium.
- **Body Medium / Caption:** 13pt, Regular, Secondary color.
- **Measurement Numeric Input:** 18pt - 22pt Bold, centered, quick keypad accessible.

---

## 3. UI Component Conventions

- **Touch Targets:** Minimum 48x48dp for workshop handling with rough fingers.
- **Numeric Measurement Grid:** Grid of pre-labeled numeric input cards (e.g., 2 columns or 3 columns) with direct numeric keyboard popups.
- **Order Token Badge:** Chalk-style high contrast container (Amber/Indigo with high-contrast text).
- **Status Stepper:** One-tap linear chip or slider allowing the tailor to mark "Next Stage" without navigating nested submenus.
