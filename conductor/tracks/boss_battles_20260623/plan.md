# Implementation Plan: Boss Battles & Time-Limited Challenges

## Phase 1: Core Mechanics and Models
- [ ] Task: Create `BossEvent` and `DamageRecord` data models.
- [ ] Task: Create a `BossBattleProvider` in Riverpod to manage active boss encounters and calculate user damage from daily stats.

## Phase 2: Boss Battle UI
- [ ] Task: Build `BossBattleScreen` to show Boss artwork, HP bar, and time remaining.
- [ ] Task: Add a visual widget for "dealing damage" (animations when user steps/activities are converted to damage).

## Phase 3: Rewards and Integration
- [ ] Task: Implement reward distribution logic when a boss is defeated.
- [ ] Task: Link `BossBattleScreen` to the `MainAppShell` or Daily Quests UI.
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Rewards and Integration' (Protocol in workflow.md)
