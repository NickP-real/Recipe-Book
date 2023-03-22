import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receipe_book/model/recipe.dart';
import 'package:receipe_book/pages/menu/menu.dart';
import 'package:receipe_book/services/downloaded_storage.dart';
import 'package:receipe_book/services/storage.dart';

import 'custom_snackbar.dart';

class RecipeTile<T extends Storage> extends StatelessWidget {
  const RecipeTile(this.recipe, {super.key, this.isDownload = false});

  final Recipe recipe;
  final bool isDownload;

  @override
  Widget build(BuildContext context) {
    void toMenu(Recipe recipe) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MenuPage<T>(
            recipe,
            isDownload: isDownload,
          ),
        ),
      );
    }

    return Consumer<T>(
      builder: (_, recipes, __) {
        void handleOnDownloadClick() {
          final res = recipes.add(recipe) as bool;
          ScaffoldMessenger.of(context).showSnackBar(res
              ? CustomSnackbar.success(
                  message:
                      "Added ${recipe.name} to 'Downloaded Recipes' successful")
              : CustomSnackbar.error(
                  message: 'Failed to add ${recipe.name}, already have it?'));
        }

        return Card(
          child: ListTile(
            leading: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(recipe.imageUrl),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            title: Text(
              recipe.name,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
            ),
            subtitle: T == DownloadedStorage
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.tags.map((tag) => tag).join(' '),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(recipe.author)
                    ],
                  )
                : Text(
                    recipe.tags.map((tag) => tag).join(' '),
                    overflow: TextOverflow.ellipsis,
                  ),
            onTap: () => toMenu(recipe),
            trailing: isDownload
                ? IconButton(
                    onPressed: handleOnDownloadClick,
                    icon: const Icon(Icons.download_rounded))
                : null,
          ),
        );
      },
    );
  }
}
