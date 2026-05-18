# Specification Drafting Protocol

## Overview
This protocol defines the standard for creating and maintaining project specifications. All specification files must follow the structure and metadata requirements outlined below to ensure project clarity, consistency, and testability.

## YAML Metadata Header
Every specification file in the `/specs` directory MUST begin with a YAML header.

```yaml
---
Module: [Name]
Business_Case_Stage: [e.g., Stage 0]
Dependencies: [List of dependent specs]
Test_Suite: [List of paths to relevant test files]
---
```

## Test Traceability
- Every specification MUST map to at least one test suite.
- The `Test_Suite` metadata field must be updated whenever a new test is added.
- All specifications should be tracked in the project's Traceability Index located at `docs/planning/traceability-index.md`.
