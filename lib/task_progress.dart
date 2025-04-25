import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(TaskManagerApp());

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager with CircularProgressIndicator',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: TaskManagerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

enum Priority { Low, Medium, High }

class Task {
  String title;
  double progress; // 0.0 to 1.0
  Priority priority;
  bool completed;
  DateTime? dueDate;

  Task({
    required this.title,
    this.progress = 0.0,
    this.priority = Priority.Low,
    this.completed = false,
    this.dueDate,
  });
}

class TaskManagerScreen extends StatefulWidget {
  @override
  _TaskManagerScreenState createState() => _TaskManagerScreenState();
}

class _TaskManagerScreenState extends State<TaskManagerScreen> {
  final List<Task> _tasks = [];
  final TextEditingController _controller = TextEditingController();
  Priority _selectedPriority = Priority.Low;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // Load tasks from SharedPreferences
  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    // Deserialize tasks (to be implemented)
  }

  // Save tasks to SharedPreferences
  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    // Serialize and save tasks (to be implemented)
  }

  void _addTask(String title) {
    setState(() {
      _tasks.add(Task(title: title, priority: _selectedPriority, dueDate: _dueDate));
      _controller.clear();
      _selectedPriority = Priority.Low;
      _dueDate = null;
    });
    _saveTasks();
  }

  void _updateProgress(int index) {
    setState(() {
      if (_tasks[index].progress < 1.0) {
        _tasks[index].progress += 0.1;
        if (_tasks[index].progress > 1.0) {
          _tasks[index].progress = 1.0;
        }
      }
    });
    _saveTasks();
  }

  void _toggleComplete(int index) {
    setState(() {
      _tasks[index].completed = !_tasks[index].completed;
      if (_tasks[index].completed) {
        _tasks[index].progress = 1.0;
      }
    });
    _saveTasks();
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
    _saveTasks();
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete Task'),
        content: Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteTask(index);
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Color getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.Low:
        return Colors.green;
      case Priority.Medium:
        return Colors.orange;
      case Priority.High:
        return Colors.red;
      default:
        return Colors.green;
    }
  }

  // Show DatePicker to select due date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Widget _buildTaskCard(Task task, int index) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      elevation: 3,
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 18,
            decoration: task.completed ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 60,
                  width: 60,
                  child: CircularProgressIndicator(
                    value: task.progress,
                    strokeWidth: 6,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
                Text("${(task.progress * 100).toInt()}%"),
              ],
            ),
            if (task.dueDate != null)
              Text('Due: ${task.dueDate!.toLocal()}'),
          ],
        ),
        onTap: () => _updateProgress(index),
        onLongPress: () => _confirmDelete(index),
        trailing: Checkbox(
          value: task.completed,
          onChanged: (_) => _toggleComplete(index),
        ),
      ),
    );
  }

  Widget _buildTaskForm() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Enter task',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.trim().isNotEmpty) {
              _addTask(_controller.text.trim());
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Manager')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildTaskForm(),
          ),
          Expanded(
            child: _tasks.isEmpty
                ? Center(child: Text('No tasks yet. Add one!'))
                : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) =>
                  _buildTaskCard(_tasks[index], index),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _selectDate(context),
        tooltip: 'Select Due Date',
        child: Icon(Icons.calendar_today),
      ),
    );
  }
}
