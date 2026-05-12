import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class Post {
  final int userId;
  final int? id;
  final String title;
  final String body;

  Post({required this.userId, this.id, required this.title, required this.body});

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        userId: json['userId'],
        id: json['id'],
        title: json['title'],
        body: json['body'],
      );

  Map<String, dynamic> toMap() => {
        'userId': userId,
        if (id != null) 'id': id,
        'title': title,
        'body': body,
      };

  String toJsonString() => jsonEncode(toMap());
}

class PostService {
  static const String _base = 'jsonplaceholder.typicode.com';

  Future<Post> getPost(int id) async {
    final response = await http.get(Uri.https(_base, 'posts/$id'));
    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    }
    throw Exception('Erro ao buscar post: ${response.statusCode}');
  }

  Future<List<Post>> listPosts() async {
    final response = await http.get(Uri.https(_base, 'posts'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Post.fromJson(e)).toList();
    }
    throw Exception('Erro ao listar posts: ${response.statusCode}');
  }

  Future<Post> createPost(Post post) async {
    final response = await http.post(
      Uri.https(_base, 'posts'),
      headers: {'Content-Type': 'application/json'},
      body: post.toJsonString(),
    );
    if (response.statusCode == 201) {
      return Post.fromJson(jsonDecode(response.body));
    }
    throw Exception('Erro ao criar post: ${response.statusCode}');
  }

  Future<Post> updatePost(int id, Post post) async {
    final response = await http.put(
      Uri.https(_base, 'posts/$id'),
      headers: {'Content-Type': 'application/json'},
      body: post.toJsonString(),
    );
    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    }
    throw Exception('Erro ao atualizar post: ${response.statusCode}');
  }

  Future<void> deletePost(int id) async {
    final response = await http.delete(Uri.https(_base, 'posts/$id'));
    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar post: ${response.statusCode}');
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JSONPlaceholder CRUD',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('JSONPlaceholder CRUD'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'GET'),
              Tab(text: 'GET Lista'),
              Tab(text: 'POST'),
              Tab(text: 'PUT'),
              Tab(text: 'DELETE'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            GetPostTab(),
            GetListTab(),
            PostTab(),
            PutTab(),
            DeleteTab(),
          ],
        ),
      ),
    );
  }
}

class GetPostTab extends StatefulWidget {
  const GetPostTab({super.key});

  @override
  State<GetPostTab> createState() => _GetPostTabState();
}

class _GetPostTabState extends State<GetPostTab> {
  final _svc = PostService();
  final _idController = TextEditingController(text: '1');
  Post? _post;
  String? _error;
  bool _loading = false;

  Future<void> _fetch() async {
    final id = int.tryParse(_idController.text);
    if (id == null) return;
    setState(() {
      _loading = true;
      _error = null;
      _post = null;
    });
    try {
      final post = await _svc.getPost(id);
      setState(() => _post = post);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(children: [
            Expanded(
              child: TextField(
                controller: _idController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'ID do Post', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(onPressed: _fetch, child: const Text('Buscar')),
          ]),
          const SizedBox(height: 16),
          if (_loading) const CircularProgressIndicator(),
          if (_error != null)
            Text(_error!, style: const TextStyle(color: Colors.red)),
          if (_post != null) _PostCard(post: _post!),
        ],
      ),
    );
  }
}

class GetListTab extends StatefulWidget {
  const GetListTab({super.key});

  @override
  State<GetListTab> createState() => _GetListTabState();
}

class _GetListTabState extends State<GetListTab> {
  final _svc = PostService();
  List<Post>? _posts;
  String? _error;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final posts = await _svc.listPosts();
      setState(() => _posts = posts);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
          child: Text(_error!, style: const TextStyle(color: Colors.red)));
    }
    if (_posts == null) return const SizedBox();
    return RefreshIndicator(
      onRefresh: _fetch,
      child: ListView.builder(
        itemCount: _posts!.length,
        itemBuilder: (_, i) => ListTile(
          leading: CircleAvatar(child: Text('${_posts![i].id}')),
          title: Text(_posts![i].title,
              maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(_posts![i].body,
              maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
      ),
    );
  }
}

class PostTab extends StatefulWidget {
  const PostTab({super.key});

  @override
  State<PostTab> createState() => _PostTabState();
}

class _PostTabState extends State<PostTab> {
  final _svc = PostService();
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  Post? _result;
  String? _error;
  bool _loading = false;

  Future<void> _submit() async {
    if (_titleCtrl.text.isEmpty || _bodyCtrl.text.isEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
      _result = null;
    });
    try {
      final novo = await _svc.createPost(
          Post(userId: 1, title: _titleCtrl.text, body: _bodyCtrl.text));
      setState(() => _result = novo);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        TextField(
          controller: _titleCtrl,
          decoration: const InputDecoration(
              labelText: 'Título', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _bodyCtrl,
          maxLines: 3,
          decoration: const InputDecoration(
              labelText: 'Corpo', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        FilledButton(
            onPressed: _loading ? null : _submit,
            child: const Text('Criar Post')),
        const SizedBox(height: 16),
        if (_loading) const CircularProgressIndicator(),
        if (_error != null)
          Text(_error!, style: const TextStyle(color: Colors.red)),
        if (_result != null) ...[
          const Text('✅ Post criado com sucesso:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          _PostCard(post: _result!),
        ],
      ]),
    );
  }
}

class PutTab extends StatefulWidget {
  const PutTab({super.key});

  @override
  State<PutTab> createState() => _PutTabState();
}

class _PutTabState extends State<PutTab> {
  final _svc = PostService();
  final _idCtrl = TextEditingController(text: '1');
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  Post? _result;
  String? _error;
  bool _loading = false;

  Future<void> _submit() async {
    final id = int.tryParse(_idCtrl.text);
    if (id == null || _titleCtrl.text.isEmpty || _bodyCtrl.text.isEmpty) {
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
      _result = null;
    });
    try {
      final updated = await _svc.updatePost(
          id,
          Post(
              userId: 1,
              id: id,
              title: _titleCtrl.text,
              body: _bodyCtrl.text));
      setState(() => _result = updated);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        TextField(
          controller: _idCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              labelText: 'ID do Post a atualizar',
              border: OutlineInputBorder()),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _titleCtrl,
          decoration: const InputDecoration(
              labelText: 'Novo Título', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _bodyCtrl,
          maxLines: 3,
          decoration: const InputDecoration(
              labelText: 'Novo Corpo', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        FilledButton(
            onPressed: _loading ? null : _submit,
            child: const Text('Atualizar Post (PUT)')),
        const SizedBox(height: 16),
        if (_loading) const CircularProgressIndicator(),
        if (_error != null)
          Text(_error!, style: const TextStyle(color: Colors.red)),
        if (_result != null) ...[
          const Text('✅ Post atualizado:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          _PostCard(post: _result!),
        ],
      ]),
    );
  }
}

class DeleteTab extends StatefulWidget {
  const DeleteTab({super.key});

  @override
  State<DeleteTab> createState() => _DeleteTabState();
}

class _DeleteTabState extends State<DeleteTab> {
  final _svc = PostService();
  final _idCtrl = TextEditingController(text: '1');
  String? _message;
  String? _error;
  bool _loading = false;

  Future<void> _delete() async {
    final id = int.tryParse(_idCtrl.text);
    if (id == null) return;
    setState(() {
      _loading = true;
      _error = null;
      _message = null;
    });
    try {
      await _svc.deletePost(id);
      setState(() => _message = '✅ Post #$id deletado com sucesso!');
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        TextField(
          controller: _idCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              labelText: 'ID do Post a deletar', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        FilledButton.tonal(
          onPressed: _loading ? null : _delete,
          style: FilledButton.styleFrom(backgroundColor: Colors.red.shade100),
          child:
              const Text('Deletar Post', style: TextStyle(color: Colors.red)),
        ),
        const SizedBox(height: 16),
        if (_loading) const CircularProgressIndicator(),
        if (_error != null)
          Text(_error!, style: const TextStyle(color: Colors.red)),
        if (_message != null)
          Card(
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(_message!, style: const TextStyle(fontSize: 16)),
            ),
          ),
      ]),
    );
  }
}

class _PostCard extends StatelessWidget {
  final Post post;
  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('ID: ${post.id ?? "novo"} | UserID: ${post.userId}',
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(post.title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(post.body),
        ]),
      ),
    );
  }
}
