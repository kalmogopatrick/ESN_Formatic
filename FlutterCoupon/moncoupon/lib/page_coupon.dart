import 'package:flutter/material.dart';
import 'package:moncoupon/db_coupon.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: PageCoupon(),
    );
  }
}

class PageCoupon extends StatefulWidget {
  @override
  _PageCouponState createState() => _PageCouponState();
}

class _PageCouponState extends State<PageCoupon> {
  List<Map<String, dynamic>> _allData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    final data = await SQLCoupon.getAllData();
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

  Future<void> _addData() async {
    await SQLCoupon.createData(_titleController.text, _descController.text);
    _refreshData();
  }

  Future<void> _updateData(int id) async {
    await SQLCoupon.updateData(id, _titleController.text, _descController.text);
    _refreshData();
  }

  Future<void> _deleteData(int id) async {
    await SQLCoupon.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text("Data Deleted"),
      ),
    );
    _refreshData();
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  void showBottomSheet(int? id) async {
    if (id != null) {
      final existingData =
          _allData.firstWhere((element) => element['id'] == id, orElse: () => {});
      _titleController.text = existingData['title'] ?? '';
      _descController.text = existingData['desc'] ?? '';
    }
    await showModalBottomSheet(
      elevation: 5,
      isScrollControlled: true,
      context: context,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 30,
          left: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Coupon",
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descController,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Donnez une description du coupon",
              ),
            ),
            SizedBox(height: 15),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (id == null) {
                    await _addData();
                  } else {
                    await _updateData(id);
                  }

                  _titleController.text = "";
                  _descController.text = "";
                  Navigator.of(context).pop();
                  print("Coupon ajouté avec succès!");
                },
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Text(
                    id == null ? "Ajouter Coupon" : "Modifier",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFECEAF4),
      appBar: AppBar(
        title: Text("Génial! Les coupons"),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (context, index) => Card(
                margin: EdgeInsets.all(15),
                child: ListTile(
                  title: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      _allData[index]['title'] ?? '',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  subtitle: Text(_allData[index]['desc'] ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showBottomSheet(_allData[index]['id']);
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.indigo,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _deleteData(_allData[index]['id']);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              itemCount: _allData.length,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showBottomSheet(null),
        child: Icon(Icons.add),
      ),
    );
  }
}
