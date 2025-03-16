import 'package:we_all_belong/components/specs/dimensions.dart';
import 'package:we_all_belong/components/specs/font_sizes.dart';
import 'package:we_all_belong/components/specs/radius_spec.dart';
import 'package:we_all_belong/core/core_shared.dart';
import 'package:we_all_belong/components/specs/colors.dart';
import 'package:we_all_belong/components/specs/paddings.dart';

class DropdownButtonCustom<DropDownType> extends StatelessWidget {
  const DropdownButtonCustom({
    required this.currentData,
    required this.defaultValue,
    super.key,
    this.onTap,
    this.valueBuilder,
    this.hintValue,
    this.textStyle,
    this.fillColor = Colors.transparent,
    this.dropdownColor = Colors.transparent,
    this.borderColor = Colors.transparent,
    this.labelText,
    this.isFirst = false,
    this.bottomPadding = Paddings.p_20,
  });

  final List<DropDownType> currentData;
  final Function(DropDownType)? valueBuilder;
  final void Function()? onTap;
  final String? hintValue;
  final DropDownType defaultValue;
  final Color? fillColor;
  final Color? dropdownColor;
  final Color? borderColor;
  final TextStyle? textStyle;
  final String? labelText;
  final bool isFirst;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    double screenHeightMultiplier = MediaQuery.of(context).size.height / 783.83;
    double screenWidthMultiplier = MediaQuery.of(context).size.width / 392.72;
    return Padding(
      padding: EdgeInsets.only(
        top: Paddings.p_5 * screenWidthMultiplier,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (labelText != null)
            Text(
              labelText!,
              style: GoogleFonts.candal(
                textStyle: TextStyle(color: Colors.white, fontSize: FontSizes.f_18 * screenWidthMultiplier),
              ),
            ),
          Container(
            height: Dimensions.d_35 * screenHeightMultiplier,
            margin: const EdgeInsets.only(top: Paddings.p_10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(RadiusSpec.r_12)),
              color: fillColor,
              border: Border.all(
                width: 3 * screenWidthMultiplier,
                color: Colors.transparent,
              ),
            ),
            child: DropdownButton<DropDownType>(
              iconSize: 0.0,
              onTap: onTap,
              isExpanded: true,
              hint: Padding(
                padding: EdgeInsets.only(left: Paddings.p_20 * screenWidthMultiplier),
                child: Text(
                  hintValue ?? 'choose...',
                  style: textStyle ??
                      TextStyle(
                        color: GenericColors.secondaryAccent,
                        fontSize: FontSizes.f_18 * screenWidthMultiplier,
                        fontWeight: FontWeight.w300,
                      ),
                ),
              ),
              value: defaultValue,
              dropdownColor: GenericColors.background,
              borderRadius: BorderRadius.circular(RadiusSpec.r_12),
              icon: const Icon(Icons.arrow_drop_down, color: GenericColors.primaryAccent),
              elevation: 0,
              style: GoogleFonts.candal(
                textStyle: textStyle ??
                    TextStyle(
                      color: GenericColors.white,
                      fontSize: FontSizes.f_18 * screenWidthMultiplier,
                      fontWeight: FontWeight.w300,
                    ),
              ),
              underline: Container(height: 0, color: Colors.transparent),

              /// This is called when the user selects an item.
              onChanged: (DropDownType? value) => valueBuilder?.call(value as DropDownType),
              items: currentData.map<DropdownMenuItem<DropDownType>>((DropDownType value) {
                return DropdownMenuItem<DropDownType>(
                  value: value,
                  child: Container(
                    margin: const EdgeInsets.only(left: Paddings.p_10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(RadiusSpec.r_12)
                    ),
                    child: Center(
                      child: Text(
                          value.toString(),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
