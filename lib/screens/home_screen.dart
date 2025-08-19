import 'package:flutter/material.dart';
import '../state/filter.dart';
import '../state/tasks_controller.dart';
import '../widgets/progress_ring.dart';
import '../widgets/gradient_button.dart';
import '../theme/app_colors.dart';

class HomeScreen extends StatefulWidget {
  final TasksController controller;
  const HomeScreen({super.key, required this.controller});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController addController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  String? addError;

  TasksController get c => widget.controller;

  @override
  void dispose() {
    addController.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> _handleAdd() async {
    try {
      final task = await c.addTask(addController.text);
      setState(() => addError = null);
      addController.clear();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added "${task.title}"'),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              await c.removeTask(task.id);
            },
          ),
        ),
      );
    } on ArgumentError catch (_) {
      setState(() => addError = 'Title cannot be empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasks = c.visibleTasks;

    InputDecoration fieldDecoration(String label) => InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.textMuted),
      filled: true,
      fillColor: AppColors.inputFill,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.inputBorderEnabled),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.blueAccent),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.bgStart,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.bgStart, AppColors.bgEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 52, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ProgressRing(done: c.doneCount, total: c.totalCount, size: 76),
                const SizedBox(width: 16),
                Text('PocketTasks',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: addController,
                    decoration: fieldDecoration('Add Task').copyWith(errorText: addError),
                    onSubmitted: (_) => _handleAdd(),
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                ),
                const SizedBox(width: 12),
                GradientButton(onPressed: _handleAdd, child: const Text('Add')),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: searchController,
              decoration: fieldDecoration('Search').copyWith(prefixIcon: const Icon(Icons.search, color: AppColors.textMuted)),
              onChanged: c.setQueryDebounced,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: [
                _chip('All', TaskFilter.all),
                _chip('Active', TaskFilter.active),
                _chip('Done', TaskFilter.done),
              ],
            ),
            const SizedBox(height: 4),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Dismissible(
                    key: ValueKey('dismiss-${task.id}'),
                    background: Container(
                      color: Colors.red.withOpacity(0.8),
                      child: const Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) async {
                      final removed = task;
                      await c.removeTask(task.id);
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Deleted "${removed.title}"'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () async {
                              await c.insertTask(removed);
                            },
                          ),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                      leading: Icon(
                        task.done ? Icons.check_circle_outline : Icons.radio_button_unchecked,
                        color: task.done ? AppColors.doneGreen : AppColors.textMuted,
                        size: 28,
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          decoration: task.done ? TextDecoration.lineThrough : null,
                          decorationColor: AppColors.textPrimary,
                          decorationThickness: 1,
                        ),
                      ),
                      onTap: () async {
                        final before = task.done;
                        await c.toggleDone(task.id);
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(before ? 'Marked as active' : 'Marked as done'),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () async {
                                await c.toggleDone(task.id);
                              },
                            ),
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, TaskFilter f) {
    final selected = c.filter == f;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(color: selected ? Colors.white : AppColors.textMuted, fontWeight: FontWeight.w600),
      ),
      selected: selected,
      selectedColor: AppColors.chipSelected,
      backgroundColor: AppColors.chipBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      onSelected: (_) => c.setFilter(f),
    );
  }
}


