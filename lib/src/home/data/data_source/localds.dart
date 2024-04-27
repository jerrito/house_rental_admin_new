import 'package:house_rental_admin/src/home/data/models/house_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

abstract class HomeLocalDatasource {
  Future<XFile> getProfileImageCamera();
  Future<List<PlatformFile>> addMultipleImage();
  Future<XFile> getProfileImageGallery();
  Future<HouseLocationModel> addLocation(Map<String, dynamic> params);
}

class HomeLocalDatasourceImpl implements HomeLocalDatasource {
  @override
  Future<XFile> getProfileImageCamera() async {
    final result = await ImagePicker().pickImage(source: ImageSource.camera);
    if (result != null) {
      XFile file = XFile(result.path);
      return file;
    } else {
      throw Exception("Error getting image");
    }
  }

  @override
  Future<XFile> getProfileImageGallery() async {
    final result = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (result != null) {
      XFile file = XFile(result.path);
      return file;
    } else {
      throw Exception("Error getting image");
    }
  }

  @override
  Future<List<PlatformFile>> addMultipleImage() async {
    final response = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: true, withData: true);

    List<PlatformFile> file = [];
    if (response!.files.isNotEmpty) {
      file.addAll(response.files.map((e) => e));

      return file;
    } else {
      throw Exception("Error getting images");
    }
  }

  @override
  Future<HouseLocationModel> addLocation(Map<String, dynamic> params) async {
    final response = HouseLocationModel.fromJson(params);
    return response;
  }
}
