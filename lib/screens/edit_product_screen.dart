import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void dispose() {
    super.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(
                        top: 8,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? const Text('Enter a URL')
                          : FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                        onEditingComplete: () {
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
