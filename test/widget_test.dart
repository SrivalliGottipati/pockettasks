import 'package:flutter_test/flutter_test.dart';
import 'package:pockettasks/models/task.dart';
import 'package:pockettasks/state/filter.dart';

void main() {
	group('applySearchAndFilter', () {
		final now = DateTime(2020, 1, 1);
		final tasks = [
			Task(id: '1', title: 'Buy groceries', done: true, createdAt: now.add(const Duration(minutes: 1))),
			Task(id: '2', title: 'Walk the dog', done: false, createdAt: now.add(const Duration(minutes: 2))),
			Task(id: '3', title: 'Read book', done: false, createdAt: now.add(const Duration(minutes: 3))),
		];

		test('All + empty query returns all ordered by createdAt desc', () {
			final result = applySearchAndFilter(tasks: tasks, query: '', filter: TaskFilter.all);
			expect(result.map((t) => t.id).toList(), ['3', '2', '1']);
		});

		test('Active filter returns only not done', () {
			final result = applySearchAndFilter(tasks: tasks, query: '', filter: TaskFilter.active);
			expect(result.every((t) => !t.done), true);
			expect(result.length, 2);
		});

		test('Done filter returns only done', () {
			final result = applySearchAndFilter(tasks: tasks, query: '', filter: TaskFilter.done);
			expect(result.every((t) => t.done), true);
			expect(result.length, 1);
		});

		test('Text query filters by title (case-insensitive)', () {
			final result = applySearchAndFilter(tasks: tasks, query: 'dog', filter: TaskFilter.all);
			expect(result.length, 1);
			expect(result.first.title, 'Walk the dog');
		});
	});
}
