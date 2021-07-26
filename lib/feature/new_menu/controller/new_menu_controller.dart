import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:streetary/core/model/truck_model.dart';
import 'package:streetary/routes/app_routes.dart';
import 'package:streetary/service/cloud_storage_service.dart';
import 'package:streetary/service/db_service.dart';
import 'package:streetary/service/location_service.dart';

/**
 * Created by sakibul.haque on 14,July,2021
 */

class NewMenuController extends GetxController
{

  var firstImagePath = ''.obs;
  var secondImagePath = ''.obs;
  var thirdImagePath = ''.obs;
  var fourthImagePath = ''.obs;
  var fifthImagePath = ''.obs;
  var categoryController = TextEditingController();
  var nameController = TextEditingController();
  var Controller = TextEditingController();
  var priceController = TextEditingController();
  var cuisineController = TextEditingController();
  var truckController = TextEditingController();
  var truck = ''.obs;

  RxList<TruckModel> truckList = RxList<TruckModel>();

  List<TruckModel> get trucks => truckList.value;
  RxList<String> truckListString=RxList<String>();
  RxBool isLoadTruck = false.obs;

  UploadTask? task;
  RxBool isLoading = false.obs;

  late GeoPoint _geoPosition;
  late LocationPermission permission;
  late String _location;


  void getImage(ImageSource imageSource,int position) async {
    final pickedFile = await ImagePicker().getImage(source: imageSource);
    if(pickedFile!=null){
      if(position==1){
        firstImagePath.value = pickedFile.path;
      }else if(position==2){
        secondImagePath.value = pickedFile.path;
      }else if(position==3){
        thirdImagePath.value = pickedFile.path;
      }else if(position==4){
        fourthImagePath.value = pickedFile.path;
      }else if(position==5){
        fifthImagePath.value = pickedFile.path;
      }

    }else{
      Get.snackbar(
          'Error',
          'No Image Selected',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white
      );
    }

  }


  saveMenu() async
  {
    if(categoryController.text.isEmpty){
      Get.snackbar("Category", 'Please Enter Your Menu Category',snackPosition: SnackPosition.BOTTOM);
    }else{
      if(nameController.text.isEmpty ){
        Get.snackbar("Menu name", 'Please Enter Your Menu Title',snackPosition: SnackPosition.BOTTOM);
      }else{
        if(priceController.text.isEmpty ){
          Get.snackbar("Price", 'Please Enter Menu Price',snackPosition: SnackPosition.BOTTOM);
        }else{
          if(cuisineController.text.isEmpty){
            Get.snackbar("Cuisine", 'Please Enter Menu Cuisine',snackPosition: SnackPosition.BOTTOM);

          }else{
            if(firstImagePath.value==''&& secondImagePath.value=='' && thirdImagePath.value==''&&fourthImagePath.value==''&&fifthImagePath==''){
              Get.snackbar("Menu Image", 'Please Select Atleast One Image of your Menu',snackPosition: SnackPosition.BOTTOM);
            }else{
              print(truckController.text);
              if(truckController.text.isEmpty){
                Get.snackbar("Truck", 'Please Select Your Truck',snackPosition: SnackPosition.BOTTOM);
              }else{
                try{
                  String firstimage='',secondimage='',thirdimage='',fourthimage='',fifthimage='';
                  isLoading.value = true;
                  User? user = await FirebaseAuth.instance.currentUser;
                  var truckModel;
                  truckList.forEach((element) {
                    if(element.name==truckController.text){
                      truckModel = element;
                    }
                  });
                  if(user!=null){
                    if(firstImagePath.value!=''){
                      task = CloudStorageService.uploadFile('menu_images',File(firstImagePath.value));
                      if(task == null) return;
                      final snapshot = await task!.whenComplete(() {});
                      firstimage = await snapshot.ref.getDownloadURL();
                    }
                    if(secondImagePath.value!=''){
                      task = CloudStorageService.uploadFile('menu_images',File(secondImagePath.value));
                      if(task == null) return;
                      final snapshot = await task!.whenComplete(() {});
                      secondimage = await snapshot.ref.getDownloadURL();
                    }
                    if(thirdImagePath.value!=''){
                      task = CloudStorageService.uploadFile('menu_images',File(thirdImagePath.value));
                      if(task == null) return;
                      final snapshot = await task!.whenComplete(() {});
                      thirdimage = await snapshot.ref.getDownloadURL();
                    }
                    if(fourthImagePath.value!=''){
                      task = CloudStorageService.uploadFile('menu_images',File(fourthImagePath.value));
                      if(task == null) return;
                      final snapshot = await task!.whenComplete(() {});
                      fourthimage = await snapshot.ref.getDownloadURL();
                    }
                    if(fifthImagePath.value!=''){
                      task = CloudStorageService.uploadFile('menu_images',File(fifthImagePath.value));
                      if(task == null) return;
                      final snapshot = await task!.whenComplete(() {});
                      fifthimage = await snapshot.ref.getDownloadURL();
                    }
                    DBService.instance.saveMenuInDB(
                        user.uid,
                        truckModel.id,
                        truckModel.name,
                        categoryController.text,
                        nameController.text,
                        priceController.text,
                        cuisineController.text,
                        firstimage,
                        secondimage,
                        thirdimage,
                        fourthimage,
                        fifthimage,
                      _location,
                      _geoPosition
                        );
                    isLoading.value = false;
                    Get.offNamed(Routes.VIEW_MENU);
                  }else{
                    isLoading.value = false;
                    Get.snackbar("Error", 'Something went wrong please try later',snackPosition: SnackPosition.BOTTOM);
                  }
                }catch(error){
                  isLoading.value = false;
                  Get.snackbar("Error", 'Something went wrong please try later',snackPosition: SnackPosition.BOTTOM);
                }
              }
            }
          }

        }
      }
    }
    isLoading.value = false;
  }

  checkUserGps() async
  {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    getLocationString().then((value){
      _location = value;
      _geoPosition = createGeoPoint(value);

    });
  }

  @override
  void onInit() async{
    checkUserGps();
    User? user = await FirebaseAuth.instance.currentUser;
    if(user!=null){
      List<TruckModel> list=[];
      truckList.bindStream(DBService.instance.truckStream(user.uid));
      DBService.instance.gettruckStream(user.uid).then((value) {
        print(value);
        truckListString.value = value;
        isLoadTruck.value = false;
      });
      //Stream coming from firestore
    }
    super.onInit();
  }

}