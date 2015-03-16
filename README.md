# MultiPaint
Multi-user paint web-application developed using DSL Platform

This project demonstrates how to build a multi-tier application, where business logic is separated through multiple layers:

* TypeScript - running in users browser, sends requests to the frontend
* PHP - frontend, issues requests to the backend, manages cookie-less sessions through the URL
* C#/Revenj - backend, handles security, persistence and caching
* PostgreSQL - holds the state (no state on frondend nor backend)

The project showcases usage of advanced DSL concepts such as OLAP cubes, domain events and security/permissions configuration.

Each visitor is granted a random Session ID.
Mouse movements are tracked through domain events and aggregated into Stroke entities.
All strokes are accumulated on the shared canvas through Revenj reporting capabilities.

A visitor is only able to erase his own part of the drawing.
An administrator can erase the entire canvas.
