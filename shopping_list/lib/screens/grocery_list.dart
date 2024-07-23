import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categoies.dart';

import 'package:shopping_list/models/grocery.dart';
import 'package:shopping_list/screens/new_item.dart';

class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({super.key});

  @override
  State<GroceryListScreen> createState() {
    return _GroceryListScreenState();
  }
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  List<Grocery> _groceryList = [];
  var _isLoading = true;
  //late Future<List<Grocery>> _loadedItems;

  String _errorMsg = '';

  @override
  void initState() {
    super.initState();
    //_loadedItems = _loadItems();
    _loadItems();
  }

// Chaging this to use FutureBuilder
  void _loadItems() async {
    final url = Uri.https(
      'flutter-course-df992-default-rtdb.firebaseio.com',
      'shopping-list.json',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        setState(() {
          _errorMsg = 'Network error. Please try again later!';
          _isLoading = false;
        });
        return;
      }

      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final Map<String, dynamic> listData = json.decode(response.body);
      final List<Grocery> loadedItens = [];

      for (final item in listData.entries) {
        final category = categories.entries
            .firstWhere((cat) => cat.value.name == item.value['category'])
            .value;
        loadedItens.add(
          Grocery(
              id: item.key,
              name: item.value['name'],
              quantity: item.value['quantity'],
              category: category),
        );
      }

      setState(() {
        _groceryList = loadedItens;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _errorMsg = 'Something went wrong!';
        _isLoading = false;
      });
    }
  }

  // Future<List<Grocery>> _loadItems() async {
  //   final url = Uri.https(
  //     'flutter-course-df992-default-rtdb.firebaseio.com',
  //     'shopping-list.json',
  //   );

  //   final response = await http.get(url);

  //   if (response.statusCode >= 400) {
  //     // setState(() {
  //     //   _errorMsg = 'Network error. Please try again later!';
  //     //   _isLoading = false;
  //     // });
  //     throw Exception('Failed to fetch Grocery list!');
  //   }

  //   if (response.body == 'null') {
  //     return [];
  //   }

  //   final Map<String, dynamic> listData = json.decode(response.body);
  //   final List<Grocery> loadedItens = [];

  //   for (final item in listData.entries) {
  //     final category = categories.entries
  //         .firstWhere((cat) => cat.value.name == item.value['category'])
  //         .value;
  //     loadedItens.add(
  //       Grocery(
  //           id: item.key,
  //           name: item.value['name'],
  //           quantity: item.value['quantity'],
  //           category: category),
  //     );
  //   }

  //   // setState(() {
  //   //   _groceryList = loadedItens;
  //   //   _isLoading = false;
  //   // });

  //   return loadedItens;
  // }

  void _addNewItem() async {
    // await Navigator.of(context).push<Grocery>(
    //     MaterialPageRoute(builder: (ctx) => const NewItemScreen()));

    final newGroceryItem = await Navigator.of(context).push<Grocery>(
        MaterialPageRoute(builder: (ctx) => const NewItemScreen()));

    // New data doesn`t come from NewItemScreen anymore
    // Amd the above is not valid anymore
    if (newGroceryItem == null) {
      return;
    }

    setState(() {
      _groceryList.add(newGroceryItem);
    });
  }

  void _removeItemFromList(Grocery grocery) async {
    final index = _groceryList.indexOf(grocery);
    setState(() {
      _groceryList.remove(grocery);
    });

    final url = Uri.https(
      'flutter-course-df992-default-rtdb.firebaseio.com',
      'shopping-list/${grocery.id}.json',
    );

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      setState(() {
        _groceryList.insert(index, grocery);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _errorMsg = 'No itens on Grocery list!';
    Widget bodyContent = Center(
      child: Text(
        _errorMsg,
        style: const TextStyle(fontSize: 30),
      ),
    );

    if (_isLoading) {
      bodyContent = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_groceryList.isNotEmpty) {
      bodyContent = ListView.builder(
          itemCount: _groceryList.length,
          itemBuilder: (ctx, index) {
            return Dismissible(
              key: ValueKey(_groceryList[index].id),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) =>
                  {_removeItemFromList(_groceryList[index])},
              child: ListTile(
                leading: Container(
                  width: 24,
                  height: 24,
                  color: _groceryList[index].category.color,
                ),
                title: Text(_groceryList[index].name),
                trailing: Text(_groceryList[index].quantity.toString()),
              ),
            );
          });
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(onPressed: _addNewItem, icon: const Icon(Icons.add))
        ],
      ),
      body: bodyContent,
    );
  }

  //   return Scaffold(
  //       appBar: AppBar(
  //         title: const Text('Your Groceries'),
  //         actions: [
  //           IconButton(onPressed: _addNewItem, icon: const Icon(Icons.add))
  //         ],
  //       ),
  //       //body: bodyContent,
  //       body: FutureBuilder(
  //         future: _loadedItems,
  //         builder: (context, snapshot) {
  //           if (snapshot.connectionState == ConnectionState.waiting) {
  //             return const Center(
  //               child: CircularProgressIndicator(),
  //             );
  //           }

  //           if (snapshot.hasError) {
  //             Center(
  //               child: Text(
  //                 snapshot.error.toString(),
  //                 style: const TextStyle(fontSize: 30),
  //               ),
  //             );
  //           }

  //           if (snapshot.data!.isEmpty) {
  //             return const Center(
  //               child: Text(
  //                 'No itens on Grocery list!',
  //                 style: const TextStyle(fontSize: 30),
  //               ),
  //             );
  //           }

  //           return ListView.builder(
  //               itemCount: snapshot.data!.length,
  //               itemBuilder: (ctx, index) {
  //                 return Dismissible(
  //                   key: ValueKey(snapshot.data![index].id),
  //                   direction: DismissDirection.endToStart,
  //                   onDismissed: (direction) =>
  //                       {_removeItemFromList(snapshot.data![index])},
  //                   child: ListTile(
  //                     leading: Container(
  //                       width: 24,
  //                       height: 24,
  //                       color: snapshot.data![index].category.color,
  //                     ),
  //                     title: Text(snapshot.data![index].name),
  //                     trailing: Text(snapshot.data![index].quantity.toString()),
  //                   ),
  //                 );
  //               });
  //         },
  //       ));
  // }
}


/*

// The above code uses FutureBuilder that is used to
// build widgets ONLY ONCE depending of the Future(or async) operation
// result. For this app, the list of Grocery is only loaded/updated
// on the initState(). 

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categoies.dart';

import 'package:shopping_list/models/grocery.dart';
import 'package:shopping_list/screens/new_item.dart';

class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({super.key});

  @override
  State<GroceryListScreen> createState() {
    return _GroceryListScreenState();
  }
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  List<Grocery> _groceryList = [];
  //var _isLoading = true;
  late Future<List<Grocery>> _loadedItems;

  String _errorMsg = '';

  @override
  void initState() {
    super.initState();
    _loadedItems = _loadItems();
  }

// Chaging this to use FutureBuilder
  // void _loadItems() async {
  //   final url = Uri.https(
  //     'flutter-course-df992-default-rtdb.firebaseio.com',
  //     'shopping-list.json',
  //   );

  //   try {
  //     final response = await http.get(url);

  //     if (response.statusCode >= 400) {
  //       setState(() {
  //         _errorMsg = 'Network error. Please try again later!';
  //         _isLoading = false;
  //       });
  //       return;
  //     }

  //     if (response.body == 'null') {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //       return;
  //     }

  //     final Map<String, dynamic> listData = json.decode(response.body);
  //     final List<Grocery> loadedItens = [];

  //     for (final item in listData.entries) {
  //       final category = categories.entries
  //           .firstWhere((cat) => cat.value.name == item.value['category'])
  //           .value;
  //       loadedItens.add(
  //         Grocery(
  //             id: item.key,
  //             name: item.value['name'],
  //             quantity: item.value['quantity'],
  //             category: category),
  //       );
  //     }

  //     setState(() {
  //       _groceryList = loadedItens;
  //       _isLoading = false;
  //     });
  //   } catch (error) {
  //     setState(() {
  //       _errorMsg = 'Something went wrong!';
  //       _isLoading = false;
  //     });
  //   }
  // }

  Future<List<Grocery>> _loadItems() async {
    final url = Uri.https(
      'flutter-course-df992-default-rtdb.firebaseio.com',
      'shopping-list.json',
    );

    final response = await http.get(url);

    if (response.statusCode >= 400) {
      // setState(() {
      //   _errorMsg = 'Network error. Please try again later!';
      //   _isLoading = false;
      // });
      throw Exception('Failed to fetch Grocery list!');
    }

    if (response.body == 'null') {
      return [];
    }

    final Map<String, dynamic> listData = json.decode(response.body);
    final List<Grocery> loadedItens = [];

    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere((cat) => cat.value.name == item.value['category'])
          .value;
      loadedItens.add(
        Grocery(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category),
      );
    }

    // setState(() {
    //   _groceryList = loadedItens;
    //   _isLoading = false;
    // });

    return loadedItens;
  }

  void _addNewItem() async {
    // await Navigator.of(context).push<Grocery>(
    //     MaterialPageRoute(builder: (ctx) => const NewItemScreen()));

    final newGroceryItem = await Navigator.of(context).push<Grocery>(
        MaterialPageRoute(builder: (ctx) => const NewItemScreen()));

    // New data doesn`t come from NewItemScreen anymore
    // Amd the above is not valid anymore
    if (newGroceryItem == null) {
      return;
    }

    setState(() {
      _groceryList.add(newGroceryItem);
    });
  }

  void _removeItemFromList(Grocery grocery) async {
    final index = _groceryList.indexOf(grocery);
    setState(() {
      _groceryList.remove(grocery);
    });

    final url = Uri.https(
      'flutter-course-df992-default-rtdb.firebaseio.com',
      'shopping-list/${grocery.id}.json',
    );

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      setState(() {
        _groceryList.insert(index, grocery);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // _errorMsg = 'No itens on Grocery list!';
    // Widget bodyContent = Center(
    //   child: Text(
    //     _errorMsg,
    //     style: const TextStyle(fontSize: 30),
    //   ),
    // );

    // if (_isLoading) {
    //   bodyContent = const Center(
    //     child: CircularProgressIndicator(),
    //   );
    // }

    // if (_groceryList.isNotEmpty) {
    //   bodyContent = ListView.builder(
    //       itemCount: _groceryList.length,
    //       itemBuilder: (ctx, index) {
    //         return Dismissible(
    //           key: ValueKey(_groceryList[index].id),
    //           direction: DismissDirection.endToStart,
    //           onDismissed: (direction) =>
    //               {_removeItemFromList(_groceryList[index])},
    //           child: ListTile(
    //             leading: Container(
    //               width: 24,
    //               height: 24,
    //               color: _groceryList[index].category.color,
    //             ),
    //             title: Text(_groceryList[index].name),
    //             trailing: Text(_groceryList[index].quantity.toString()),
    //           ),
    //         );
    //       });
    // }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Groceries'),
          actions: [
            IconButton(onPressed: _addNewItem, icon: const Icon(Icons.add))
          ],
        ),
        //body: bodyContent,
        body: FutureBuilder(
          future: _loadedItems,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              Center(
                child: Text(
                  snapshot.error.toString(),
                  style: const TextStyle(fontSize: 30),
                ),
              );
            }

            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No itens on Grocery list!',
                  style: const TextStyle(fontSize: 30),
                ),
              );
            }

            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (ctx, index) {
                  return Dismissible(
                    key: ValueKey(snapshot.data![index].id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) =>
                        {_removeItemFromList(snapshot.data![index])},
                    child: ListTile(
                      leading: Container(
                        width: 24,
                        height: 24,
                        color: snapshot.data![index].category.color,
                      ),
                      title: Text(snapshot.data![index].name),
                      trailing: Text(snapshot.data![index].quantity.toString()),
                    ),
                  );
                });
          },
        ));
  }
}
*/