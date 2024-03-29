import 'package:flutter/material.dart';
///The AppBar widget that can use for all the page of the Application.
class MainAppBar extends StatefulWidget {
  const MainAppBar(
      {super.key,
      required this.drawerKey,
      required this.title,
      required this.onSearch});

  final GlobalKey<ScaffoldState> drawerKey;
  final String title;
  final Function(String) onSearch;

  @override
  State<MainAppBar> createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  final _searchController = TextEditingController();

  ///Clear the search value in search bar
  void clearSearch() {
    _searchController.clear();
    widget.onSearch('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void drawerState() {
      if (widget.drawerKey.currentState!.isDrawerOpen) {
        widget.drawerKey.currentState!.closeDrawer();
      } else {
        widget.drawerKey.currentState!.openDrawer();
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextField(
          onChanged: widget.onSearch,
          controller: _searchController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: IconButton(
              onPressed: drawerState,
              icon: const Icon(Icons.menu),
            ),
            prefixIconColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(width: 2),
            ),
            contentPadding: EdgeInsets.zero,
            label: Row(
              children: const [
                Icon(
                  Icons.search_rounded,
                  color: Colors.grey,
                ),
                SizedBox(width: 3),
                Text(
                  'What are you finding?',
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            fillColor: Colors.black,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    onPressed: clearSearch,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: const Icon(Icons.cancel, color: Colors.white),
                  )
                : null,
          ),
        )
      ],
    );
  }
}
