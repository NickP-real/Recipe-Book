import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:receipe_book/model/recipe.dart';
import 'package:receipe_book/pages/menu/menu.dart';

class AddOrEditRecipePage extends StatefulWidget {
  const AddOrEditRecipePage({Key? key, this.recipe}) : super(key: key);

  final Recipe? recipe;

  @override
  State<AddOrEditRecipePage> createState() => _AddOrEditRecipePageState();
}

class _AddOrEditRecipePageState extends State<AddOrEditRecipePage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _ingredientControllers = <TextEditingController>[];
  final _tagControllers = <TextEditingController>[];
  final _instructionControllers = <TextEditingController>[];

  @override
  void initState() {
    final recipe = widget.recipe;
    if (recipe != null) {
      _nameController.text = recipe.name;
      _imageUrlController.text = recipe.imageUrl;
      for (var tag in recipe.tags) {
        _tagControllers.add(TextEditingController(text: tag));
      }
      for (var ingredient in recipe.ingredients) {
        _ingredientControllers.add(TextEditingController(text: ingredient));
      }
      for (var instruction in recipe.instructions) {
        _instructionControllers.add(TextEditingController(text: instruction));
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageUrlController.dispose();
    for (var element in _ingredientControllers) {
      element.dispose();
    }
    for (var element in _tagControllers) {
      element.dispose();
    }
    for (var element in _instructionControllers) {
      element.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.recipe != null ? 'Edit Recipe' : 'Add Recipe'),
        ),
        body: Consumer<RecipeModel>(
          builder: (_, recipes, __) {
            void onSave() async {
              final name = _nameController.text;
              final instructions =
                  _instructionControllers.map((c) => c.text).toList();
              final imageUrl = _imageUrlController.text;
              final tags = _tagControllers.map((c) => c.text).toList();
              final ingredients =
                  _ingredientControllers.map((c) => c.text).toList();

              final recipe =
                  Recipe(name, imageUrl, tags, ingredients, instructions);

              if (widget.recipe != null) {
                recipes.edit(widget.recipe!, recipe);
              } else {
                recipes.add(recipe);
              }

              // await FirebaseFirestore.instance.collection('recipes').add({
              //   'name': name,
              //   'instructions': instructions,
              //   'imageUrl': imageUrl,
              //   'tags': tags,
              //   'ingredients': ingredients,
              // }).then((_) => Navigator.pop(context));

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      "${widget.recipe != null ? "Edit" : "Add"} $name success.")));
              Navigator.pop(context);
              if (widget.recipe != null) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MenuPage(recipe: recipe)));
              }
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _imageUrlController,
                        decoration:
                            const InputDecoration(labelText: 'Image URL'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an image URL';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ListForm(fields: _tagControllers, label: 'Category'),
                      const SizedBox(height: 16),
                      ListForm(
                          fields: _ingredientControllers, label: 'Ingredient'),
                      const SizedBox(height: 16),
                      ListForm(
                          fields: _instructionControllers,
                          label: 'Instruction'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            onSave();
                          }
                        },
                        child: const Text('Save Recipe'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}

class ListForm extends StatefulWidget {
  const ListForm({required this.fields, required this.label, super.key});

  final List<TextEditingController> fields;
  final String label;

  @override
  State<ListForm> createState() => _ListFormState();
}

class _ListFormState extends State<ListForm> {
  void _addField() {
    setState(() {
      widget.fields.add(TextEditingController());
    });
  }

  void _removeField(int index) {
    setState(() {
      widget.fields.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(widget.label, style: Theme.of(context).textTheme.subtitle1),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.fields.length,
          itemBuilder: (BuildContext context, int index) {
            return Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: widget.fields[index],
                    decoration: InputDecoration(
                        labelText: '${widget.label} ${index + 1}'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter ${widget.label}';
                      }
                      return null;
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => _removeField(index),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: _addField,
          icon: const Icon(Icons.add),
          label: Text('Add ${widget.label}'),
        ),
      ],
    );
  }
}
