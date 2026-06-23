# Specification: Boss Battles & Time-Limited Challenges

## 1. Overview
The "Boss Battles & Time-Limited Challenges" track introduces a new gameplay feature to FitQuest. It allows users to encounter powerful "Bosses" that require them to accumulate a specific amount of physical activity (converted into damage) within a limited timeframe. Defeating bosses grants rewards and provides an engaging, time-sensitive goal.

## 2. Core Mechanics

### 2.1 Boss Encounters
- Bosses will have specific statistics, primarily Health Points (HP) and a Time Limit.
- A user's physical activity (e.g., steps taken) is translated into "damage" dealt to the boss.
- The challenge is won if the boss's HP reaches 0 before the Time Limit expires.

### 2.2 Data Models
- **`BossEvent`**: Represents a boss encounter.
  - `id` (String)
  - `name` (String)
  - `description` (String)
  - `artworkUrl` (String - for the boss visual)
  - `maxHp` (int)
  - `currentHp` (int)
  - `timeLimit` (DateTime or Duration)
  - `rewards` (List<Reward>)
- **`DamageRecord`**: Represents the conversion of user activity into damage.
  - `timestamp` (DateTime)
  - `activityType` (String)
  - `amount` (int - e.g., number of steps)
  - `damageDealt` (int)

### 2.3 State Management
- A `BossBattleProvider` (using Riverpod) will track the active boss encounter, calculate the damage based on daily stats, and update the boss's current HP.

## 3. User Interface (UI)

### 3.1 Boss Battle Screen
- **Visuals**: A dedicated screen (`BossBattleScreen`) displaying the boss's artwork prominently.
- **Status Indicators**:
  - A large, animated Health Bar showing current HP vs. Max HP.
  - A countdown timer displaying the time remaining.
- **Interactions**: Visual feedback (animations or effects) when damage is dealt to the boss.

### 3.2 Navigation
- The Boss Battle screen will be accessible from the main navigation (e.g., linked from the `MainAppShell` or within a Daily Quests UI).

## 4. Rewards System
- Defeating a boss will trigger a reward distribution sequence, granting the user items, experience, or virtual currency as defined by the `BossEvent`'s rewards.
