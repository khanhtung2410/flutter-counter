import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:math';

class SampleItem {
  String id;
  ValueNotifier<String> name;

  SampleItem({String? id, required String name})
      : id = id ?? generateUuid(),
        name = ValueNotifier(name);

  static String generateUuid() {
    return int.parse(
            '${DateTime.now().millisecondsSinceEpoch}${Random().nextInt(100000)}')
        .toRadixString(35)
        .substring(0, 9);
  }
}

class SampleItemViewModel extends ChangeNotifier {
  static final _instance = SampleItemViewModel._();
  factory SampleItemViewModel() => _instance;
  SampleItemViewModel._();
  final List<SampleItem> items = [];

  void addItem(String name) {
    items.add(SampleItem(name: name));
    notifyListeners();
  }

  void removeItem(String id) {
    items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void updateItem(String id, String newName) {
    try {
      final item = items.firstWhere((item) => item.id == id);
      item.name.value = newName;
    } catch (e) {
      debugPrint('Không tìm thấy mục với ID $id');
    }
  }
}

class SampleItemUpdate extends StatefulWidget {
  final String? initialName;
  const SampleItemUpdate({super.key, this.initialName});

  @override
  State<SampleItemUpdate> createState() => _SampleItemUpdateState();
}

class _SampleItemUpdateState extends State<SampleItemUpdate> {
  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialName != null ? 'Chỉnh sửa' : 'Thêm mới'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop(textEditingController.text);
            },
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: TextFormField(
        controller: textEditingController,
      ),
    );
  }
}

class SampleItemWidget extends StatelessWidget {
  final SampleItem item;
  final VoidCallback? ontap;

  const SampleItemWidget({super.key, required this.item, this.ontap});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: item.name,
      builder: (context, name, child) {
        debugPrint(item.id);
        return ListTile(
          title: Text(name!),
          leading: const CircleAvatar(
            foregroundImage: AssetImage('assets/images/flutter_logo.png'),
          ),
          onTap: ontap,
          trailing: const Icon(Icons.keyboard_arrow_right),
        );
      },
    );
  }
}

class SampleItemDetailsView extends StatefulWidget {
  final SampleItem item;

  const SampleItemDetailsView({super.key, required this.item});
  @override
  State<SampleItemDetailsView> createState() => _SampleItemDetailsViewState();
}

class _SampleItemDetailsViewState extends State<SampleItemDetailsView> {
  final viewModel = SampleItemViewModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              showModalBottomSheet<String?>(
                context: context,
                builder: (context) =>
                    SampleItemUpdate(initialName: widget.item.name.value),
              ).then((value) {
                if (value != null) {
                  viewModel.updateItem(widget.item.id, value);
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Xác nhận xóa'),
                    content: const Text('Bạn có chắc muốn xóa mục này?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Bỏ qua'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Xóa'),
                      ),
                    ],
                  );
                },
              ).then((confirmed) {
                if (confirmed) {
                  Navigator.of(context).pop(true);
                }
              });
            },
          ),
        ],
      ),
      body: ValueListenableBuilder<String>(
        valueListenable: widget.item.name,
        builder: (_, name, __) {
          return Center(child: Text(name));
        },
      ),
    );
  }
}

class SampleItemListView extends StatefulWidget {
  const SampleItemListView({super.key});

  @override
  State<SampleItemListView> createState() => _SampleItemListView();
}

class _SampleItemListView extends State<SampleItemListView> {
  final viewModel = SampleItemViewModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Items'),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet<String?>(
                  context: context,
                  builder: (context) => const SampleItemUpdate(),
                ).then((value) {
                  if (value != null) {
                    viewModel.addItem(value);
                  }
                });
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            return ListView.builder(
              itemCount: viewModel.items.length,
              itemBuilder: (context, index) {
                final item = viewModel.items[index];
                return SampleItemWidget(
                  key: ValueKey(item.id),
                  item: item,
                  ontap: () {
                    Navigator.of(context)
                        .push<bool>(
                      MaterialPageRoute(
                        builder: (context) => SampleItemDetailsView(item: item),
                      ),
                    )
                        .then((deleted) {
                      if (deleted ?? false) {
                        viewModel.removeItem(item.id);
                      }
                    });
                  },
                );
              },
            );
          }),
    );
  }
}
