import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:blooger_api_app/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _isLoading = true; //For progress bar
  var posts;
  var imgUrl;
  //initialization
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  //Function to fetch data from JSON
  @override
  _fetchData() async {
    print("attempting");
    // const String? url =
    //      "https://www.googleapis.com/blogger/v3/blogs/YOUR BLOGGER ID/posts/?key=YOUR API KEY";
   
    final response = await http.get(Uri.parse(url));
    print(response);
    if (response.statusCode == 200) {
      //HTTP OK is 200
      final Map items = json.decode(response.body);
      var post = items['items'];

      setState(() {
        _isLoading = false;
        posts = post;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Blogger"),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                  });
                  _fetchData();
                })
          ],
        ),
        body: Center(
            child: _isLoading
                ? const CircularProgressIndicator()
                : ListView.builder(
                    itemCount: posts != null ? posts.length : 0,
                    itemBuilder: (context, i) {
                      final Post = posts[i];
                      final postDesc = Post["content"];

                      /// var imager = Post["content"]['image']['url'];

                      //All the below code is to fetch the image
                      var document = parse(postDesc);
                      //Regular expression
                      RegExp regExp = RegExp(
                        r"(https?:\/\/.*\.(?:png|jpg|gif))",
                        caseSensitive: false,
                        multiLine: false,
                      );
                      final match = regExp
                          .stringMatch(document.outerHtml.toString())
                          .toString();
                      //print(document.outerHtml);
                      //print("firstMatch : " + match);
                      //Converting the regex output to image (Slashing) , since the output from regex was not perfect for me
                      // if (match.length > 5) {
                      //   if (match.contains(".png")) {
                      //     imgUrl = match.substring(0, match.indexOf(".png"));
                      //     print(imgUrl);
                      //   } else {
                      //     imgUrl =
                      //         "https://pbs.twimg.com/profile_images/916384996092448768/PF1TSFOE_400x400.jpg";
                      //   }
                      // }
                      String description = document.body!.text.trim();
                      String title = Post['title'].toString();
                      //print(description);
                      String imgUrl = match.substring(0, match.indexOf(".png"));
                      DateTime publishedTime =
                          DateTime.parse(Post["published"]);

                      return Container(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 500.0,
                              height: 180.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                // shape: BoxShape.values,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    //check if the image is not null (length > 5) only then check imgUrl else display default img
                                    image: NetworkImage(imgUrl
                                        //      "https:${Post['author']['image']['url'].toString()}"
                                        //         .toString()
                                        //         .length >
                                        //     10
                                        // ? imgUrl.toString()
                                        // : "https://pbs.twimg.com/profile_images/916384996092448768/PF1TSFOE_400x400.jpg"
                                        )),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                title,
                                maxLines: 3,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              description.replaceAll("\n", ", "),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 15.0),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Row(
                                children: [
                                  ElevatedButton.icon(
                                      icon: const Icon(Icons.timelapse),
                                      onPressed: null,
                                      label:
                                          Text(timeago.format(publishedTime))),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  //  Text(Post['published']),
                                  ElevatedButton(
                                    child: const Text(
                                      "READ MORE",
                                    ),
                                    onPressed: () {
                                      //We will pass description to postview through an argument
                                      Navigator.of(context)
                                          .push(MaterialPageRoute<void>(
                                        builder: (BuildContext context) {
                                          return PostView(
                                              title, description, imgUrl);
                                        },
                                      ));
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                          ],
                        ),
                      );
                    },
                  )));
  }
}
