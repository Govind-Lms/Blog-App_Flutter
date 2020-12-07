import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_blog/models/blogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  String blogId= Uuid().v4();
  String title;
  String desc;

  SharedPreferences prefs;
  bool _load = false;
  @override
  void initState(){
    super.initState();
    try {
      SharedPreferences.getInstance().then((sharedPrefs) {
        setState(() {
          prefs = sharedPrefs;
          String _uid = prefs.getString('uid');
        });
      });
    } catch (e) {
      print(e.message);
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }

  }
  Widget ModernBottomSheet(){
    return Container(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(alignment: Alignment.topLeft,child: Text('Brief Data',style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),)),
              SizedBox(height: 10.0,),
              TextFormField(
                validator: (val) => val.isEmpty ? "Enter item name" : null,
                decoration: InputDecoration(
                  hintText: "Blog Title",
                  prefixIcon: Icon(Icons.title,size: 25.0,),
                  border: OutlineInputBorder(),
                ),
                onChanged: (val){
                  title= val;
                },
              ),
              SizedBox(height: 5.0,),
              TextFormField(
                keyboardType: TextInputType.name,
                validator: (val) => val.isEmpty ? "Enter item price" : null,
                decoration: InputDecoration(
                  hintText: "Blog Description",
                  prefixIcon: Icon(Icons.description,size: 25.0,),
                  border: OutlineInputBorder(),
                ),
                onChanged: (val){
                  desc= val;
                },
              ),

              SizedBox(height: 5.0,),
              GestureDetector(
                onTap: (){
                  if (title == null ||
                      title.trim().length == 0) {
                  } else if (desc == null) {
                  } else {
                    Firestore.instance
                        .collection('blogs')
                        .document(blogId)
                        .setData({
                      'title': title,
                      'blogId': blogId,
                      'desc': desc,
                    });

                    setState(() {
                      blogId = Uuid().v4();
                      title = '';
                      desc = '';
                    });
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(5.0)
                  ),
                  child: Text(
                    "Add Blogs",
                    style: TextStyle(
                        fontSize: 16, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog-App'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: (){
              setState((){_load = true;});
              logout();
            },
          )
        ],
      ),

      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0),
            child: FlatButton(
              height: 50.0,
              color: Colors.redAccent,
              onPressed: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0))),
                    context: context,
                    builder: (BuildContext context) {
                      return ModernBottomSheet();
                    });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(50.0),
                      //color: Colors.white
                    ),
                    child: Icon(
                      Icons.add,
                      size: 25.0,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10.0,),
                  Container(
                    child: Text('Add Clients',style: TextStyle(fontSize: 14.0,color: Colors.white),),
                  )
                ],
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('blogs').snapshots(),
              builder: (context,snapshot){
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator(
                    backgroundColor: Colors.redAccent,
                  ),);
                }
                List<BlogTile> customerTiles = [];
                snapshot.data.documents.forEach((doc){
                  BlogModel blogModel = BlogModel.fromDocument(doc);
                  customerTiles.add(BlogTile(blogModel));
                });
                if(customerTiles.length==0){
                  return Center(
                    child: Column(
                      children: [
                        SizedBox(height: 10.0,),
                        Icon(
                          Icons.info_outline_rounded
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text('No Blogs')
                      ],
                    ),
                  );
                }
                return ListView(
                  children: customerTiles,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  void logout() async {
    try{
      await FirebaseAuth.instance.signOut();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', null);
      prefs.setString('uid', null);
      setState((){_load = false;});
      Navigator.of(context).pushReplacementNamed('login');
    }catch(e){
      setState((){_load = false;});
      print(e.message);
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }
}
class BlogTile extends StatefulWidget {
  final BlogModel blogModel;

  const BlogTile(this.blogModel);
  @override
  _BlogTileState createState() => _BlogTileState();
}

class _BlogTileState extends State<BlogTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              offset: Offset(0,0),
              color: Colors.redAccent.withOpacity(.5)
            )
          ]
      ),
      margin: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            child: Text(
              widget.blogModel.title,
              style: TextStyle(
                  color: Colors.black,fontSize: 16.0,
                  fontWeight: FontWeight.w600
              ),
            ),
          ),
          Container(
            child: Text(
              widget.blogModel.desc,
              style: TextStyle(
                  color: Colors.black,fontSize: 14.0,
                  fontWeight: FontWeight.w400
              ),
            ),
          )
        ],
      ),
    );
  }
}



