

import '../models/task.dart';

enum TaskFilter { all, active, done }

List<Task> applySearchAndFilter({
	required List<Task> tasks,
	required String query,
	required TaskFilter filter,
}) {
	final normalizedQuery = query.trim().toLowerCase();
	Iterable<Task> result = tasks;

	// Apply filter first for efficiency
	if (filter == TaskFilter.active) {
		result = result.where((t) => !t.done);
	} else if (filter == TaskFilter.done) {
		result = result.where((t) => t.done);
	}

	if (normalizedQuery.isNotEmpty) {
		result = result.where((t) => t.title.toLowerCase().contains(normalizedQuery));
	}

	// Stable ordering by createdAt descending so newest tasks appear first
	final list = result.toList()
		..sort((a, b) => b.createdAt.compareTo(a.createdAt));
	return list;
}


