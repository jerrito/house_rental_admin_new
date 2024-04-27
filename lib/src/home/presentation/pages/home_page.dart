import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_rental_admin/core/size/sizes.dart';
import 'package:house_rental_admin/core/widgets/show_toast.dart';
import 'package:house_rental_admin/locator.dart';
import 'package:house_rental_admin/src/authentication/domain/entities/owner.dart';
import 'package:house_rental_admin/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:house_rental_admin/src/home/presentation/bloc/home_bloc.dart';
import 'package:house_rental_admin/src/home/presentation/pages/edit_home.dart';
import 'package:house_rental_admin/src/home/presentation/widgets/list_row_houses.dart';
import 'package:oktoast/oktoast.dart';
import '../widgets/bottom_nav_bar.dart';

class HomePage extends StatefulWidget {
  final String? uid;
  final bool? isLogin;
  final String? phoneNumber;
  const HomePage({
    super.key,
    this.uid,
    this.isLogin,
    this.phoneNumber,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authBloc = locator<AuthenticationBloc>();
  final homeBloc = locator<HomeBloc>();
  final searchController = TextEditingController();
  Owner? owner;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //debugPrint(user?.id);
    authBloc.add(const GetCacheDataEvent());
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: const Text("My House/Rooms"),
        // actions: [
        //   IconButton(
        //       onPressed: () async {
        //         final data =
        //             await context.pushNamed("addHome", queryParameters: {
        //           "id": owner?.id ?? "",
        //           "name": "${owner?.firstName} ${owner?.lastName}",
        //           "phoneNumber": owner?.phoneNumber ?? ""
        //         });
        //         if (data == "updated") {
        //           authBloc.add(const GetCacheDataEvent());
        //         }
        //       },
        //       icon: const Icon(Icons.add))
        // ],
      ),
      body: BlocListener(
        bloc: authBloc,
        listener: (context, state) {
          if (state is GetCacheDataLoaded) {
            owner = state.owner;
            debugPrint(owner?.toMap().toString());
            setState(() {});
            Map<String, dynamic> params = {
              "id": owner?.id ?? "",
              "phone_number": owner?.phoneNumber ?? "",
            };
            homeBloc.add(GetAllHousesEvent(params: params));
          }
        },
        child: BlocConsumer(
            bloc: homeBloc,
            listener: (context, state) {
              if (state is GetAllHousesLoaded) {}

              if (state is GetAllHouseError) {
                showToastInfo(
                  context: context,
                  label: state.errorMessage,
                  isFailed: true,
                );
              }
            },
            builder: (context, state) {
              if (state is GetAllHousesLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is GetAllHousesLoaded) {
                return RefreshIndicator(
                  onRefresh:_onRefresh,
                  child: ListView.builder(
                      itemCount: state.houses.docs.length,
                      itemBuilder: (context, index) {
                        final houseDetail = state.houses.docs[index].data();
                        final id = state.houses.docs[index].id;
                        return HouseRowDetails(
                          onTap: () async {
                            // context.pushNamed("editHome",
                            //     queryParameters:
                            //     {"house": state.houses.docs[index].data()});
                            final data = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditHomePage(id: id, house: houseDetail),
                              ),
                            );
                            if (data == "updated") {
                              Map<String, dynamic> params = {
                                "id": owner?.id ?? "",
                                "phone_number": owner?.phoneNumber ?? "",
                              };
                              homeBloc.add(GetAllHousesEvent(params: params));
                            }
                          },
                          bedRoomCount: houseDetail.bedRoomCount ?? 0,
                          bathRoomCount: houseDetail.bathRoomCount ?? 0,
                          houseIMageURL: houseDetail.images?[0] ?? "",
                          houseName: houseDetail.houseName ?? "",
                          amount: houseDetail.amount ?? 0,
                        );
                      }),
                );
              }
              return const SizedBox();
            }),
      ),
    );
  }

 Future _onRefresh() async{
        
                  }
}
