import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

void main() {
  runApp(StartApp());
}

class StartApp extends StatefulWidget {
  const StartApp({super.key});

  @override
  State<StartApp> createState() => _StartAppState();
}

class _StartAppState extends State<StartApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SendRequestCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          title: Text("Weather App"),
          actions: [
            PopupMenuButton<String>(
              itemBuilder:
                  (BuildContext context) => [
                    PopupMenuItem(value: 'edit', child: Text('ویرایش')),
                    PopupMenuItem(value: 'delete', child: Text('حذف')),
                  ],
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("images/pic_bg.jpg"),
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Row(
                      children: [
                        ElevatedButton(onPressed: () {}, child: Text("Find")),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'City name',
                              labelStyle: TextStyle(
                                color: const Color.fromARGB(169, 221, 221, 221),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color.fromARGB(
                                    169,
                                    180,
                                    180,
                                    180,
                                  ),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color.fromARGB(108, 0, 0, 0),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              hintText: "Pleas enter a city name",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: Text(
                      "MOUNTION VIEW",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Text(
                    "Clrear sky",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Icon(
                      Icons.sunny_snowing,
                      color: Colors.white,
                      size: 70,
                    ),
                  ),
                  Text(
                    "14"
                    "\u00b0",
                    style: TextStyle(color: Colors.white, fontSize: 60),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text("MAX", style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 6),
                          Text(
                            "14"
                            "\u00b0",
                            style: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                        child: VerticalDivider(
                          color: const Color.fromARGB(120, 51, 51, 51),
                          thickness: 2,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("MIN", style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 6),
                          Text(
                            "12"
                            "\u00b0",
                            style: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Divider(
                    // height: 10,
                    color: const Color.fromARGB(120, 51, 51, 51),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 100,
                    // color: Colors.white,
                    // color: Colors.white,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                "Fri, 8pm",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                              Icon(
                                Icons.cloud_queue_sharp,
                                color: Colors.white,
                              ),
                              Text(
                                "12"
                                "\u00b0",
                                style: TextStyle(
                                  color: const Color.fromARGB(
                                    255,
                                    255,
                                    255,
                                    255,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 5),
                  Divider(
                    // height: 10,
                    color: const Color.fromARGB(120, 51, 51, 51),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Wind Speed",
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          Text(
                            "4.73 m/s",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                        child: VerticalDivider(
                          color: const Color.fromARGB(120, 51, 51, 51),
                          thickness: 2,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "sunrise",
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          Text(
                            "6:19 PM",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                        child: VerticalDivider(
                          color: const Color.fromARGB(120, 51, 51, 51),
                          thickness: 2,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "sunset",
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          Text(
                            "9:30 AM",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                        child: VerticalDivider(
                          color: const Color.fromARGB(120, 51, 51, 51),
                          thickness: 2,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "humidity",
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          Text(
                            "72%",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void SendRequestCurrentWeather() async{
    var apikey = "33199fbedb3ae7c66ce44cc662bca1ac";
    var cityname = "tehran";
    var response = await Dio().get("https://api.openweathermap.org/data/2.5/weather",
    queryParameters: {"q":cityname, "appid":apikey, "units":"mrtric"}
    );

    print(response.data);
    print(response.statusCode);
  }
}
