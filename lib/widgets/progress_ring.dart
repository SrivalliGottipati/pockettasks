import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ProgressRing extends StatelessWidget {
	final int done;
	final int total;
	final double size;

	const ProgressRing({super.key, required this.done, required this.total, this.size = 88});

	@override
	Widget build(BuildContext context) {
		final fraction = total == 0 ? 0.0 : (done / total).clamp(0.0, 1.0);
		return SizedBox(
			height: size,
			width: size,
			child: CustomPaint(
				painter: _RingPainter(
					fraction: fraction,
					backgroundColor: AppColors.ringTrack,
					progressColor: AppColors.ringProgress,
				),
				child: Center(
					child: Text('$done/$total', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
				),
			),
		);
	}
}

class _RingPainter extends CustomPainter {
	final double fraction;
	final Color backgroundColor;
	final Color progressColor;

	_RingPainter({required this.fraction, required this.backgroundColor, required this.progressColor});

	@override
	void paint(Canvas canvas, Size size) {
		final center = Offset(size.width / 2, size.height / 2);
		final radius = math.min(size.width, size.height) / 2;
		const strokeWidth = 8.0;
		final bgPaint = Paint()
			..style = PaintingStyle.stroke
			..strokeCap = StrokeCap.round
			..strokeWidth = strokeWidth
			..color = backgroundColor;

		final progressPaint = Paint()
			..style = PaintingStyle.stroke
			..strokeCap = StrokeCap.round
			..strokeWidth = strokeWidth
			..color = progressColor;

		final rect = Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);

		canvas.drawArc(rect, -math.pi / 2, 2 * math.pi, false, bgPaint);
		canvas.drawArc(rect, -math.pi / 2, fraction * 2 * math.pi, false, progressPaint);
	}

	@override
	bool shouldRepaint(covariant _RingPainter oldDelegate) {
		return oldDelegate.fraction != fraction || oldDelegate.progressColor != progressColor || oldDelegate.backgroundColor != backgroundColor;
	}
}


