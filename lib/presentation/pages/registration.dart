import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firestore_crud/data/firestore_service.dart';
import 'package:flutter_firestore_crud/data/model/reg.dart';

class AddNotePage extends StatefulWidget {
  final Reg reg;
  

  const AddNotePage({Key key, this.reg}) : super(key: key);
  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController _titleController;
  TextEditingController _descriptionController;
  // TextEditingController selectmanager;

  FocusNode _descriptionNode;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: isEditMote ? widget.reg.title : '');
    _descriptionController =
        TextEditingController(text: isEditMote ? widget.reg.description : '');
    _descriptionNode = FocusNode();
  }

  get isEditMote => widget.reg != null;
  var selectmanager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMote ? 'Edit Reg' : 'Add Reg'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                textInputAction: TextInputAction.next,
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(_descriptionNode);
                },
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Title cannot be empty";
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "title",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                focusNode: _descriptionNode,
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "description",
                  border: OutlineInputBorder(),
                ),
              ),
              StreamBuilder(
                stream: Firestore.instance.collection('dbKar').snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData)
                    const Text("Loading.....");
                  else {
                    List<DropdownMenuItem> managerItems = [];
                    for (int i = 0; i < snapshot.data.documents.length; i++) {
                      DocumentSnapshot snap = snapshot.data.documents[i];
                      managerItems.add(
                        DropdownMenuItem(
                          child: Text(
                            snap['employee'],
                          ),
                          value: snap['employee'],
                        ),
                      );
                    }
                    return Container(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                          ),
                          DropdownButton(
                            items: managerItems,
                            onChanged: (managerValue) {
                              setState(() {
                                selectmanager = managerValue;
                              });
                            },
                            value: selectmanager,
                            isExpanded: true,
                            hint: new Text(
                              "Choose Manager",
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  return Container();
                },
              ),
              const SizedBox(height: 20.0),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                child: Text(isEditMote ? "Update" : "Save"),
                onPressed: () async {
                  if (_key.currentState.validate()) {
                    try {
                      if (isEditMote) {
                        Reg reg = Reg(
                          description: _descriptionController.text,
                          title: _titleController.text,
                          manager: selectmanager,
                          id: widget.reg.id,
                        );
                        await FirestoreService().updateNote(reg);
                      } else {
                        Reg reg = Reg(
                            description: _descriptionController.text,
                            title: _titleController.text,
                            manager: selectmanager);
                        await FirestoreService().addNote(reg);
                      }
                      Navigator.pop(context);
                    } catch (e) {
                      print(e);
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
