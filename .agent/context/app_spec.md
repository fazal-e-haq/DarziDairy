# Product Requirements Document (PRD): Tailor Master (Offline Khata & Workshop)

## 1. Executive Summary
**Tailor Master** (Darzi Diary) is a standalone, offline-first mobile business tool built exclusively for independent tailors and small stitching shop owners. It replaces traditional paper measurement notebooks (Khata registers), manual wall-slips, and paper diaries (Roznamcha) with a single, fast, local digital workspace.
The app is 100% tailor-facing (no customer login, no web portals, no mandatory internet connection).

## 2. Problem Statement & Value Proposition
- **Lost or Damaged Notebooks:** Spills, torn pages, and lost books lead to lost customer measurements and broken trust.
- **Missed Deadlines & Chaos:** Especially during peak wedding/festival seasons, tailors lose track of promised delivery dates, resulting in dissatisfied clients.
- **Unclear Payment Balances:** Confusion over advance deposits, unpaid balances, and extra fabric charges causes lost revenue.
- **No Network Dependency:** Most tailoring shops operate in basements, crowded bazaars, or areas with poor cellular signal. The solution runs 100% offline with instant load times.

## 3. Core Functional Modules

### A. Customer & Measurement Khata
- **Customer Profile:** Unique ID, Name, Phone Number, Optional Secondary Contact, Notes.
- **Measurement Profiles:** One customer can have multiple measurement sheets categorized by garment type (e.g., Kurta Pajama, Shalwar Kameez, Two-Piece Suit, Pant/Shirt, Waistcoat).
- **Preset Numeric Inputs:** Pre-configured labels (Chest, Waist, Hip, Length, Shoulder, Sleeve, Neck, Inseam, Bottom/Pancha) with quick numeric keypad entry so the tailor never types names manually.
- **Measurement History:** Edit tracking to preserve previous sizing when alterations happen.

### B. Order Lifecycle & Workshop Tracking
- **Order Creation:** Links Customer + Measurement Profile + Garment Type.
- **Order Attributes:** Unique Order Tag/Token (e.g., `#B-104` to chalk onto the fabric), Booking Date, Target Delivery Deadline, Priority Flag (Normal, Urgent).
- **Style Specs & Attachments:** Style selections (Collar type: Ban/Sherwani/Spread; Cuff type; Pocket count) and device camera photos of fabric patterns or design sketches.
- **Status Workflow Engine:**
  $$\text{Pending} \longrightarrow \text{Cutting} \longrightarrow \text{Stitching} \longrightarrow \text{Trial Ready} \longrightarrow \text{Completed} \longrightarrow \text{Delivered}$$
- **Order Deletion & Archival:** Soft-deletion (recycle bin) with restore support to prevent accidental data loss.

### C. Financial Ledger & Cash Book (Roznamcha)
- **Order Billing:** Total Stitching Rate + Fabric Add-on Cost + Urgent Surcharge - Advance Paid = Balance Due.
- **Payment Status:** Auto-calculated flags (`Paid`, `Partial Balance`, `Unpaid`).
- **Tailor’s Daily Diary:**
  - Cash In (advances collected, remaining payments cleared upon delivery).
  - Cash Out / Shop Expenses (buttons, threads, interlining/bukram, machine oil, utility).
  - Daily net cash summary widget.

### D. Offline Utility & Data Safety
- **Zero Network Dependency:** 100% local on-device operation.
- **Local Storage & Backup:** 1-tap encrypted database export/import (JSON/binary) to device storage or SD card.
- **Print / Share:** Generates clean, offline PDF receipts or pre-formatted text slips to share via WhatsApp.

## 4. Technical Flow & Life Cycle
1. **New Walk-In:** Search or Create Customer $\to$ Input Measurements (Numeric Grid) $\to$ Create Order & Assign Token (`#A-12`) $\to$ Set Deadline + Advance Payment.
2. **Daily Workshop:** Open Dashboard $\to$ View Urgent Deadlines $\to$ Transition Status (`Pending` $\to$ `Cutting` $\to$ `Stitched` $\to$ `Delivered`).
3. **Fulfillment:** Look up by token/phone $\to$ Collect Balance $\to$ Mark Delivered.
4. **Shop Closing:** Log Daily Expenses $\to$ Review Daily Net Cash Inflow $\to$ One-Tap Local Backup.
