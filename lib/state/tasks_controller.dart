import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/task.dart';
import 'filter.dart';

class TasksController extends ChangeNotifier {
	TasksController({SharedPreferences? prefs}) : _prefs = prefs {
		_unawaited(_init());
	}

	static const String storageKey = 'pocket_tasks_v1';
	final SharedPreferences? _prefs;
	final List<Task> _tasks = <Task>[];
	String _query = '';
	TaskFilter _filter = TaskFilter.all;
	Timer? _debounce;

	List<Task> get tasks => List.unmodifiable(_tasks);
	String get query => _query;
	TaskFilter get filter => _filter;

	int get totalCount => _tasks.length;
	int get doneCount => _tasks.where((t) => t.done).length;

	List<Task> get visibleTasks => applySearchAndFilter(tasks: _tasks, query: _query, filter: _filter);

	Future<void> _init() async {
		final prefs = _prefs ?? await SharedPreferences.getInstance();
		final raw = prefs.getString(storageKey);
		if (raw != null && raw.isNotEmpty) {
			_tasks
				..clear()
				..addAll(Task.decodeList(raw));
		}
		notifyListeners();
	}

	Future<void> _persist() async {
		final prefs = _prefs ?? await SharedPreferences.getInstance();
		await prefs.setString(storageKey, Task.encodeList(_tasks));
	}

	Future<Task> addTask(String title) async {
		final trimmed = title.trim();
		if (trimmed.isEmpty) {
			throw ArgumentError('Title cannot be empty');
		}
		final task = Task(
			id: const Uuid().v4(),
			title: trimmed,
			done: false,
			createdAt: DateTime.now(),
		);
		_tasks.add(task);
		await _persist();
		notifyListeners();
		return task;
	}

	Future<void> removeTask(String id) async {
		_tasks.removeWhere((t) => t.id == id);
		await _persist();
		notifyListeners();
	}

	Future<void> insertTask(Task task) async {
		_tasks.add(task);
		await _persist();
		notifyListeners();
	}

	Future<void> updateTask(Task updated) async {
		final index = _tasks.indexWhere((t) => t.id == updated.id);
		if (index == -1) return;
		_tasks[index] = updated;
		await _persist();
		notifyListeners();
	}

	Future<void> toggleDone(String id) async {
		final index = _tasks.indexWhere((t) => t.id == id);
		if (index == -1) return;
		_tasks[index] = _tasks[index].copyWith(done: !_tasks[index].done);
		await _persist();
		notifyListeners();
	}

	void setFilter(TaskFilter filter) {
		_filter = filter;
		notifyListeners();
	}

	void setQueryDebounced(String value) {
		_query = value;
		_debounce?.cancel();
		_debounce = Timer(const Duration(milliseconds: 300), () {
			notifyListeners();
		});
	}

	@override
	void dispose() {
		_debounce?.cancel();
		super.dispose();
	}
}

void _unawaited(Future<void> f) {}


