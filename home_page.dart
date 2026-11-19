import 'package:flutter/material.dart';

import 'task.dart';

const navy = Color(0xFF17233F);
const purple = Color(0xFF6C63FF);
const grey = Color(0xFF8991A7);

Color priorityColor(String priority) {
  switch (priority) {
    case 'High':
      return Colors.redAccent;
    case 'Medium':
      return Colors.orange;
    default:
      return Colors.green;
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Task> tasks = [
    Task(
      id: '1',
      title: 'Mobile Application Project',
      subject: 'Mobile Programming',
      description: 'Develop a mobile application using Flutter and Dart.',
      deadline: '25-11-2026',
      priority: 'High',
    ),
    Task(
      id: '2',
      title: 'Educational Technology Paper',
      subject: 'Educational Technology',
      description: 'Prepare an academic paper about digital learning.',
      deadline: '28-11-2026',
      priority: 'Medium',
    ),
    Task(
      id: '3',
      title: 'Learning Evaluation Summary',
      subject: 'Educational Evaluation',
      description: 'Summarize the learning evaluation materials.',
      deadline: '30-11-2026',
      priority: 'Low',
    ),
  ];

  int get completed => tasks.where((task) => task.isCompleted).length;

  Future<void> openForm({Task? task}) async {
    final result = await Navigator.push<Task>(
      context,
      MaterialPageRoute(builder: (_) => TaskForm(task: task)),
    );

    if (!mounted || result == null) return;

    setState(() {
      final index = tasks.indexWhere((item) => item.id == result.id);

      if (index == -1) {
        tasks.add(result);
      } else {
        tasks[index] = result;
      }
    });
  }

  Future<void> openDetail(Task task) async {
    final result = await Navigator.push<TaskResult>(
      context,
      MaterialPageRoute(builder: (_) => TaskDetail(task: task)),
    );

    if (!mounted || result == null) return;

    setState(() {
      final index = tasks.indexWhere((item) => item.id == task.id);

      if (index >= 0) {
        if (result.deleted) {
          tasks.removeAt(index);
        } else if (result.task != null) {
          tasks[index] = result.task!;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // HEADER
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: navy,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PLANORA',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w900,
                              color: navy,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            'Smart Academic Planner',
                            style: TextStyle(color: grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.notifications_none, color: navy, size: 27),
                  ],
                ),
              ),
            ),

            // DASHBOARD
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(23),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF202F55), Color(0xFF465A91), purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'YOUR PRODUCTIVITY',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Organize your tasks.\nAchieve your goals.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 23),
                    Row(
                      children: [
                        statistic(
                          'Total Tasks',
                          tasks.length,
                          Icons.layers_outlined,
                        ),
                        statistic(
                          'Completed',
                          completed,
                          Icons.check_circle_outline,
                        ),
                        statistic(
                          'Pending',
                          tasks.length - completed,
                          Icons.access_time,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // TITLE
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 28, 22, 15),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'My Tasks',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: navy,
                        ),
                      ),
                    ),
                    Text(
                      '${tasks.length} tasks',
                      style: const TextStyle(color: grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),

            // TASK LIST
            if (tasks.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text('No tasks available')),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return taskCard(tasks[index]);
                  }, childCount: tasks.length),
                ),
              ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => openForm(),
        backgroundColor: purple,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add New Task'),
      ),
    );
  }

  Widget statistic(String label, int number, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 7),
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.13),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white70, size: 18),
            const SizedBox(height: 8),
            Text(
              '$number',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget taskCard(Task task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE9EBF2)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => openDetail(task),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EFFF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.menu_book, color: purple),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        color: navy,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      task.subject,
                      style: const TextStyle(color: grey, fontSize: 11),
                    ),
                    const SizedBox(height: 9),
                    Wrap(
                      spacing: 7,
                      children: [
                        Text(
                          task.deadline,
                          style: const TextStyle(color: grey, fontSize: 10),
                        ),
                        Text(
                          task.priority,
                          style: TextStyle(
                            color: priorityColor(task.priority),
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: grey),
            ],
          ),
        ),
      ),
    );
  }
}

// DETAIL RESULT
class TaskResult {
  final Task? task;
  final bool deleted;

  const TaskResult({this.task, this.deleted = false});
}

// DETAIL PAGE
class TaskDetail extends StatelessWidget {
  final Task task;

  const TaskDetail({super.key, required this.task});

  Future<void> deleteTask(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Task?'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      Navigator.pop(context, const TaskResult(deleted: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Details')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(23),
            decoration: BoxDecoration(
              color: navy,
              borderRadius: BorderRadius.circular(23),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.assignment, color: Colors.white70, size: 30),
                const SizedBox(height: 15),
                Text(
                  task.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  task.subject,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          detailItem('Description', task.description),
          detailItem('Deadline', task.deadline),
          detailItem('Priority', task.priority),
          detailItem('Status', task.isCompleted ? 'Completed' : 'Pending'),

          const SizedBox(height: 15),

          FilledButton.icon(
            onPressed: () async {
              final result = await Navigator.push<Task>(
                context,
                MaterialPageRoute(builder: (_) => TaskForm(task: task)),
              );

              if (context.mounted && result != null) {
                Navigator.pop(context, TaskResult(task: result));
              }
            },
            icon: const Icon(Icons.edit),
            label: const Text('Edit Task'),
            style: FilledButton.styleFrom(
              backgroundColor: purple,
              padding: const EdgeInsets.all(16),
            ),
          ),

          const SizedBox(height: 10),

          OutlinedButton.icon(
            onPressed: () => deleteTask(context),
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            label: const Text(
              'Delete Task',
              style: TextStyle(color: Colors.red),
            ),
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
          ),
        ],
      ),
    );
  }

  Widget detailItem(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: grey, fontSize: 11)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(color: navy, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// FORM PAGE
class TaskForm extends StatefulWidget {
  final Task? task;

  const TaskForm({super.key, this.task});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController titleC;
  late TextEditingController subjectC;
  late TextEditingController descriptionC;
  late TextEditingController deadlineC;

  String? priority;
  bool completed = false;

  bool get isEdit => widget.task != null;

  @override
  void initState() {
    super.initState();

    final task = widget.task;

    titleC = TextEditingController(text: task?.title ?? '');

    subjectC = TextEditingController(text: task?.subject ?? '');

    descriptionC = TextEditingController(text: task?.description ?? '');

    deadlineC = TextEditingController(text: task?.deadline ?? '');

    priority = task?.priority;
    completed = task?.isCompleted ?? false;
  }

  @override
  void dispose() {
    titleC.dispose();
    subjectC.dispose();
    descriptionC.dispose();
    deadlineC.dispose();
    super.dispose();
  }

  String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Deadline is required';
    }

    final match = RegExp(r'^(\d{2})-(\d{2})-(\d{4})$').firstMatch(value);

    if (match == null) {
      return 'Use DD-MM-YYYY format';
    }

    final day = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final year = int.parse(match.group(3)!);

    if (year < 1 || month < 1 || month > 12 || day < 1) {
      return 'Invalid date';
    }

    final date = DateTime(year, month, day);

    if (date.year != year || date.month != month || date.day != day) {
      return 'Date does not exist';
    }

    return null;
  }

  void saveTask() {
    if (!formKey.currentState!.validate()) return;

    final result = Task(
      id: widget.task?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: titleC.text.trim(),
      subject: subjectC.text.trim(),
      description: descriptionC.text.trim(),
      deadline: deadlineC.text.trim(),
      priority: priority!,
      isCompleted: completed,
    );

    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Task' : 'Create New Task')),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Task Information',
              style: TextStyle(
                fontSize: 21,
                color: navy,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            TextFormField(
              controller: titleC,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Title is required';
                }
                if (v.trim().length < 3) {
                  return 'Minimum 3 characters';
                }
                return null;
              },
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: subjectC,
              decoration: const InputDecoration(
                labelText: 'Subject',
                prefixIcon: Icon(Icons.book),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Subject is required' : null,
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: descriptionC,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description',
                prefixIcon: Icon(Icons.description),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Description is required';
                }
                if (v.trim().length < 10) {
                  return 'Minimum 10 characters';
                }
                return null;
              },
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: deadlineC,
              decoration: const InputDecoration(
                labelText: 'Deadline (DD-MM-YYYY)',
                prefixIcon: Icon(Icons.calendar_month),
              ),
              validator: validateDate,
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: priority,
              decoration: const InputDecoration(
                labelText: 'Priority',
                prefixIcon: Icon(Icons.flag),
              ),
              items: const [
                DropdownMenuItem(value: 'Low', child: Text('Low')),
                DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                DropdownMenuItem(value: 'High', child: Text('High')),
              ],
              onChanged: (value) {
                setState(() => priority = value);
              },
              validator: (value) => value == null ? 'Select priority' : null,
            ),

            if (isEdit)
              SwitchListTile(
                title: const Text('Task Completed'),
                value: completed,
                activeColor: purple,
                onChanged: (value) {
                  setState(() => completed = value);
                },
              ),

            const SizedBox(height: 25),

            SizedBox(
              height: 53,
              child: FilledButton.icon(
                onPressed: saveTask,
                icon: const Icon(Icons.save),
                label: Text(isEdit ? 'Save Changes' : 'Save Task'),
                style: FilledButton.styleFrom(backgroundColor: purple),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
