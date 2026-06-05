# Specification: Avatar Progression

## Overview
Implement the Avatar leveling system. This involves calculating level-ups based on accumulated evolution points, persisting this data using Hive, and updating the Avatar UI.

## Functional Requirements
- Implement Hive local database.
- Create models for User Profile and Avatar.
- Implement leveling logic (e.g., XP thresholds for each level).
- Persist step count, points, and current level to Hive.
- Implement Avatar UI (use Stitch MCP for visual styling).

## Acceptance Criteria
- App successfully reads/writes to Hive database.
- Avatar level increments correctly when XP thresholds are met.
- UI reflects the current avatar state and uses Stitch styles.

## Out of Scope
- Server-side data sync.
