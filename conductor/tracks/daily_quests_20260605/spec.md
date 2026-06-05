# Specification: Daily Quests

## Overview
Implement a daily quests system that gives the user specific goals to achieve each day (e.g., 10,000 steps, visit 1 gym). Completing quests yields bonus evolution points.

## Functional Requirements
- Implement a quest generation logic based on the date.
- Track quest completion status.
- Persist quests and progress using Hive.
- Implement UI for Quests, utilizing Stitch MCP for styling.

## Acceptance Criteria
- Quests reset at midnight.
- Completing a quest grants XP.
- UI components reflect Stitch design guidelines.

## Out of Scope
- Weekly/Monthly quests.
