import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/daily_quests_provider.dart';

class DailyQuestsScreen extends ConsumerWidget {
  const DailyQuestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quests = ref.watch(dailyQuestsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Quests'),
      ),
      body: quests.isEmpty
          ? const Center(child: Text('No quests available.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: quests.length,
              itemBuilder: (context, index) {
                final quest = quests[index];
                final progress = quest.targetValue > 0
                    ? quest.currentValue / quest.targetValue
                    : 0.0;
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              quest.title,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            if (quest.isCompleted)
                              const Icon(Icons.check_circle, color: Colors.green)
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Text(quest.description),
                        const SizedBox(height: 16.0),
                        LinearProgressIndicator(
                          value: progress.clamp(0.0, 1.0),
                          backgroundColor: Colors.grey[800],
                          color: quest.isCompleted ? Colors.green : Theme.of(context).primaryColor,
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${quest.currentValue} / ${quest.targetValue}'),
                            Text('+${quest.xpReward} XP',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
