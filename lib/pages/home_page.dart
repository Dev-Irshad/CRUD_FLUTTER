
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sqlite/models/data_model.dart';
import 'package:flutter_sqlite/pages/add_edit_product.dart';
import 'package:flutter_sqlite/services/db_service.dart';
import 'package:flutter_sqlite/utils/form_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../global.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  DBService dbService;


  _signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  void initState() {
    super.initState();
    dbService = new DBService();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(FontAwesomeIcons.signOutAlt,color: Colors.black,), onPressed: (){
          _signOut();
        }),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text("Products",style: TextStyle(
            color: Colors.black
        ),),
      ),
      body: ListView(

          children: [_fetchData()]),
      floatingActionButton: new FloatingActionButton(
        backgroundColor: baseColor,
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditProduct(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),

      // Here's the new attribute:

    );
  }

  Widget _fetchData() {
    return FutureBuilder<List<ProductModel>>(
      future: dbService.getProducts(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductModel>> products) {
        if (products.hasData) {
          return _buildUI(products.data);
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildUI(List<ProductModel> products) {
    List<Widget> widgets = new List<Widget>();

    widgets.add(
      new Align(
        alignment: Alignment.center,
        child: InkWell(
          onTap: () {

          },
          child: Container(
            height: 40.0,
            // width: 100,
            color: Colors.white,
            child: Center(
              child: Text(
                "Tab on the Image to Edit Product",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    widgets.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildDataTable(products)],
      ),
    );

    return Padding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widgets,
      ),
      padding: EdgeInsets.all(10),
    );
  }

  Widget _buildDataTable(List<ProductModel> model) {
    return DataTable(
      columns: [
        DataColumn(
          label: Text(
            "Image",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "Name",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "Price",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "Action",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      sortColumnIndex: 1,
      rows: model.map((data) =>

          DataRow(
            cells: <DataCell>[
              DataCell(
                  InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddEditProduct(
                              isEditMode: true,
                              model: data,
                            ),
                          ),
                        );
                      },
                      child: Image.asset("${data.productPic}"))
              ), DataCell(
                Text(
                  data.productName,
                  style: TextStyle(fontSize: 12),
                ),
              ),
              DataCell(
                Text(
                  data.price.toString(),
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              DataCell(
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      // new IconButton(
                      //   padding: EdgeInsets.all(0),
                      //   icon: Icon(Icons.edit),
                      //   onPressed: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => AddEditProduct(
                      //           isEditMode: true,
                      //           model: data,
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // ),
                      new IconButton(
                        padding: EdgeInsets.all(0),
                        icon: Icon(Icons.delete_outline),
                        onPressed: () {
                          FormHelper.showMessage(
                            context,
                            "SQFLITE CRUD",
                            "Do you want to delete this record?",
                            "Yes",
                                () {
                              dbService.deleteProduct(data).then((value) {
                                setState(() {
                                  Navigator.of(context).pop();
                                });
                              });
                            },
                            buttonText2: "No",
                            isConfirmationDialog: true,
                            onPressed2: () {
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
      )
          .toList(),
    );
  }


}
