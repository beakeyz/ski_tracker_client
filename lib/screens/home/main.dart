import 'package:dadjoke_client/core/api_calls.dart';
import 'package:dadjoke_client/widgets/button.dart';
import 'package:dadjoke_client/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();

  String responseText = "Send";

  void setResponseText(String new_string) {
    if (new_string.isEmpty) {
      setState(() {
        responseText = "Send";
      });
      return;
    }
    setState(() {
      responseText = new_string;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller1.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 2,
              ),
              Text(
                "Input 🕳️",
                textScaleFactor: 3,
              ),
              SizedBox(height: 50),
              TextInputField(editingController: controller1, hintText: "what to add 💫", textInputType: TextInputType.text),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              Button(
                  callback: () {
                    String text = controller1.text;
                    //TODO make endpoint
                    //ApiUtils.makeRequest("/addthing/:$text", false, "Post", (res) {});
                    Map<String, String> h = {
                      "data": text,
                      "tag": "thing",
                    };

                    ApiUtils.postRequest("/addItem", false, h, (res) {
                      Response r = res;
                      print(r.headers);
                      setResponseText(r.body);
                      // thing
                    });
                    print("pretend we sent sm $text");
                  },
                  text: responseText),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
