# Strip Footing Quantity Surveyor - AutoLISP

## Overview

**Strip Footing Quantity Surveyor** is an AutoLISP application for AutoCAD designed to help quantity surveyors, estimators, and civil engineers quickly calculate foundation quantities from CAD drawings.

The tool calculates:

- Net foundation area
- Total perimeter
- Inner openings deduction
- Quantity measurement table
- Automatic summary output inside AutoCAD

It is mainly designed for **strip footing foundation estimation**, where a large footing boundary may contain smaller rectangular openings or excluded areas.

---

# Features

## Multiple Object Selection

Select multiple closed rectangular polylines:

- Main strip footing boundary
- Smaller openings / deductions
- Additional footing sections


The program automatically detects:

- Largest rectangle → main footing area
- Smaller rectangles → deducted areas


---

# Calculation Method

## Net Area

The application calculates:
