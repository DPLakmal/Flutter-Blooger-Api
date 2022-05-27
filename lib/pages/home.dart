import 'package:flutter/material.dart';

class PostView extends StatelessWidget {
  var desc, title, image;

  PostView(String title, String desc, String image) {
    this.desc = desc;
    this.title = title;
    this.image = image;
  }
  @override
  Widget build(BuildContext context) {
    if (desc.toString().contains("\n\n\n\n")) {
      desc = desc.toString().replaceAll("\n\n\n\n", "\n\n");
    }

    if (desc.toString().contains("\n\n\n")) {
      desc = desc.toString().replaceAll("\n\n\n", "\n");
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blogger"),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Container(
              width: 500.0,
              height: 180.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    fit: BoxFit.fill,
                    //check if the image is not null (length > 5) only then check imgUrl else display default img
                    image: NetworkImage(image.toString().length > 10
                        ? image.toString()
                        : "https://pbs.twimg.com/profile_images/916384996092448768/PF1TSFOE_400x400.jpg")),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Text(
              desc,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17.0,
              ),
            ),
          ),
        ],
      )),
    );
  }
}
