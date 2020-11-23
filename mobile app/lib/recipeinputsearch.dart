import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import './recipeslist.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './jsonstructure.dart';
import 'package:http_middleware/http_middleware.dart';
import 'package:http_logger/http_logger.dart';
import 'dart:io';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cupertino_tabbar/cupertino_tabbar.dart' as CupertinoTabBar;


class RecipeInputPage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<RecipeInputPage> {
  bool asTabs = false;
  // String selectedValue;
  List<int> selectedItems = [];
  String selectedNutrient;
  SharedPreferences prefs;
  String selectedStatus;
  String selectedVegValue;
  List<String> noIngredientsstringsList = [];
  String dropdownString;
  List<String> ingredients = [];
  bool _loading = false;



  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print(path);
    return File('$path/ingredients.txt');
  }

  Future<File> writeTest(int counter) async {
    final file = await _localFile;

    // Write the file.
    return file.writeAsString('$counter');
  }

  Future<String> readIngredients() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return "error";
    }
  }

  Future<http.Response> createList() {
    List<String> selectedItemList = selectedItems.map((i)=>items[i].value.toString()).toList();
    Preferences preferences = Preferences(selectedStatus, noIngredientsstringsList, selectedVegValue, selectedItemList, selectedNutrient);
    String jsonPreferences = jsonEncode(preferences);
    return http.post(
      'https://bbg5tf4j2d.execute-api.us-east-1.amazonaws.com/Test/ingredientstorecipes',
      headers: <String, String>{
        // "content-Type": "application/json",
        // "accept" : "application/json",
      },
      body: jsonPreferences
    );
  }

  _print(){
    List<String> selectedItemList = selectedItems.map((i)=>items[i].value.toString()).toList();
    Preferences preferences = Preferences(selectedStatus, noIngredientsstringsList, selectedVegValue, selectedItemList, selectedNutrient);
    String jsonPreferences = jsonEncode(preferences);
    print(jsonPreferences);
  }
  List<DropdownMenuItem> items = [];

  // final List<DropdownMenuItem> items = [DropdownMenuItem(
  // child: Text("chicken"),
  // value: "chicken",
  // ), DropdownMenuItem(
  // child: Text("beef"),
  // value: "beef",
  // ), DropdownMenuItem(
  // child: Text("tomato"),
  // value: "tomato",
  // ), DropdownMenuItem(
  // child: Text("potato"),
  // value: "potato",
  // )];
  final List<DropdownMenuItem> nutrients = [DropdownMenuItem(
  child: Text("Overall"),
  value: "Overall",
  ), DropdownMenuItem(
    child: Text("Protein"),
    value: "Protein",
  ), DropdownMenuItem(
    child: Text("Iron"),
    value: "Iron",
  ),DropdownMenuItem(
    child: Text("Calcium"),
    value: "Calcium",
  )];


  Future<String> _loadIngredients() async {
    final path = await _localPath;
    print(path);
    return await rootBundle.loadString('assets/ingredients.txt');
  }

  @override
  void initState() {
    super.initState();
    selectedStatus = "";
    selectedVegValue = "";
    noIngredientsstringsList= [];
    _load();

  }

  Future<void> _load() async{
    dropdownString = await _loadIngredients();
    // dropdownString = "olive oil\nlard\nheavy whipping cream\ncanola oil\nsoy sauce\nplain yogurt\npeanut oil\nunsalted butter\nshortening\nsweet italian sausage\nbuttermilk\nghee (clarified butter)\nlime juice\nzucchini\ncoconut oil\nketchup\nacorn squash\ngarlic\ndried chives\nsweet potatoes\nvegetable shortening\ncarrots\nraisins\nchestnuts\ncream cheese\norange juice\navocados\nricotta cheese\nmashed sweet potatoes\npecans\ncanned pumpkin\nspaghetti squash\ntomatoes\nbrown rice\nleg of lamb\nbanana peppers\ngreen bell peppers\nonions\ncornstarch\nbutternut squash\nmargarine\nbacon grease\nfirm tofu\ngrapeseed oil\nwhite rice\ncelery\ncoconut milk\neggplant\njalapeno peppers\npork loin\ncorn oil\napples\nsesame oil\ncucumber\nsun-dried tomatoes\nwalnuts\nitalian sausage\nyellow onions\nbeef sausage\nsoft tofu\ndried figs\ncranberries\nevaporated milk\ndried shiitake mushrooms\nchia seeds\nlamb shank\nchickpea flour (besan)\ndried apricots\nskim milk\noat bran\nlentil sprouts\navocado oil\nmillet flour\ncooked shrimp\nbaked potatoes\nmacadamia nuts\npears\nromaine lettuce\nalmonds\nalmond paste\ncashew butter\npork shoulder\nserrano peppers\nsoy milk\ncooked brown rice\ncoconut water\nvital wheat gluten\nrendered bacon fat\ncheddar cheese\nscallops\nfat free sour cream\nlamb ribs\nmangos\nbroccoli\nbaby carrots\nbeef chuck pot roast\npapaya\nblack beans\nneufchatel cheese\nhazelnuts\ngolden delicious apples\nblackberries\ngranny smith apples\nsavoy cabbage\nstewed tomatoes\nfrozen strawberries\noranges\nwatermelon\nbrie cheese\ncanned shrimp\ncooked wild rice\nbananas\nnavy beans\nkidney beans\nlemons\nblue cheese\nfat free cream cheese\nblueberries\nsweetened condensed milk\nsauerkraut\nbok choy\nsmoked salmon\nspinach\nsoft goat cheese\nsoybean oil\nstrawberries\nalmond butter\ntamari\nsweet onions\nsnow peas\nchorizo\nlow fat sour cream\nhoneydew melon\nitalian salad dressing\nsharp cheddar cheese\nleeks\nmustard greens\namerican cheese\nwatercress\ncilantro\napple juice\ndry roasted peanuts\nnonfat cottage cheese\nfeta cheese\nsalted butter\nfrozen raspberries\nunsweetened soy milk\neggnog\nhubbard squash\narugula\nsoybean sprouts\nmuenster cheese\nlondon broil\nsweet white corn\ngreen tomatoes\nnopales\nflax seeds\npickled beets\nraspberries\nlimes\npineapple\ncabbage\nparsnips\nbaked beans\nswiss chard\nmiso\nmulberries\nraw peanuts\nmorel mushrooms\nrhubarb\nvanilla soy milk\nwalnut oil\nturnips\nsummer squash\nred cabbage\ngrapes\ntempeh\npomegranates\ndandelion greens\ncanned ham\nkale\nnonfat greek yogurt\nqueso fresco\nred delicious apples\nnavel oranges\ntangerines\nasparagus\nred leaf lettuce\ncanned salmon\ndill pickles\nprovolone cheese\ngreat northern beans\ngrapefruit\nwhipped cream\nradishes\ndulce de leche\ngrape juice\nspring onions\nroasted ham\nswiss cheese\nquinces\nflaxseed oil\ncooked butternut squash\nalmond oil\nromano cheese\ngruyere cheese\nshiitake mushrooms\nparsley\ncauliflower\nshallots\nhemp seeds\ngouda cheese\nginger\npepperoni\nwater\npink grapefruit\nroasted turkey breast\nelderberries\nasian pears\npeas\nenoki mushrooms\ntangerine juice\nkimchi\nplantains\nskirt steak\narrowroot flour\nadzuki beans\ndried peaches\ncooked spinach\nsmoked haddock\ncolby cheese\ncoleslaw dressing\nkumquats\ngrated parmesan\npotato flour\nalfalfa sprouts\nplums\nchives\nbartlett pears\nwheat flour\ntomatillos\ncorn relish\nchicken spread\ncooked couscous\nfontina cheese\nqueso asadero\ngrapefruit juice\nsalami\ndried pears\nokra\nsplit peas\nimitation sour cream\ngala apples\ncanned mushrooms\nricotta cheese\ndry roasted sunflower seeds\nhazelnut oil\nlowfat buttermilk\npistachio nuts\ncooked beets\nlow-fat yogurt\nolives\ndried apples\ngooseberries\nturnip greens\nlight whipping cream\nroquefort\nedam cheese\nnonfat vanilla yogurt\nshredded coconut\nlowfat chocolate milk\nedamame\ncanned kidney beans\nyellow sweet corn\nmung bean sprouts\nred chili peppers\nnectarines\ncremini mushrooms\nbamboo shoots\ngreen chili peppers\ngreen olives\nhoney mustard salad dressing\nbeef flank steak\nbarley malt flour\nlima beans\nroasted turkey\nbosc pear\nimitation crab meat\ncheddar cheese\nrussian dressing\ngrated parmesan cheese\nprune puree\nsuccotash\nred anjou pears\ncandied fruit\ncanned green beans\npoached eggs\ndried cranberries\ndry-roasted cashews\nmexican blend cheese\nmustard oil\narrowroot\nmozzarella\ncooked pumpkin\nrendered chicken fat\nradish sprouts\ncanned tomato paste\n";
    prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        selectedVegValue = prefs.getString('veg');
        noIngredientsstringsList = prefs.getStringList('noIngredients');
        selectedStatus = prefs.getString('status');
        ingredients = dropdownString.split('\n');
        for (String i in ingredients) {
          items.add(DropdownMenuItem(
            child: Text(i),
            value: i,
          ));
        }
      _loading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Widget> widgets;
    widgets = {
      "Select Ingredients": SearchableDropdown.multiple(
        items: items,
        selectedItems: selectedItems,
        hint: Text("Select items"),
        searchHint: "Select items",
        validator: (selectedItemsForValidator) {
          if (selectedItemsForValidator.length < 3) {
            return ("Must select at least 3 items");
          }
          return (null);
        },
        onChanged: (value) {
          setState(() {
            selectedItems = value;
          });
        },
        closeButton: (selectedItems) {
          return (((selectedItems.length>1)&(selectedItems.length<6))
              ? "Save ${selectedItems.length == 1 ? '"' + items[selectedItems.first].value.toString() + '"' : '(' + selectedItems.length.toString() + ')'}"
              : "Save without selection");
        },
        isExpanded: true,
      ),
      "Nutrients Focus": SearchableDropdown.single(
        items: nutrients,
        value: selectedNutrient,
        hint: "Select one",
        searchHint: "Select one",
        validator: (selectedNutrient) {
          if (selectedNutrient== null) {
            return ("Must select one");
          }
          return (null);
        },
        onChanged: (value) {
          setState(() {
            selectedNutrient = value;
          });
        },
        isExpanded: true,
      ),
    };

    return _loading != true
        ? new Scaffold(body: new Center(child: new CircularProgressIndicator()))
        : new MaterialApp(
      home: asTabs
          ? DefaultTabController(
        length: widgets.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Recipe Input"),
            backgroundColor: Color(0xFFF37280),
            // actions: appBarActions,
            bottom: TabBar(
              isScrollable: true,
              tabs: Iterable<int>.generate(widgets.length)
                  .toList()
                  .map((i) {
                return (Tab(
                  text: (i + 1).toString(),
                ));
              }).toList(), //widgets.keys.toList().map((k){return(Tab(text: k));}).toList(),
            ),
          ),
          body: Container(
            padding: EdgeInsets.all(20),
            child: TabBarView(
              children: widgets
                  .map((k, v) {
                return (MapEntry(
                    k,
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(children: [
                        Text(k),
                        SizedBox(
                          height: 20,
                        ),
                        v,
                      ]),
                    )));
              })
                  .values
                  .toList(),
            ),
          ),
        ),
      )
          : Scaffold(
        appBar: AppBar(
          title: Text("Recipe Input"),
          backgroundColor: Color(0xFFF37280),
          // actions: appBarActions,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: widgets
                .map((k, v) {
              return (MapEntry(
                  k,
                  Center(
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          margin: EdgeInsets.all(20),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                Text("$k:", style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15
                                )),
                                v,
                              ],
                            ),
                          )))));
            })
                .values
                .toList(),
          ),

        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Navigator.pop(context);
            // selectedItems.map((i)=>i.toString()).toList(),
            // _print();
            createList();
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ListViewPage()));
          },
          label: Text('Search Recipes', style: TextStyle(
            fontSize: 20
          )),
          icon: Icon(Icons.arrow_forward_ios),
          backgroundColor: Colors.pink,
      ),
    ),
    );
  }
}