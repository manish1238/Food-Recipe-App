import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodrecipe/Recipeview.dart';
import 'package:foodrecipe/recipemodal.dart';
import 'package:foodrecipe/search.dart';
import 'package:http/http.dart';

//manish
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: home(),
    );
  }
}

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  TextEditingController searchcontroller = new TextEditingController();
  List<RecipeModel> recipelist = <RecipeModel>[];


  getRecipe(String query) async {
    String url =
        "https://api.edamam.com/search?q=$query&app_id=a6ca62f7&app_key=f3047db400d2878a434b30fa6f3765a3&from=0&to=3&calories=591-722";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    // print(data);
    // log(data.toString());
    data["hits"].forEach((element) {
      RecipeModel recipeModel = new RecipeModel();
      recipeModel = recipeModel.fromMap(element["recipe"]);
      recipelist.add(recipeModel);
      setState(() {
       // isloading = false;
      });
      log(recipelist.toString());
      // recipeModel=recipeModel.fromMap(element["recipie"]);
      // recipelist.add(recipeModel);
    });
    recipelist.forEach((Recipe) {
      print(Recipe.applabel);
      print(Recipe.appcalories);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Color(0xff213A50),
              Color(0xff071938),
            ])),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SafeArea(
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          margin: EdgeInsets.symmetric(
                              horizontal: 14, vertical: 20),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    if ((searchcontroller.text)
                                            .replaceAll(" ", " ") ==
                                        " ") {
                                      print("blank search");
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => search(
                                                  searchcontroller.text)));
                                      // getRecipe(searchcontroller.text);
                                    }
                                  },
                                  child: Container(
                                    child:
                                    // Icon(
                                    //   Icons.search,
                                    //   color: Colors.blueAccent,
                                    // ),
                                    Text("Click me"),
                                    margin: EdgeInsets.fromLTRB(2, 0, 7, 0),
                                  )),
                              Expanded(
                                child: TextField(
                                  controller: searchcontroller,
                                  decoration: InputDecoration(
                                      hintText: "Search Dilecious Food Recipes",
                                      border: InputBorder.none),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ), //manish
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "what do you want to cook today",
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Lets cook something new today",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ),
                Container(
                  child:
                  // isloading
                  //     ? CircularProgressIndicator:
                            ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: recipelist.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RecipeView(
                                            recipelist[index].appurl)));
                              },
                              child: Card(
                                margin: EdgeInsets.all(20),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 0.0,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        recipelist[index].appimgurl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: 200.0,
                                      ),
                                    ),
                                    Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 7),
                                            decoration: BoxDecoration(
                                                color: Colors.black26),
                                            child: Text(
                                              recipelist[index].applabel,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ))),
                                    Positioned(
                                        right: 0,
                                        height: 40,
                                        width: 80,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10))),
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                      Icons
                                                          .local_fire_department,
                                                      size: 15),
                                                  Text(recipelist[index]
                                                      .appcalories
                                                      .toString()
                                                      .substring(0, 6)),
                                                ],
                                              ),
                                            )))
                                  ],
                                ),
                              ),
                            );
                          }),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
//manish
