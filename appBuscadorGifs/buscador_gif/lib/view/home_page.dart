
import 'package:buscador_gif/service/gif_service.dart';
import 'package:buscador_gif/view/gif_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search = "";
  int _offset = 0;

  @override
  void initState(){
    super.initState();
    getAPI(_search, _offset).then((map) => print(map));    
  }

  int getCount(List data){
    if(_search == null){
      return data.length;
    }else{
      return data.length + 1;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network("https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              decoration:  const InputDecoration(
                labelText: "Pesquisa aqui",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white, fontSize: 20.0),
              textAlign: TextAlign.center,
              onSubmitted: (value) {
                setState(() {
                  _search = value;
                });
              },
            ), 
          ),
          Expanded(
            child: FutureBuilder(
              future: getAPI(_search, _offset),
              builder: (context, snapshot){
                switch(snapshot.connectionState){
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 300.0,
                      height: 300.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),    
                    );
                  default:
                    if(snapshot.hasError)
                      return Container();
                    else
                      return _createGitTable(context, snapshot);
                }
              }
            ),
          ),  
        ],
      ),
    );
  }

  Widget _createGitTable(BuildContext context, AsyncSnapshot snapshot){
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: getCount(snapshot.data["data"]),
      itemBuilder: (context, index) {
        if(_search == null || index < snapshot.data["data"].length){
          return GestureDetector(
            child: Image.network(
              snapshot.data["data"] [index] ["images"] ["fixed_height"] ["url"],
              height: 300.0,
              fit: BoxFit.cover),
            onTap: () {
              Navigator.push(context,
              MaterialPageRoute(builder: (((context) => 
              GitPage(snapshot.data["data"] [index])))));
            },
          );

        }else{
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white, size: 70.0),
                  Text("Carregar...", style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  _offset += 25;
                  getAPI(_search, _offset);
                });
              },
            ),
          );
        }
      },
    );
  }
}