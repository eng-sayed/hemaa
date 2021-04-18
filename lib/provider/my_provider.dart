import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:testhema/modles/categories_modle.dart';


class MyProvider extends ChangeNotifier{


  ///////////////// //////////// /////burger category
List<CategoriesModle> burgerList=[];
CategoriesModle burgerModle ;
Future <void>getBurgerCategory()async{
  List<CategoriesModle> newBurgerList=[];


  QuerySnapshot querySnapshot =await FirebaseFirestore.instance
      .collection('categories')
      .doc('rV5EIqfA7L9Vb1QSTCAo')
      .collection('Burger')
      .get();

 querySnapshot.docs.forEach((element) {
   burgerModle=CategoriesModle(
       image: element.data()['image'],
       name: element.data()['name'],
   );
   print(burgerModle.name);
   newBurgerList.add(burgerModle);
   burgerList=newBurgerList;

 });
}
get throwBurgerList {
  print("our siz= ${burgerList.length}");
  return burgerList;
}

////////////////////////////////////////////////////// recipe category

  List<CategoriesModle> recipeList=[];
  CategoriesModle recipeModle ;
  Future <void>getRecipeCategory()async{
    List<CategoriesModle> newRecipeList=[];

    QuerySnapshot querySnapshot =await FirebaseFirestore.instance
        .collection('categories')
        .doc('rV5EIqfA7L9Vb1QSTCAo')
        .collection('Recipe')
        .get();

    querySnapshot.docs.forEach((element) {
      recipeModle=CategoriesModle(
        image: element.data()['image'],
        name: element.data()['name'],
      );
      print(recipeModle.name);
      newRecipeList.add(recipeModle);
      recipeList=newRecipeList;

    });
  }
  get throwRecipeList {
    return recipeList;
  }

  ///////////////////////////////////////////// pizza category
  List<CategoriesModle> pizzaList=[];
  CategoriesModle pizzaModle ;
  Future <void>getPizzaCategory()async{
    List<CategoriesModle> newPizzaList=[];

    QuerySnapshot querySnapshot =await FirebaseFirestore.instance
        .collection('categories')
        .doc('rV5EIqfA7L9Vb1QSTCAo')
        .collection('Pizza')
        .get();

    querySnapshot.docs.forEach((element) {
      pizzaModle=CategoriesModle(
        image: element.data()['image'],
        name: element.data()['name'],
      );
      print(pizzaModle.name);
      newPizzaList.add(pizzaModle);
      pizzaList=newPizzaList;

    });
  }
  get throwPizzaList {
    return pizzaList;
  }

  ////////////////////////////////////// drink category

  List<CategoriesModle> drinkList=[];
  CategoriesModle drinkModle ;
  Future <void>getDrinkCategory()async{
    List<CategoriesModle> newDrinkList=[];

    QuerySnapshot querySnapshot =await FirebaseFirestore.instance
        .collection('categories')
        .doc('rV5EIqfA7L9Vb1QSTCAo')
        .collection('Drink')
        .get();

    querySnapshot.docs.forEach((element) {
      pizzaModle=CategoriesModle(
        image: element.data()['image'],
        name: element.data()['name'],
      );
      print(drinkModle.name);
      newDrinkList.add(drinkModle);
      drinkList=newDrinkList;

    });
  }
  get throwDrinkList {
    return drinkList;
  }


}