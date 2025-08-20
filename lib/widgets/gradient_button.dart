import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/screen_utils.dart';

class GradientButton extends StatelessWidget {
	final VoidCallback? onPressed;
	final Widget child;
	final List<Color> colors;
	final double borderRadius;

	const GradientButton({
		super.key, 
		required this.onPressed, 
		required this.child, 
		this.colors = const [AppColors.addBtnLeft, AppColors.addBtnRight], 
		this.borderRadius = 14
	});

	@override
	Widget build(BuildContext context) {
		return Material(
			color: Colors.transparent,
			child: Ink(
				decoration: BoxDecoration(
					gradient: LinearGradient(colors: colors),
					borderRadius: BorderRadius.circular(borderRadius),
				),
				child: InkWell(
					borderRadius: BorderRadius.circular(borderRadius),
					onTap: onPressed,
					child: Padding(
						padding: EdgeInsets.symmetric(
							horizontal: context.responsivePadding, 
							vertical: context.responsiveButtonPadding
						),
						child: DefaultTextStyle(
							style: Theme.of(context).textTheme.titleMedium!.copyWith(
								color: Colors.white, 
								fontWeight: FontWeight.w600,
								fontSize: context.responsiveTextSize * 0.9,
							),
							child: child,
						),
					),
				),
			)
		);
	}
}


