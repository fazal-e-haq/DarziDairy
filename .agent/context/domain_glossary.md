# Tailoring Domain Glossary & Software Mapping

This document provides a canonical mapping between traditional tailoring workshop terminology and modern software architectural representations in **Tailor Master**.

---

## 1. Shop Accounting & Bookkeeping Concepts

| Tailoring Term (Urdu/Hindi) | English Equivalent | Software & Architecture Representation |
| :--- | :--- | :--- |
| **Khata (کھاتہ)** | Customer Register / Ledger | `CustomerCollection` + `CustomerEntity`. Encapsulates customer identity, contact information, notes, and measurement history. |
| **Roznamcha (روزنامچہ)** | Daily Cash Book / Workshop Diary | `DailySummaryEntity` & `ExpenseCollection`. Aggregates daily cash inflows (advances and delivery collections) against daily workshop expenditures. |
| **Peshgi (پیشگی)** | Advance Deposit / Down Payment | `OrderEntity.advancePaid`. Collected at order booking time; deducted from total bill to compute `balanceDue`. |
| **Baqaya (بقایا)** | Balance Due / Outstanding Payment | `OrderEntity.balanceDue`. Auto-calculated value (`totalBill - advancePaid`). |
| **Silai Rate (سلائی ریٹ)** | Stitching Labor Charge | `OrderEntity.stitchingRate`. Baseline craftsmanship charge for the specified garment. |
| **Karigar (کاریگر)** | Artisan / Stitcher / Workshop Worker | Associated artisan identifier or notes regarding who handled cutting vs stitching. |

---

## 2. Order Lifecycle & Workshop Workflow

| Tailoring Term | Workflow State | Software State (`OrderStatus`) | Description |
| :--- | :--- | :--- | :--- |
| **Token / Chalk Mark (ٹوکن)** | Chalk Tag ID | `OrderEntity.orderToken` | Short alphanumeric tag (e.g. `#B-104`, `#A-12`) chalked on the raw fabric roll to identify the customer's garment throughout the workshop without paper tags. |
| **Katai (کٹائی)** | Cutting | `OrderStatus.cutting` | Fabric has been measured, marked, and cut according to customer dimensions. |
| **Silai / Jorai (سلائی)** | Stitching / Assembly | `OrderStatus.stitching` | Sewing machine assembly, stitching of panels, sleeves, pockets, and collars. |
| **Trial Ready (ٹرائل)** | Fitting / Trial Stage | `OrderStatus.trialReady` | Garment is basted or pre-assembled for the customer to try on before final press/cuff finish. |
| **Tayyar (تیار)** | Completed / Finished | `OrderStatus.completed` | Pressing, buttonholes, and final finishing completed; packaged on rack. |
| **Hawale (حوالے)** | Delivered | `OrderStatus.delivered` | Customer picked up garment, final balance collected, transaction logged to Roznamcha. |

---

## 3. Garments & Anatomy Measurements

| Garment Key | Term / Label | Software Dimension Key | Standard Unit |
| :--- | :--- | :--- | :--- |
| **Lambaai (لمبائی)** | Total Length | `length` | Inches (`in`) |
| **Seena / Chhaati (چھاتی)** | Chest / Bust | `chest` | Inches (`in`) |
| **Kamar (کمر)** | Waist | `waist` | Inches (`in`) |
| **Hip / Ghera (گھیرا)** | Hip / Bottom Flare | `hip` | Inches (`in`) |
| **Teera (تیرا)** | Shoulder Width | `shoulder` | Inches (`in`) |
| **Bazu / Aastin (بازو)** | Sleeve Length | `sleeve` | Inches (`in`) |
| **Gala / Hala (گلا)** | Neck Circumference | `neck` | Inches (`in`) |
| **Inseam / Asan (آسن)** | Crotch / Inseam | `inseam` | Inches (`in`) |
| **Pancha / Mohri (پانچہ)** | Trouser Leg Opening | `pancha` | Inches (`in`) |

---

## 4. Materials & Workshop Hardware

| Term | English Equivalent | Software Representation |
| :--- | :--- | :--- |
| **Bukram (بکرم)** | Interlining / Stiffening Fabric | Category in `ExpenseCollection` used for collar, placket, and cuff stiffening. |
| **Dhaga (دھاگہ)** | Sewing Thread Spools | Category in `ExpenseCollection`. |
| **Buttons (بٹن)** | Studs / Fasteners / Buttons | Category in `ExpenseCollection`. |
| **Machine Ka Tel (مشین کا تیل)** | Sewing Machine Lubricant | Maintenance expense category. |
