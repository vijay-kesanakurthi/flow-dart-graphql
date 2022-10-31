import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void fetch() async {
    final HttpLink link = HttpLink(
        "https://query.flowgraph.co/?token=5a477c43abe4ded25f1e8cc778a34911134e0590");
    GraphQLClient client =
        GraphQLClient(link: link, cache: GraphQLCache(store: HiveStore()));
    QueryResult res = await client.query(QueryOptions(document: gql("""
query AccountTransactions () {
    account(id: "0x12c122ca9266c278") {
      address
      transactions (
        

      ) {
        pageInfo {
          hasNextPage
          endCursor
        }
        edges {
          node {
            hash
            time 
            status
            contractInteractions {
              id
            }
          }
        }
      }
    }
  }
""")));
    res.data?["account"]?.forEach((key, value) {
      print("$key ---> $value");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: ElevatedButton(
      child: Text("Click"),
      onPressed: () {
        fetch();
      },
    )));
  }
}
