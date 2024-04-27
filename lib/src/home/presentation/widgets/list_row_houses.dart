import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:house_rental_admin/assets/svgs/svg_constants.dart';
import 'package:house_rental_admin/core/size/sizes.dart';
import 'package:house_rental_admin/core/spacing/whitspacing.dart';
import 'package:house_rental_admin/core/theme/app_theme.dart';
import 'package:house_rental_admin/core/theme/colors.dart';

class HouseRowDetails extends StatelessWidget {
  final num bedRoomCount, bathRoomCount, amount;
  final String houseIMageURL, houseName;
  final void Function()? onTap;
  const HouseRowDetails(
      {super.key,
      required this.bedRoomCount,
      required this.bathRoomCount,
      required this.amount,
      required this.houseIMageURL,
      required this.houseName,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Sizes().width(context, 0.04)),
      child: GestureDetector(
        onTap:onTap,
        child: Column(
          children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                //mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        houseIMageURL,
                        fit: BoxFit.cover,
                        height: 120,
                        width: 100,
                        errorBuilder:(_,__,___){
                          return const SizedBox(
                            height: 120,
                        width: 100,
                          );
                        } ,
                      )),
                  Space().width(
                    context,
                    0.02,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                      //mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(houseName,
                            style: appTheme.textTheme.displayLarge!.copyWith(
                                fontWeight: FontWeight.w500,
                                color: houseBlack100)),
                        Space().height(
                          context,
                          0.008,
                        ),
                        Text("GHs $amount / Year",
                            style: appTheme.textTheme.displaySmall!.copyWith(
                                fontWeight: FontWeight.w400,
                                color: housePrimaryColor,
                                fontSize: 12)),
                        Space().height(
                          context,
                          0.01,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              bedSVG,
                            ),
                            Text(
                              "$bedRoomCount BedRoom",
                            ),
                            SvgPicture.asset(bathSVG),
                            Text(
                              "$bathRoomCount BathRoom",
                            )
                          ],
                        )
                      ]),
                ]),
            Space().height(context, 0.025),
          ],
        ),
      ),
    );
  }
}
