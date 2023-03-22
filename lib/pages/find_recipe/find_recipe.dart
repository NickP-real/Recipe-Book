import 'package:flutter/material.dart';
import 'package:receipe_book/auth.dart';
import 'package:receipe_book/model/recipe.dart';
import 'package:receipe_book/services/downloaded_storage.dart';
import 'package:receipe_book/widgets/appbar.dart';
import 'package:receipe_book/widgets/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:receipe_book/widgets/no_recipe_text.dart';
import 'package:receipe_book/widgets/recipe_tile.dart';

class FindRecipePage extends StatefulWidget {
  const FindRecipePage({super.key});

  @override
  State<FindRecipePage> createState() => _FindRecipePageState();
}

class _FindRecipePageState extends State<FindRecipePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: ((context, snapshot) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: MainAppBar(
                drawerKey: _scaffoldKey,
                title: 'Find Recipes',
                onSearch: (value) {}),
            centerTitle: true,
            toolbarHeight: 100,
            automaticallyImplyLeading: false,
          ),
          drawer: const MyDrawer(),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collectionGroup('recipes')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return const Center(
                    child: NoRecipeText(
                  title: "Something went wrong!",
                  subtext: "Looks like there're some error occured!",
                ));
              }

              if (!snapshot.hasData) {
                return const Center(
                    child: NoRecipeText(
                  title: "Empty book!",
                  subtext:
                      "Currently, there're only blank pages in our database.",
                ));
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    Recipe data = Recipe.fromJson(snapshot.data!.docs[index]
                        .data() as Map<String, dynamic>);
                    return RecipeTile<DownloadedStorage>(data,
                        isDownload: true);
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
