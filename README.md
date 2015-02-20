# MultiPaint
Multi-user paint web-application written for Revenj NoSQL

This project demonstrates event sourcing, reporting, security and custom REST services for Revenj framework.

Each visitor is granted a random Session ID.
Mouse movements are tracked through domain events and aggregated into Stroke entities.
All strokes are accumulated on the shared canvas through Revenj reporting capabilities.

A visitor is only able to erase his own part of the drawing.
An administrator can erase the entire canvas.
